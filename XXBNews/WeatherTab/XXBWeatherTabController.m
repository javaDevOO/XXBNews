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

#import "XXBWeatherInfoViewController.h"

@interface XXBWeatherTabController ()

@property (nonatomic, strong) NSArray *weatherInfos;
@property (nonatomic, strong) UIPageViewController *pageController;

@end

@implementation XXBWeatherTabController
{
    NSMutableArray *cityArray;
    UILabel *label;
    __block dispatch_semaphore_t getInfoFinishSemaphore;
}

- (id) init
{
    self = [super init];
    if(self)
    {
        //设置tabbarItem最好放在init里面
        [self initTabbarItemWithTitle:@"天气" imageNamed:@"tabbar_more" selectedImageNamed:@"tabbar_more_selected"];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(manageCity)];
        
        getInfoFinishSemaphore = dispatch_semaphore_create(1);
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //调用了LocationTool的初始化方法
    [XXBLocationTool sharedInstance];
    //接收到定位成功的回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocCity) name:@"LocationCity" object:nil];
    
    //读取default中存储的城市
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *city = [defaults objectForKey:@"currentCity"];
    if(city == nil)
    {
        city = @"珠海";
    }
    cityArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedCities"]];
    if([cityArray count] == 0)
    {
        cityArray = [NSMutableArray arrayWithArray:[NSArray arrayWithObjects:@"深圳",@"珠海",@"汕头",nil]];
    }
    label.text = [cityArray componentsJoinedByString:@"---"];
    [self loadWeatherData:cityArray];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    self.pageController.view.frame = self.view.bounds;
    [self.view addSubview:self.pageController.view];
    
    //此时weatherinfo的数据还没有返回，需要进行同步
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        dispatch_semaphore_wait(getInfoFinishSemaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            XXBWeatherInfoViewController *initialViewController =[self viewControllerAtIndex:0];// 得到第一页
            NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
            [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            dispatch_semaphore_signal(getInfoFinishSemaphore);
        });
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateLocCity
{
    XXBCity *city = [XXBLocationTool sharedInstance].locationCity;
    if(city && city.city)
    {
        DDLogDebug(@"定位到城市：%@",city.city);
        [self loadWeatherData:[NSArray arrayWithObject:city.city]];
    }
}

- (void) loadWeatherData:(NSArray *)cities
{
    dispatch_semaphore_wait(getInfoFinishSemaphore, DISPATCH_TIME_FOREVER);
    [XXBWeatherManager getWeatherDataWithCity:cities
          success:^(id json)
         {
             DDLogDebug(@"get the weather successfully");
             //MJExtention扩展可以将json数据变成model
             //model的属性要和json的关键字对应上，否则会被置为nil
             [XXBWeatherInfo setupObjectClassInArray:^NSDictionary *{
                 return [XXBWeatherInfo objectClassInArray];
             }];
             NSArray *weatherInfos = [XXBWeatherInfo objectArrayWithKeyValuesArray:json[@"results"]];
             self.weatherInfos = weatherInfos;
             for(XXBWeatherInfo *info in self.weatherInfos)
             {
                 info.date = json[@"date"];
             }
             dispatch_semaphore_signal(getInfoFinishSemaphore);
             //TODO：获取数据成功了，接下来就要将数据显示在界面上
         }
          failure:^(NSError *error)
         {
             DDLogDebug(@"get weather info error");
             dispatch_semaphore_signal(getInfoFinishSemaphore);
         }
     ];
    
    //最简单的数据持久化
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:city forKey:@"currentCity"];
}

- (void) manageCity
{
    XXBManageCityController *manageCityController = [[XXBManageCityController alloc] init];
    manageCityController.hidesBottomBarWhenPushed = YES;
    manageCityController.weatherInfos = self.weatherInfos;
    [self.navigationController pushViewController:manageCityController animated:YES];
}

// 得到相应的VC对象
- (XXBWeatherInfoViewController *)viewControllerAtIndex:(NSInteger)index {
    if (([self.weatherInfos count] == 0) || (index >= [self.weatherInfos count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    XXBWeatherInfo *info = [self.weatherInfos objectAtIndex:index];
    XXBWeatherInfoViewController *dataViewController =[[XXBWeatherInfoViewController alloc] initWithWeatherInfo:info];
    DDLogDebug(@"create new view controller");
    return dataViewController;
}
// 根据数组元素值，得到下标值
- (NSInteger)indexOfViewController:(XXBWeatherInfoViewController *)viewController {
    return [self.weatherInfos indexOfObject:viewController.weatherInfo];
}

#pragma mark- UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(XXBWeatherInfoViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self indexOfViewController:(XXBWeatherInfoViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.weatherInfos count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

@end
