//
//  WeatherInfoViewController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/15.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBWeatherInfoViewController.h"

@implementation XXBWeatherInfoViewController

- (id) init
{
    self = [super init];
    if(self)
    {
        self.label = [[UILabel alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.label];
        self.label.text = @"city";
        self.label.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void) refresh
{
    self.label.text = self.weatherInfo.currentCity;
}

//- (void) viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.label.text = self.weatherInfo.currentCity;
//}

@end
