//
//  XXBWeatherInfoView.h
//  XXBNews
//
//  Created by xuxubin on 15/8/23.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"
#import "XXBWeatherInfo.h"
#import "XXBWeatherDetailView.h"

@interface XXBWeatherInfoView : UIScrollView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) PNLineChart *lineChart;
@property (nonatomic, strong) XXBWeatherInfo *weatherInfo;
@property (nonatomic, strong) UITableView *indexTableView;
@property (nonatomic, strong) XXBWeatherDetailView *detailView;

- (id) initWithWeatherInfo:(XXBWeatherInfo *)info;

@end
