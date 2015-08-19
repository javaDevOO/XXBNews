//
//  XXBWeatherInfo.m
//  XXBNews
//
//  Created by xuxubin on 15/8/8.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBWeatherInfo.h"

#import "MJExtension.h"

@implementation XXBWeatherInfo

+ (NSDictionary *)objectClassInArray
{
    return @{@"index": [XXBIndexDetail class], @"weather_data": [XXBWeatherDetail class]};
}


@end


@implementation XXBIndexDetail
@end



@implementation XXBWeatherDetail
@end
