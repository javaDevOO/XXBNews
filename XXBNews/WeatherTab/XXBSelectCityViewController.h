//
//  XXBSelectCityViewController.h
//  XXBNews
//
//  Created by xuxubin on 15/8/10.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitySelectDelegate.h"

@interface XXBSelectCityViewController : UISearchController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, weak) id<CitySelectDelegate> citySelDelegate;

@end
