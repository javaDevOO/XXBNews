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
#import "UIImageView+WebCache.h"


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
        self.weatherInfo = info;
        [self addObserver:self forKeyPath:@"weatherInfo" options:0 context:nil];
        
        self.contentSize = CGSizeMake([UIDevice currentWidth],1050);

        self.headerView = [[XXBWeatherInfoViewHeaderView alloc] initWithFrame:CGRectMake(10, 84, [UIDevice currentWidth]-20,100)];
        [self addSubview:self.headerView];
        [self updateHeaderView];
        
        [self setupChart];
        
        self.detailView = [[XXBWeatherDetailView alloc] initWithFrame:CGRectMake(10, 400, [UIDevice currentWidth]-20, 100) withWeatherInfo:self.weatherInfo];
        [self addSubview:self.detailView];
        
        self.indexTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,520,[UIDevice currentHeight], 440)];
        self.indexTableView.dataSource = self;
        self.indexTableView.delegate = self;
        self.indexTableView.scrollEnabled = NO;
        self.indexTableView.rowHeight = 88.0;
        [self addSubview:self.indexTableView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,970, [UIDevice currentWidth],30)];
        label.text = @"数据来源:百度天气";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
    }
    return self;
}


- (void) setupChart
{
    // TODO:去曲线图隐藏坐标轴的时候需要放大
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(-50, 200, [UIDevice currentWidth]+100, 200)];
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
    self.lineChart.showCoordinateAxis = NO;
    self.lineChart.yLabelFormat=@"";
    self.lineChart.axisColor = [UIColor blackColor];
    [self.lineChart strokeChart];
    [self addSubview:self.lineChart];
}


- (void) updateHeaderView
{
    XXBWeatherDetail *todayDetail = [self.weatherInfo getTodayDetail];
    [self.headerView.imageView sd_setImageWithURL:[NSURL URLWithString:todayDetail.dayPictureUrl]];
    self.headerView.temperatureLabel.text = [NSString stringWithFormat:@"%d°C",[self.weatherInfo getRealTimeTemp]];
    self.headerView.weatherLabel.text = todayDetail.weather;
    self.headerView.windLabel.text = todayDetail.wind;
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DDLogDebug(@"%@",@"the weatherinfo of the weatherinfoview is changed");
    if([keyPath isEqualToString:@"weatherInfo"])
    {
        NSMutableArray *highTempData = [NSMutableArray array];
        NSMutableArray *lowTempData = [NSMutableArray array];
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
        
        [self updateHeaderView];
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
    cell.userInteractionEnabled = NO;
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
