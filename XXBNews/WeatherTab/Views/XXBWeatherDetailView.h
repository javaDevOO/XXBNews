//
//  XXBWeatherDetailView.h
//  XXBNews
//
//  Created by xuxubin on 15/8/24.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBWeatherInfo.h"

/**
 *  天气预报
 */
@interface XXBWeatherDetailView : UIView

@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) XXBWeatherInfo *weatherInfo;

- (id) initWithFrame:(CGRect)frame withWeatherInfo:(XXBWeatherInfo *)info;

@end
