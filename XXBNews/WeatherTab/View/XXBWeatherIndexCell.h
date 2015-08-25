//
//  XXBWeatherIndexCell.h
//  XXBNews
//
//  Created by xuxubin on 15/8/24.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  天气预报的cell
 */
@interface XXBWeatherIndexCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextView *desTextView;
@property (nonatomic, strong) UILabel *zsLabel;
@property (nonatomic, strong) UIImageView *descriptionImgView;

@end
