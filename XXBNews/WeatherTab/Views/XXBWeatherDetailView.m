//
//  XXBWeatherDetailView.m
//  XXBNews
//
//  Created by xuxubin on 15/8/24.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBWeatherDetailView.h"
#import "XXBWeatherDetailCell.h"
#import "UIDevice+Resolutions.h"
#import "UIImageView+WebCache.h"

@implementation XXBWeatherDetailView

- (id) initWithFrame:(CGRect)frame withWeatherInfo:(XXBWeatherInfo *)info
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _weatherInfo = info;
        _cellArray = [[NSMutableArray alloc] init];
        
        [self setupWeatherDetail];
        
        [self.weatherInfo addObserver:self forKeyPath:@"weather_data" options:0 context:nil];
    }
    return self;
}

- (void) setupWeatherDetail
{
    CGFloat cellWidth = self.bounds.size.width/[self.weatherInfo.weather_data count];
    for(int i=0; i<[self.weatherInfo.weather_data count]; i++)
    {
        XXBWeatherDetail *weatherData= [self.weatherInfo.weather_data objectAtIndex:i];
        XXBWeatherDetailCell *detailCell = [[XXBWeatherDetailCell alloc] initWithFrame:CGRectMake(cellWidth*i, 0, cellWidth, self.bounds.size.height)];
        detailCell.dateLabel.text = weatherData.date;
        if(i == 0)
            detailCell.dateLabel.text = @"今天";
        detailCell.weatherLabel.text = weatherData.weather;
        [detailCell.weatherImageView sd_setImageWithURL:[NSURL URLWithString:weatherData.dayPictureUrl] placeholderImage:[UIImage imageNamed:@"tabbar_home_selected"]];
        
        [self addSubview:detailCell];
        [self.cellArray addObject:detailCell];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"weather_data"])
    {
        for(XXBWeatherDetailCell *cell in self.cellArray)
        {
            [cell removeFromSuperview];
        }
        [self setupWeatherDetail];
    }
}

- (void) dealloc
{
    [self.weatherInfo removeObserver:self forKeyPath:@"weather_data"];
}

@end
