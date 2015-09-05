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
    _descriptionImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 50, 50)];
    _descriptionImgView.image = [UIImage imageNamed:@"tabbar_home_selected"];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(55+5,0,100, 30);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
    _zsLabel = [[UILabel alloc] init];
    _zsLabel.frame = CGRectMake(200,0,[UIDevice currentWidth]-200-10, 30);
    _zsLabel.textAlignment = NSTextAlignmentRight;

    _desTextView = [[UITextView alloc] init];
    _desTextView.scrollEnabled = NO;
    _desTextView.frame = CGRectMake(55+5, 30,[UIDevice currentWidth]-60, 50);
    _desTextView.editable = NO;
    
    [self addSubview:_nameLabel];
    [self addSubview:_zsLabel];
    [self addSubview:_desTextView];
    [self addSubview:_descriptionImgView];

}
@end
