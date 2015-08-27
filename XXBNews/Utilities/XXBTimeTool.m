//
//  XXBTimeTool.m
//  XXBNews
//
//  Created by xuxubin on 15/8/27.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBTimeTool.h"

@implementation XXBTimeTool

+ (NSDate *)localeDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

@end
