//
//  XXBCityCell.m
//  XXBNews
//
//  Created by xuxubin on 15/8/12.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBCityCell.h"

@implementation XXBCityCell

- (id)init
{
    self = [super init];
    if(self)
    {
        self.label = [[UILabel alloc] init];
        self.label.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
        [self addSubview:self.label];
    }
    return self;
}

@end
