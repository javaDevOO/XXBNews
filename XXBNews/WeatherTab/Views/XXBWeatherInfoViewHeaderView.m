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
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.height, self.bounds.size.height)];
        
        _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.height,0,self.bounds.size.height,self.bounds.size.height/2)];
        _temperatureLabel.font = [UIFont systemFontOfSize:35];
        
        _weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.height, self.bounds.size.height/2, self.bounds.size.height, self.bounds.size.height/2)];
        
        _wetLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width*2/3, 0, self.bounds.size.width/3, self.bounds.size.height/2)];
        _wetLabel.textAlignment = NSTextAlignmentRight;
        _wetLabel.text = @"湿度80%";
    
        _windLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width*2/3, self.bounds.size.height/2, self.bounds.size.width/3, self.bounds.size.height/2)];
        _windLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_imageView];
        [self addSubview:_temperatureLabel];
        [self addSubview:_weatherLabel];
        [self addSubview:_wetLabel];
        [self addSubview:_windLabel];
        
    }
    return self;
}

@end
