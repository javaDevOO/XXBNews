//
//  XXBWeatherInfoView.m
//  XXBNews
//
//  Created by xuxubin on 15/8/23.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBWeatherInfoView.h"
#import "UIDevice+Resolutions.h"
#import "XXBWeatherIndexCell.h"
#import "XXBWeatherDetailCell.h"

@implementation XXBWeatherInfoView
{
    PNLineChartData *highData;
    PNLineChartData *lowData;
}

- (id) initWithWeatherInfo:(XXBWeatherInfo *)info
{
    self = [super init];
    if(self)
    {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, [UIDevice currentWidth], 30)];
        [self addSubview:self.nameLabel];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.weatherInfo = info;
        [self addObserver:self forKeyPath:@"weatherInfo" options:0 context:nil];
        
        [self setupChart];
        
        self.indexTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,500,[UIDevice currentHeight], 440)];
        self.indexTableView.dataSource = self;
        self.indexTableView.delegate = self;
        self.indexTableView.scrollEnabled = NO;
        self.indexTableView.rowHeight = 88.0;
        [self addSubview:self.indexTableView];
        
        self.detailView = [[XXBWeatherDetailView alloc] initWithFrame:CGRectMake(10, 350, [UIDevice currentWidth]-20, 100) withWeatherInfo:self.weatherInfo];
        [self addSubview:self.detailView];
    }
    return self;
}

- (void) setupChart
{
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135, [UIDevice currentWidth], 200)];
    // 两条数据曲线的数据
    NSMutableArray *highTempData = [NSMutableArray array];
    NSMutableArray *lowTempData = [NSMutableArray array];
    // x轴label
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
    
    //设置两条曲线的样式和数据源
    highData = [PNLineChartData new];
    highData.color = PNRed;
    highData.itemCount = self.lineChart.xLabels.count;
    highData.pointLablePos = PNPointLabelPosAbove;
    highData.getData = ^(NSUInteger index) {
        CGFloat yValue = [highTempData[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    highData.inflexionPointStyle = PNLineChartPointStyleCircle;
    
    lowData = [PNLineChartData new];
    lowData.color = PNFreshGreen;
    lowData.itemCount = lowTempData.count;
    lowData.getData = ^(NSUInteger index) {
        CGFloat yValue = [lowTempData[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
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
        
        for(int i=0; i<[self.weatherInfo.weather_data count]; i++)
        {
            XXBWeatherDetail *weatherData= [self.weatherInfo.weather_data objectAtIndex:i];
            [highTempData addObject:[weatherData getHighTemperature]];
            [lowTempData addObject:[weatherData getLowTemperature]];
        }
        
        highData.getData = ^(NSUInteger index) {
            CGFloat yValue = [highTempData[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        lowData.getData = ^(NSUInteger index) {
            CGFloat yValue = [lowTempData[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        [self.lineChart updateChartData:@[highData, lowData]];
        DDLogDebug(@"%@",@"the data in the chart is updated");
        
        [self.indexTableView reloadData];
        
        self.detailView.weatherInfo.weather_data = self.weatherInfo.weather_data;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.weatherInfo.index count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXBIndexDetail *indexDetail = [self.weatherInfo.index objectAtIndex:indexPath.row];
    static NSString* indexCellID = @"IndexCell";
    XXBWeatherIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:indexCellID];
    
    if(cell == nil)
    {
        cell = [[XXBWeatherIndexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indexCellID];
    }
    
    cell.nameLabel.text = indexDetail.tipt;
    cell.zsLabel.text = indexDetail.zs;
    cell.desTextView.text = indexDetail.des;
    
    return cell;
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"weatherInfo"];
}


@end
