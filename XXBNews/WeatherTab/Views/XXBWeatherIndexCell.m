//
//  XXBWeatherIndexCell.m
//  XXBNews
//
//  Created by xuxubin on 15/8/24.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBWeatherIndexCell.h"
#import "UIDevice+Resolutions.h"

@implementation XXBWeatherIndexCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupContentView];
    }
    return self;
}


// TODO：布局的参数还要修改，目前无法适配不同大小屏幕
- (void) setupContentView
{
    self.descriptionImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 50, 50)];
        self.descriptionImgView.image = [UIImage imageNamed:@"tabbar_home_selected"];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.frame = CGRectMake(55+5,0,100, 30);
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    self.zsLabel = [[UILabel alloc] init];
    self.zsLabel.frame = CGRectMake(200,0,[UIDevice currentWidth]-200-10, 30);
    self.zsLabel.textAlignment = NSTextAlignmentRight;

    self.desTextView = [[UITextView alloc] init];
    self.desTextView.scrollEnabled = NO;
    self.desTextView.frame = CGRectMake(55+5, 30,[UIDevice currentWidth]-60, 50);
    self.desTextView.editable = NO;
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.zsLabel];
    [self addSubview:self.desTextView];
    [self addSubview:self.descriptionImgView];

   
}
@end
