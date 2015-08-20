//
//  XXBCityCell.m
//  XXBNews
//
//  Created by xuxubin on 15/8/12.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBCityCell.h"

@implementation XXBCityCell
{
    UIImageView *deleteView;
}

//自定义cell的时候一定要重写这个方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //设置两个backgroundview，一个是正常情况下显示，一个是被select时显示
//        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
//        backgroundView.backgroundColor = [UIColor redColor];
//        self.backgroundView = backgroundView;
        
//        UIView* selectedBGView = [[UIView alloc] initWithFrame:self.bounds];
//        selectedBGView.backgroundColor = [UIColor greenColor];
//        self.selectedBackgroundView = selectedBGView;
        // TODO: 找一张删除的图片换上
//        self.layer.borderWidth = 1;
//        self.layer.cornerRadius = 5;
        deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width*7/8, 0, self.bounds.size.width/6, self.bounds.size.width/6)];
        deleteView.center = CGPointMake(self.bounds.size.width-5, 5);
        deleteView.image = [UIImage imageNamed:@"delete_city_btn"];
        deleteView.alpha = 1.0;
        
        self.bgImage = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.bgImage];
        self.bgImage.image = [UIImage imageNamed:@"tabbar_home_selected"];
        
        [self.contentView addSubview:deleteView];
        [self hideDelBtn];
        
        self.label = [[UILabel alloc] init];
        self.label.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
    }
    return self;
}


- (void) hideDelBtn
{
    deleteView.hidden = YES;
}


- (void) showDelBtn
{
    deleteView.hidden = NO;
}

@end
