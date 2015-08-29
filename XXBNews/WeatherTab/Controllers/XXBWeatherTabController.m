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

@end


@implementation XXBWeatherTabController
{
    UIBarButtonItem *refreshBtn;
    __block dispatch_semaphore_t getInfoFinishSemaphore;
}


- (id) init
{
    self = [super init];
    if(self)
    {
        // 设置tabbarItem最好放在init里面
        [self initTabbarItemWithTitle:NSLocalizedString(@"weatherTabTitle",@"") imageNamed:@"tabbar_more" selectedImageNamed:@"tabbar_more_selected"];
        getInfoFinishSemaphore = dispatch_semaphore_create(1);
        
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
    
    self.swipeView = [[SwipeView alloc] init];
    self.swipeView.frame = self.view.bounds;
    self.swipeView.delegate = self;
    self.swipeView.dataSource = self;
    [self.view addSubview:self.swipeView];
    
    [self setupIndicator];
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

    self.cityArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedCities"]];
    
    // 第一次安装，没有城市列表
    if([self.cityArray count] == 0 || ([self.cityArray count]==1 && [[self.cityArray lastObject] isEqualToString:@"+"]))
    {
        self.cityArray = [NSMutableArray arrayWithArray:[NSArray arrayWithObjects:@"深圳",@"珠海",@"汕头",nil]];
    }
    [self loadWeatherData:self.cityArray];
    
    // 此时weatherinfo的数据还没有返回，需要进行同步
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        //要等到返回天气数据时才往下执行
        dispatch_semaphore_wait(getInfoFinishSemaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicator stopAnimating];
            [self.swipeView reloadData];
        });
    });
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.swipeView reloadData];
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
            [view addSubview:self.indicator];
        }
        else
        {
            infoView = [[XXBWeatherInfoView alloc] initWithWeatherInfo:info];
            infoView.tag = 1;
            infoView.frame = self.view.bounds;
            infoView.contentSize = CGSizeMake([UIDevice currentWidth],[UIDevice currentHeight]*3);
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
    
}


- (void) dealloc
{
    // swipeview建议做法
    self.swipeView.delegate = nil;
    self.swipeView.dataSource = nil;
}

@end
