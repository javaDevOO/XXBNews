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

@interface XXBWeatherTabController ()

@end

@implementation XXBWeatherTabController

- (id) init
{
    self = [super init];
    if(self)
    {
        //设置tabbarItem最好放在init里面
        [self initTabbarItemWithTitle:@"天气" imageNamed:@"tabbar_more" selectedImageNamed:@"tabbar_more_selected"];
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //增加手势
    UITapGestureRecognizer *recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:recognizer];
    
    [self loadWeatherData:@"深圳"];
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

- (void) loadWeatherData:(NSString *)city
{
    [XXBWeatherManager getWeatherDataWithCity:city
                                      success:^(id json)
                                     {
                                         DDLogDebug(@"get the weather successfully");
                                     }
                                      failure:^(NSError *error)
                                     {
                                         DDLogDebug(@"get weather info error");
                                     }
     ];
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
