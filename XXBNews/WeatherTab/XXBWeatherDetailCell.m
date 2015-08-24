//
//  XXBWeatherDetailCell.m
//  XXBNews
//
//  Created by xuxubin on 15/8/24.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBWeatherDetailCell.h"

@implementation XXBWeatherDetailCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/5)];
        self.dateLabel.font = [UIFont systemFontOfSize:14.0];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/5, self.bounds.size.width, self.bounds.size.height*3/5)];
        self.weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.bounds.size.height*4/5,self.bounds.size.width,self.bounds.size.height/5)];
        self.weatherLabel.font = [UIFont systemFontOfSize:12.0];
        self.weatherLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.dateLabel];
        [self addSubview:self.weatherLabel];
        [self addSubview:self.weatherImageView];
        
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 5.0;
    }
    return self;
}

@end
