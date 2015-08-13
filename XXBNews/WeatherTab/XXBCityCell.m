//
//  XXBCityCell.m
//  XXBNews
//
//  Created by xuxubin on 15/8/12.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBCityCell.h"

@implementation XXBCityCell

//自定义cell的时候一定要重写这个方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.label = [[UILabel alloc] init];
        self.label.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
    }
    return self;
}

@end
