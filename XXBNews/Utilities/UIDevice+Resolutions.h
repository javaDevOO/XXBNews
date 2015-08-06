//
//  UIDevice+Resolutions.h
//  QiXin
//
//  Created by zhengwei wu on 13-10-1.
//  Copyright (c) 2013年 zhengwei wu. All rights reserved.
//
//  This code from http://www.cnblogs.com/thefeelingofsimple/archive/2013/01/30/2883340.html
//  Thanks for wangzhipeng;

#import <UIKit/UIKit.h>

enum {
    // iPhone 1,3,3GS 标准分辨率(320x480px)
    UIDevice_iPhoneStandardRes      = 1,
    // iPhone 4,4S 高清分辨率(640x960px)
    UIDevice_iPhoneHiRes            = 2,
    // iPhone 5 高清分辨率(640x1136px)
    UIDevice_iPhoneTallerHiRes      = 3,
    // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPadStandardRes        = 4,
    // iPad 3 High Resolution(2048x1536px)
    UIDevice_iPadHiRes              = 5
};

typedef NSUInteger UIDeviceResolution;

@interface UIDevice (Resolutions)

/**
 *  get cureent screen height;
 @return     height
 */
+ (NSUInteger) currentHeight;

/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 获取当前分辨率
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (UIDeviceResolution) currentResolution;

/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 当前是否运行在iPhone5端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone5;

/******************************************************************************
 函数名称 : + (BOOL)isRunningOniPhone
 函数描述 : 当前是否运行在iPhone端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone;

/**
 *	get the frame that can be used
 *
 *	@return	CGRect
 */
+ (CGRect)getAppBounds;


/**
 *	Whether the current system to run the app?
 *
 *	@return	YES/NO
 */
+ (BOOL)isAbleRuniOS;


/**
 *
 *
 *	@return	YES/NO
 */
+ (BOOL)isiOS7;


@end
