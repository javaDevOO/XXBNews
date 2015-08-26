//
//  XXBCityCell.m
//  XXBNews
//
//  Created by xuxubin on 15/8/12.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBCityCell.h"
#import "UIImageView+WebCache.h"

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
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width*7/8, 0, self.bounds.size.width/6, self.bounds.size.width/6)];
        deleteView.center = CGPointMake(self.bounds.size.width-5, 5);
        deleteView.image = [UIImage imageNamed:@"delete_city_btn"];
        [self.contentView addSubview:deleteView];
        [self hideDelBtn];
        
        self.shouldShowDel = NO;
        
        [self setupContentView];
        
        self.weatherDetail = [[XXBWeatherDetail alloc] init];
        [self.weatherDetail addObserver:self forKeyPath:@"weather" options:NSKeyValueObservingOptionNew context:nil];
        [self.weatherDetail addObserver:self forKeyPath:@"temperature" options:0 context:nil];
        [self.weatherDetail addObserver:self forKeyPath:@"cityName" options:0 context:nil];
        [self.weatherDetail addObserver:self forKeyPath:@"dayPictureUrl" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"shouldShowDel" options:0 context:nil];
    }
    return self;
}


- (void) setupContentView
{
    self.descriptionImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/4, self.bounds.size.width*2/3, self.bounds.size.height/2)];
    [self.contentView addSubview:self.descriptionImgView];
    self.descriptionImgView.image = [UIImage imageNamed:@"tabbar_home_selected"];
    
    
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height/4);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.frame = CGRectMake(0,self.bounds.size.height*3/4,self.frame.size.width, self.frame.size.height/4);
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    
    self.highTempLabel = [[UILabel alloc] init];
    self.highTempLabel.frame = CGRectMake(self.bounds.size.width*2/3,self.bounds.size.height/4,self.frame.size.width/3, self.frame.size.height/4);
    self.highTempLabel.textAlignment = NSTextAlignmentCenter;
    
    self.lowTempLabel = [[UILabel alloc] init];
    self.lowTempLabel.frame = CGRectMake(self.bounds.size.width*2/3,self.bounds.size.height/2,self.frame.size.width/3, self.frame.size.height/4);
    self.lowTempLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.highTempLabel];
    [self.contentView addSubview:self.lowTempLabel];
}


- (void) hideDelBtn
{
    deleteView.hidden = YES;
}


- (void) showDelBtn
{
    deleteView.hidden = NO;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DDLogDebug(@"%@",@"the property of cell is changed");
    
    if(object == self)
    {
        if(self.shouldShowDel)
            [self showDelBtn];
        else
            [self hideDelBtn];
    }
    else{
        if([keyPath isEqualToString:@"cityName"])
        {
            self.nameLabel.text = self.weatherDetail.cityName;
        }
        else
        {
            self.descriptionLabel.text = self.weatherDetail.weather;
            
            NSNumber *high = [self.weatherDetail getHighTemperature];
            NSNumber *low = [self.weatherDetail getLowTemperature];
            NSString *highStr = [NSString stringWithFormat:@"%d°",[high intValue]];
            NSString *lowStr = [NSString stringWithFormat:@"%d°",[low intValue]];
            self.highTempLabel.text = highStr;
            self.lowTempLabel.text = lowStr;
            [self.descriptionImgView sd_setImageWithURL:[NSURL URLWithString:self.weatherDetail.dayPictureUrl] placeholderImage:[UIImage imageNamed:@"tabbar_home_selected"]];
            
        }
    }
}

- (void) dealloc
{
    [self.weatherDetail removeObserver:self forKeyPath:@"weather"];
    [self.weatherDetail removeObserver:self forKeyPath:@"temperature"];
    [self.weatherDetail removeObserver:self forKeyPath:@"cityName"];
    [self.weatherDetail removeObserver:self forKeyPath:@"dayPictureUrl"];
    [self removeObserver:self forKeyPath:@"shouldShowDel"];

}

@end
