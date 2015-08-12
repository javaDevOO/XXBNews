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

@interface XXBWeatherTabController ()

@property (nonatomic, strong) XXBWeatherInfo *weatherInfo;

@end

@implementation XXBWeatherTabController

- (id) init
{
    self = [super init];
    if(self)
    {
        //设置tabbarItem最好放在init里面
        [self initTabbarItemWithTitle:@"天气" imageNamed:@"tabbar_more" selectedImageNamed:@"tabbar_more_selected"];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(selectCity)];
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //增加手势
    UITapGestureRecognizer *recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:recognizer];
    
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
    [self loadWeatherData:city];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"Tap");
    XXBMainTabBarController *tabBarController = (XXBMainTabBarController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    [tabBarController goToIndex:2];
}

- (void) updateLocCity
{
    XXBCity *city = [XXBLocationTool sharedInstance].locationCity;
    if(city && city.city)
    {
        DDLogDebug(@"定位到城市：%@",city.city);
        [self loadWeatherData:city.city];
    }
}

- (void) loadWeatherData:(NSString *)city
{
    [XXBWeatherManager getWeatherDataWithCity:city
          success:^(id json)
         {
             DDLogDebug(@"get the weather successfully");
             //MJExtention扩展可以将json数据变成model
             //model的属性要和json的关键字对应上，否则会被置为nil
             NSArray *weatherInfos = [XXBWeatherInfo objectArrayWithKeyValuesArray:json[@"results"]];
             self.weatherInfo = weatherInfos[0];
             self.weatherInfo.date = json[@"date"];
             
             //TODO：获取数据成功了，接下来就要将数据显示在界面上
         }
          failure:^(NSError *error)
         {
             DDLogDebug(@"get weather info error");
         }
     ];
    
    //最简单的数据持久化
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:city forKey:@"currentCity"];
}

- (void) selectCity
{
    XXBSelectCityViewController *selectController = [[XXBSelectCityViewController alloc] init];
    selectController.citySelDelegate = self;
    //隐藏tabbar,pop的时候tabbar会重新显示
    selectController.hidesBottomBarWhenPushed = YES;
    
    XXBManageCityController *mgr = [[XXBManageCityController alloc] init];
    [self.navigationController pushViewController:mgr animated:YES];

//    [self.navigationController pushViewController:selectController animated:YES];
}

#pragma citySelectDelegate
- (void) selectCityViewDidSelectCity:(NSString *)city
{
    self.title = city;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
