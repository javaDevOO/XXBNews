//
//  XXBCityCell.h
//  XXBNews
//
//  Created by xuxubin on 15/8/12.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  管理城市页面中每个cell的布局,目前还比较简陋
 */
@interface XXBCityCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;

- (void) hideDelBtn;

- (void) showDelBtn;

@end
