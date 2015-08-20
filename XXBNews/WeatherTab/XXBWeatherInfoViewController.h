//
//  WeatherInfoViewController.h
//  XXBNews
//
//  Created by xuxubin on 15/8/15.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBWeatherInfo.h"

@interface XXBWeatherInfoViewController : UIViewController

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) XXBWeatherInfo *weatherInfo;

- (id) initWithWeatherInfo:(XXBWeatherInfo *)info;

@end
