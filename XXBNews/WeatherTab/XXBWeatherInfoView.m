//
//  XXBWeatherInfoView.m
//  XXBNews
//
//  Created by xuxubin on 15/8/23.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBWeatherInfoView.h"
#import "UIDevice+Resolutions.h"

@implementation XXBWeatherInfoView
{
    PNLineChartData *highData;
    PNLineChartData *lowData;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, [UIDevice currentWidth], 30)];
        [self addSubview:self.nameLabel];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addObserver:self forKeyPath:@"weatherInfo" options:0 context:nil];
        
        [self setupChart];
    }
    return self;
}

- (void) setupChart
{
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135, [UIDevice currentWidth], 200)];
    //两条数据曲线的数据
//    NSMutableArray *highTempData = [NSMutableArray array];
//    NSMutableArray *lowTempData = [NSMutableArray array];
//    //x轴label
//    NSMutableArray *xLabelArray = [NSMutableArray array];
//    for(int i=0; i<[self.weatherInfo.weather_data count]; i++)
//    {
//        XXBWeatherDetail *weatherData= [self.weatherInfo.weather_data objectAtIndex:i];
//        [highTempData addObject:[weatherData getHighTemperature]];
//        [lowTempData addObject:[weatherData getLowTemperature]];
//        [xLabelArray addObject:weatherData.date];
//    }
//    xLabelArray[0] = @"今天";
//    [self.lineChart setXLabels:xLabelArray];
    
    //设置两条曲线的样式和数据源
    highData = [PNLineChartData new];
    highData.color = PNRed;
    //highData.itemCount = self.lineChart.xLabels.count;
    highData.pointLablePos = PNPointLabelPosAbove;
//    highData.getData = ^(NSUInteger index) {
//        CGFloat yValue = [highTempData[index] floatValue];
//        return [PNLineChartDataItem dataItemWithY:yValue];
//    };
    highData.inflexionPointStyle = PNLineChartPointStyleCircle;
    
    lowData = [PNLineChartData new];
    lowData.color = PNFreshGreen;
//    lowData.itemCount = lowTempData.count;
//    lowData.getData = ^(NSUInteger index) {
//        CGFloat yValue = [lowTempData[index] floatValue];
//        return [PNLineChartDataItem dataItemWithY:yValue];
//    };
    lowData.inflexionPointStyle = PNLineChartPointStyleCircle;
    
    self.lineChart.chartData = @[highData, lowData];
    self.lineChart.showCoordinateAxis = YES;
    self.lineChart.axisColor = [UIColor blackColor];
    [self.lineChart strokeChart];
    [self addSubview:self.lineChart];
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DDLogDebug(@"%@",@"the weatherinfo of the weatherinfoview is changed");
    if([keyPath isEqualToString:@"weatherInfo"])
    {
        self.nameLabel.text = self.weatherInfo.currentCity;
        
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
        [self.lineChart setXLabels:xLabelArray];
        highData.itemCount = self.lineChart.xLabels.count;
        highData.getData = ^(NSUInteger index) {
            CGFloat yValue = [highTempData[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        lowData.itemCount = lowTempData.count;
        lowData.getData = ^(NSUInteger index) {
            CGFloat yValue = [lowTempData[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        [self.lineChart updateChartData:@[highData, lowData]];
        DDLogDebug(@"%@",@"the data in the chart is updated");
    }
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"weatherInfo"];
}


@end
