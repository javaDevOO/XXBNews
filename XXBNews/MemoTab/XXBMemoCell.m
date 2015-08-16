//
//  XXBMemoCell.m
//  XXBNews
//
//  Created by xuxubin on 15/8/16.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBMemoCell.h"

@interface XXBMemoCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation XXBMemoCell

//自定义cell的时候一定要重写这个方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //设置两个backgroundview，一个是正常情况下显示，一个是被select时显示
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor redColor];
        self.backgroundView = backgroundView;
        //        UIView* selectedBGView = [[UIView alloc] initWithFrame:self.bounds];
        //        selectedBGView.backgroundColor = [UIColor greenColor];
        //        self.selectedBackgroundView = selectedBGView;
        // TODO: 找一张删除的图片换上
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.imageView];
        self.imageView.image = [UIImage imageNamed:@"tabbar_home_selected"];
        
        self.label = [[UILabel alloc] init];
        self.label.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
    }
    return self;
}


@end
