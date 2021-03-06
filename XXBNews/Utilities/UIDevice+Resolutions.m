//
//  UIDevice+Resolutions.m
//  QiXin
//
//  Created by zhengwei wu on 13-10-1.
//  Copyright (c) 2013年 zhengwei wu. All rights reserved.
//

#import "UIDevice+Resolutions.h"

@implementation UIDevice (Resolutions)

/**
 *  get cureent screen height;
    @return     height
 */
+ (NSUInteger) currentHeight
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
//    result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
    return result.height;
}

+ (NSUInteger) currentWidth
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
//    result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
    return result.width;
}

/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 获取当前分辨率
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (UIDeviceResolution) currentResolution {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
            if (result.height <= 480.0f)
                return UIDevice_iPhoneStandardRes;
            return (result.height > 960 ? UIDevice_iPhoneTallerHiRes : UIDevice_iPhoneHiRes);
        } else
            return UIDevice_iPhoneStandardRes;
    } else
        return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) ? UIDevice_iPadHiRes : UIDevice_iPadStandardRes);
}

/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 当前是否运行在iPhone5端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone5{
    if ([self currentResolution] == UIDevice_iPhoneTallerHiRes) {
        return YES;
    }
    return NO;
}

/******************************************************************************
 函数名称 : + (BOOL)isRunningOniPhone
 函数描述 : 当前是否运行在iPhone端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

/**
 *	get the frame that can be used
 *
 *	@return	CGRect
 */
+ (CGRect) getAppBounds
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;    // Size of whole screen
    // Substract the height of status bar
    screenBounds.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height;
    return screenBounds;
}

+ (BOOL)isAbleRuniOS
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version >= 5.0f)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isiOS7
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version >= 7.0f)
    {
        return YES;
    }
    return NO;
}

@end
