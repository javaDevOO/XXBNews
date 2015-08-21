//
//  XXBMemoHeaderViewCell.m
//  XXBNews
//
//  Created by xuxubin on 15/8/16.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBMemoHeaderCell.h"

@implementation XXBMemoHeaderCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //设置两个backgroundview，一个是正常情况下显示，一个是被select时显示
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.backgroundView = backgroundView;
        //        UIView* selectedBGView = [[UIView alloc] initWithFrame:self.bounds];
        //        selectedBGView.backgroundColor = [UIColor greenColor];
        //        self.selectedBackgroundView = selectedBGView;
        // TODO: 找一张删除的图片换上
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

@end
