//
//  FirstPageViewController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/5.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBWeatherTabController.h"
#import "XXBMainTabBarController.h"
#import "XXBWeatherManager.h"
#import "XXBWeatherInfo.h"
#import "MJExtension.h"
#import "XXBSelectCityViewController.h"
#import "XXBLocationTool.h"
#import "XXBManageCityController.h"
#import "XXBWeatherInfoView.h"

#import "UIDevice+Resolutions.h"

#import "SwipeView.h"

@interface XXBWeatherTabController () <SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic, strong) SwipeView *swipeView;
@property (nonatomic, strong) UIActivityIndicatorView* indicator;
@property (nonatomic, strong) UIPageControl *pageControl;

@end


@implementation XXBWeatherTabController
{
    UIBarButtonItem *refreshBtn;
    __block dispatch_semaphore_t getInfoFinishSemaphore;
}


/**
 *  苹果建议不要在initializer和dealloc中使用accessor methods，即不要使用self.property=XXX
 *  最主要的原因是此时对象的状况不确定，尚未完全初始化完毕，而导致一些问题的发生。
 *  例如这个类或者子类重写了setMethod,里面调用了其他一些数据或方法,而这些数据和方法需要一个已经完全初始化好的对象。
 *  而在init中,对象的状态是不确定的。
 *
 *  @return <#return value description#>
 */
- (id) init
{
    self = [super init];
    if(self)
    {
        // 设置tabbarItem最好放在init里面
        [self initTabbarItemWithTitle:NSLocalizedString(@"weatherTabTitle",@"") imageNamed:@"tabbar_more" selectedImageNamed:@"tabbar_more_selected"];
        getInfoFinishSemaphore = dispatch_semaphore_create(1);
        
        // 调用了LocationTool的初始化方法
        [XXBLocationTool sharedInstance];
        //接收到定位成功的回调
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocCity) name:@"LocationCity" object:nil];
        
        // 读取default中存储的城市
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *city = [defaults objectForKey:@"currentCity"];
        // 第一次安装，定位到城市
        if(city == nil)
        {
            city = @"珠海";
        }
        
        _cityArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedCities"]];
        
        // 第一次安装，没有城市列表
        if([_cityArray count] == 0 || ([_cityArray count]==1 && [[_cityArray lastObject] isEqualToString:@"+"]))
        {
            _cityArray = [NSMutableArray arrayWithArray:[NSArray arrayWithObjects:@"深圳",@"珠海",@"汕头",@"+",nil]];
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    DDLogDebug(@"%@",@"weather tab view did load");
    
    // 初始化导航栏按钮
    refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    UIBarButtonItem *manageBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(manageCity)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:manageBtn,refreshBtn, nil];
    
    
    [self setupSwipeView];
    [self setupPageController];
    [self setupIndicator];
    
    [self loadWeatherData:self.cityArray];
    
    // 此时weatherinfo的数据还没有返回，需要进行同步
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        //要等到返回天气数据时才往下执行
        dispatch_semaphore_wait(getInfoFinishSemaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicator stopAnimating];
            [self.swipeView reloadData];
            dispatch_semaphore_signal(getInfoFinishSemaphore);
        });
    });
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.swipeView reloadData];
    self.pageControl.hidden = NO;
    [self updatePageControl];
}


- (void) setupSwipeView
{
    self.swipeView = [[SwipeView alloc] init];
    self.swipeView.frame = self.view.bounds;
    self.swipeView.delegate = self;
    self.swipeView.dataSource = self;
    [self.view addSubview:self.swipeView];
}


- (void) setupPageController
{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 34,self.view.bounds.size.width, 10)];
    self.pageControl.numberOfPages = self.swipeView.numberOfPages;
    self.pageControl.currentPage = self.swipeView.currentPage;
    self.title = [self.cityArray objectAtIndex:self.pageControl.currentPage];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self.navigationController.navigationBar addSubview:self.pageControl];
}


# pragma swipeview datasource and delegate
- (NSInteger) numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    // 最后一个城市名是+号，不算
    return [self.cityArray count]-1;
}


- (UIView *) swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    XXBWeatherInfoView *infoView = nil;
    XXBWeatherInfo *info = [self.weatherInfos objectAtIndex:index];
    // TODO：重用view
    if(view  == nil)
    {
        DDLogDebug(@"%@", @"alloc a new uiview");
        view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
        
        if([self.weatherInfos count] == 0)
        {
            [self.indicator startAnimating];
            //[view addSubview:self.indicator];
        }
        else
        {
            infoView = [[XXBWeatherInfoView alloc] initWithWeatherInfo:info];
            infoView.tag = 1;
            infoView.frame = self.view.bounds;
            [view addSubview:infoView];
        }
    }
    else
    {
        DDLogDebug(@"%@", @"reuse the uiview");
        infoView = (XXBWeatherInfoView *)[view viewWithTag:1];
        
    }
    infoView.weatherInfo = info;
    return view;
}

#pragma mark -- swipeview delegate
- (void) swipeViewWillBeginDecelerating:(SwipeView *)swipeView;
{
    DDLogDebug(@"swipeViewWillBeginDecelerating at %d",swipeView.currentPage);
    [self updatePageControl];
}


- (void) swipeViewDidEndDecelerating:(SwipeView *)swipeView;
{
    DDLogDebug(@"swipeViewDidEndDecelerating at %d",swipeView.currentPage);
    [self updatePageControl];
}

- (void) swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView;
{
    DDLogDebug(@"swipeViewCurrentItemIndexDidChange at %d",swipeView.currentPage);
    [self updatePageControl];
}


- (void) updatePageControl
{
    if(self.pageControl.numberOfPages != self.swipeView.numberOfPages)
        self.pageControl.numberOfPages = self.swipeView.numberOfPages;
    if(self.pageControl.currentPage != self.swipeView.currentPage)
        self.pageControl.currentPage = self.swipeView.currentPage;
    self.title = [self.cityArray objectAtIndex:self.pageControl.currentPage];
}


- (void) updateLocCity
{
    XXBCity *city = [XXBLocationTool sharedInstance].locationCity;
    if(city && city.city)
    {
        DDLogDebug(@"定位到城市：%@",city.city);
        //[self loadWeatherData:[NSArray arrayWithObject:city.city]];
    }
}


- (void) setupIndicator
{
    //初始化:
    self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.indicator setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    self.indicator.backgroundColor = [UIColor grayColor];
    self.indicator.alpha = 0.5;
    self.indicator.layer.cornerRadius = 6;
    self.indicator.layer.masksToBounds = YES;
    [self.view addSubview:self.indicator];
}


- (void) loadWeatherData:(NSArray *)cities
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        dispatch_semaphore_wait(getInfoFinishSemaphore, DISPATCH_TIME_FOREVER);
        
        [XXBWeatherManager getWeatherDataWithCity:cities
                                          success:^(id json)
         {
             DDLogDebug(@"get the weather successfully");
             //MJExtention扩展可以将json数据变成model
             [XXBWeatherInfo setupObjectClassInArray:^NSDictionary *{
                 return [XXBWeatherInfo objectClassInArray];
             }];
             NSArray *weatherInfos = [XXBWeatherInfo objectArrayWithKeyValuesArray:json[@"results"]];
             self.weatherInfos = [NSMutableArray arrayWithArray:weatherInfos];
             for(XXBWeatherInfo *info in self.weatherInfos)
             {
                 info.date = json[@"date"];
             }
             dispatch_semaphore_signal(getInfoFinishSemaphore);
             //TODO：获取数据成功了，接下来就要将数据显示在界面上
         }
                                          failure:^(NSError *error)
         {
             // TODO:要是没有网络连接时还要处理
             DDLogDebug(@"get weather info error");
             dispatch_semaphore_signal(getInfoFinishSemaphore);
         }];
    });
}


- (void) manageCity
{
    XXBManageCityController *manageCityController = [[XXBManageCityController alloc] initWithCityArray:self.cityArray];
    manageCityController.hidesBottomBarWhenPushed = YES;
    manageCityController.weatherInfos = self.weatherInfos;
    manageCityController.cityCellSelDelegate = self;
    self.pageControl.hidden = YES;
    
    [self.navigationController pushViewController:manageCityController animated:YES];
}


#pragma manage city view delegate
//跳转到相应的页面
- (void) manageCityViewDidSelectCityCell:(NSString *)city
{
    NSInteger index = [self.cityArray indexOfObject:city];
    DDLogDebug(@"manage city view did select city %@%d",city, index);
    [self.swipeView scrollToPage:index duration:0];
}


// TODO: 从服务器更新天气数据
- (void) refresh
{
    DDLogDebug(@"%@",@"refresh the weather");
    [self.indicator startAnimating];
    __block NSInteger index = self.pageControl.currentPage;
    __block NSArray *cities = [NSArray arrayWithObject:[self.cityArray objectAtIndex:index]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        // 增加延时，用于测试
        [NSThread sleepForTimeInterval:2];
        [XXBWeatherManager getWeatherDataWithCity:cities
                                          success:^(id json)
         {
             // MJExtention扩展可以将json数据变成model
             [XXBWeatherInfo setupObjectClassInArray:^NSDictionary *{
                 return [XXBWeatherInfo objectClassInArray];
             }];
             NSArray *weatherInfos = [XXBWeatherInfo objectArrayWithKeyValuesArray:json[@"results"]];
             XXBWeatherInfo *info = weatherInfos[0];
             info.date = json[@"date"];
             [self.weatherInfos replaceObjectAtIndex:index withObject:info];
             DDLogDebug(@"update the weather successfully");
             
             [self.swipeView reloadItemAtIndex:index];
             [self.indicator stopAnimating];
         }
                                          failure:^(NSError *error)
         {
             // TODO:要是没有网络连接时还要处理
             DDLogDebug(@"get weather info error");
             [self.indicator stopAnimating];
         }];
    });
}


- (void) dealloc
{
    // swipeview建议做法
    self.swipeView.delegate = nil;
    self.swipeView.dataSource = nil;
}

@end
