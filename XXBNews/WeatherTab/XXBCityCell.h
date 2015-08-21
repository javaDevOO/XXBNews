//
//  XXBCityCell.h
//  XXBNews
//
//  Created by xuxubin on 15/8/12.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBWeatherInfo.h"

/**
 *  管理城市页面中每个cell的布局,目前还比较简陋
 */
@interface XXBCityCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *highTempLabel;
@property (nonatomic, strong) UILabel *lowTempLabel;
@property (nonatomic, strong) UIImageView *descriptionImgView;

@property (nonatomic, strong) XXBWeatherDetail *weatherDetail;

@property (nonatomic, assign) BOOL shouldShowDel;

- (void) hideDelBtn;

- (void) showDelBtn;

@end
