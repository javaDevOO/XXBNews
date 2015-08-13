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
    UIView *deleteView;
}

//自定义cell的时候一定要重写这个方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.label = [[UILabel alloc] init];
        self.label.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        
        //设置两个backgroundview，一个是正常情况下显示，一个是被select时显示
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor redColor];
        self.backgroundView = backgroundView;
//        UIView* selectedBGView = [[UIView alloc] initWithFrame:self.bounds];
//        selectedBGView.backgroundColor = [UIColor greenColor];
//        self.selectedBackgroundView = selectedBGView;
        // TODO: 找一张删除的图片换上
        deleteView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width*7/8, 0, self.bounds.size.width/8, self.bounds.size.width/8)];
        deleteView.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:deleteView];
        [self hideDelBtn];
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
