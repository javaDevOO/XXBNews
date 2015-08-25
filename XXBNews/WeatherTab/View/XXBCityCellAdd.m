//
//  XXBAddCityCell.m
//  XXBNews
//
//  Created by xuxubin on 15/8/25.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBCityCellAdd.h"

@implementation XXBCityCellAdd

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height/4);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = @"添加城市";
        [self.contentView addSubview:nameLabel];
        
        UIImageView *descriptionImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/4, self.bounds.size.width, self.bounds.size.height*3/4)];
        descriptionImgView.image = [UIImage imageNamed:@"add_city_bg"];
        [self.contentView addSubview:descriptionImgView];
    }
    return self;
}

@end
