//
//  XXBMemoCell.m
//  XXBNews
//
//  Created by xuxubin on 15/8/16.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBMemoCell.h"
#import "CircularCollectionViewLayout.h"

@interface XXBMemoCell ()
@end

@implementation XXBMemoCell

//自定义cell的时候一定要重写这个方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //设置两个backgroundview，一个是正常情况下显示，一个是被select时显示
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView.image = [UIImage imageNamed:@"memo_cell_bg"];
        self.backgroundView = backgroundView;
        
//        UIView *selectedView = [[UIView alloc] initWithFrame:self.bounds];
//        selectedView.backgroundColor = [UIColor yellowColor];
//        self.selectedBackgroundView = selectedView;
        
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void) applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
}


- (BOOL) canBecomeFirstResponder
{
    return YES;
}

@end
