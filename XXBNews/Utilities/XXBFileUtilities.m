//
//  XXBFileUtilities.m
//  XXBNews
//
//  Created by xuxubin on 15/8/10.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBFileUtilities.h"

@implementation XXBFileUtilities

+ (NSString *)getFilePathString:(NSString *)filename ofType:(NSString *)extention
{
    return [[NSBundle mainBundle] pathForResource:filename ofType:extention];
}

@end
