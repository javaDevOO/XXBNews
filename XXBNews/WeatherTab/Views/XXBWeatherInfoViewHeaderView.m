//
//  XXBWeatherInfoViewHeaderView.m
//  XXBNews
//
//  Created by xuxubin on 15/8/31.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBWeatherInfoViewHeaderView.h"

@implementation XXBWeatherInfoViewHeaderView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.height, self.bounds.size.height)];
        
        self.temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.height,0,self.bounds.size.height,self.bounds.size.height/2)];
        self.temperatureLabel.font = [UIFont systemFontOfSize:35];
        
        self.weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.height, self.bounds.size.height/2, self.bounds.size.height, self.bounds.size.height/2)];
        
        self.wetLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width*2/3, 0, self.bounds.size.width/3, self.bounds.size.height/2)];
        self.wetLabel.textAlignment = NSTextAlignmentRight;
        self.wetLabel.text = @"湿度80%";
    
        self.windLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width*2/3, self.bounds.size.height/2, self.bounds.size.width/3, self.bounds.size.height/2)];
        self.windLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:self.imageView];
        [self addSubview:self.temperatureLabel];
        [self addSubview:self.weatherLabel];
        [self addSubview:self.wetLabel];
        [self addSubview:self.windLabel];
        
    }
    return self;
}

@end
