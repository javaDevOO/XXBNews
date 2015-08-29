//
//  XXBSelectCityViewController.h
//  XXBNews
//
//  Created by xuxubin on 15/8/10.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitySelectDelegate.h"

/**
 *  选择城市页面
 *  TODO:ios7中没有searchcontroller，所以显示不了搜索栏，还需要适配
 */
@interface XXBSelectCityViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UISearchResultsUpdating>

@property(nonatomic, weak) id<CitySelectDelegate> citySelDelegate;
@property(nonatomic, strong) UISearchController *searchController;

@end
