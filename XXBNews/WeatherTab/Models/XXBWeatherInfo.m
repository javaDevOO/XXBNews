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

- (int) getRealTimeTemp
{
    XXBWeatherDetail *todayDetail = [self.weather_data objectAtIndex:0];
    NSArray *stringList = [todayDetail.date componentsSeparatedByString:@"："];
    // 因天气API不一定返回实时气温，此处先用最高气温代替
    if([stringList count] == 1)
        return [[todayDetail getHighTemperature] intValue];
    NSNumber *realTemp = [NSNumber numberWithInt:[stringList[1] intValue]];
    DDLogDebug(@"the real time temperature is %d",[realTemp intValue]);
    return [realTemp intValue];
}

- (XXBWeatherDetail *)getTodayDetail
{
    return [self.weather_data objectAtIndex:0];
}

@end


@implementation XXBIndexDetail
@end


@implementation XXBWeatherDetail

- (NSNumber *) getHighTemperature
{
    NSArray *stringList = [self.temperature componentsSeparatedByString:@"~"];
    NSNumber *high = [NSNumber numberWithInt:[stringList[0] intValue]];
    return high;
}

- (NSNumber *) getLowTemperature
{
    NSArray *stringList = [self.temperature componentsSeparatedByString:@"~"];
    NSNumber *low = [NSNumber numberWithInt:[stringList[1] intValue]];
    return low;
}

@end
