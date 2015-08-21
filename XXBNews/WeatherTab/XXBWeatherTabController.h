//
//  FirstPageViewController.h
//  XXBNews
//
//  Created by xuxubin on 15/8/5.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBBaseTabViewController.h"
#import "CitySelectDelegate.h"

/**
 *  天气tab页，内嵌一个pageview
 */
@interface XXBWeatherTabController : XXBBaseTabViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *weatherInfos; // 天气信息的数组
@property (nonatomic, strong) NSMutableArray *cityArray;


@end
