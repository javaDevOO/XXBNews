//
//  WeatherInfoViewController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/15.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBWeatherInfoViewController.h"

#import "PNChart.h"

#import "UIDevice+Resolutions.h"

@implementation XXBWeatherInfoViewController

- (id) initWithWeatherInfo:(XXBWeatherInfo *)info
{
    self = [super init];
    if(self)
    {
        self.weatherInfo = info;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, [UIDevice currentWidth]/2, 30)];
        [self.view addSubview:self.label];
        self.label.text = self.weatherInfo.currentCity;
        self.label.textAlignment = NSTextAlignmentCenter;
        
        //注册KVC
//        [self.weatherInfo addObserver:self forKeyPath:@"currentCity" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"weatherInfo" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self setupChart];
    DDLogDebug(@"%f",self.view.bounds.size.width);
    
}

- (void) refresh
{
    self.label.text = self.weatherInfo.currentCity;
}

// 设置曲线图
- (void) setupChart
{
    PNLineChart *lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135, [UIDevice currentWidth]/2, 200)];
    //两条数据曲线的数据
    DDLogDebug(@"the width of the device is%lu",(unsigned long)[UIDevice currentWidth]);
    NSMutableArray *highTempData = [NSMutableArray array];
    NSMutableArray *lowTempData = [NSMutableArray array];
    //x轴label
    NSMutableArray *xLabelArray = [NSMutableArray array];
    for(int i=0; i<[self.weatherInfo.weather_data count]; i++)
    {
        XXBWeatherDetail *weatherData= [self.weatherInfo.weather_data objectAtIndex:i];
        [highTempData addObject:[weatherData getHighTemperature]];
        [lowTempData addObject:[weatherData getLowTemperature]];
        [xLabelArray addObject:weatherData.date];
    }
    xLabelArray[0] = @"今天";
    [lineChart setXLabels:xLabelArray];
    
    //设置两条曲线的样式和数据源
    PNLineChartData *highData = [PNLineChartData new];
    highData.color = PNRed;
    highData.itemCount = lineChart.xLabels.count;
    highData.getData = ^(NSUInteger index) {
        CGFloat yValue = [highTempData[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    highData.inflexionPointStyle = PNLineChartPointStyleCircle;
    PNLineChartData *lowData = [PNLineChartData new];
    lowData.color = PNFreshGreen;
    lowData.itemCount = lowTempData.count;
    lowData.getData = ^(NSUInteger index) {
        CGFloat yValue = [lowTempData[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    lowData.inflexionPointStyle = PNLineChartPointStyleCircle;
    
    lineChart.chartData = @[highData, lowData];
    lineChart.showCoordinateAxis = YES;
    lineChart.axisColor = [UIColor blackColor];
    [lineChart strokeChart];
    [self.view addSubview:lineChart];
}

//一旦weatherinfo属性的值发生改变，就会调用这个方法
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"weatherInfo"] && object==self)
    {
        DDLogDebug(@"%@",@"the value of weather info has changed");
        self.label.text = self.weatherInfo.currentCity;
    }
}

@end
