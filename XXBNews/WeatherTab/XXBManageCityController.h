//
//  XXBManageCityController.h
//  XXBNews
//
//  Created by xuxubin on 15/8/12.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CitySelectDelegate.h"

/**
 *  管理城市页面，利用FlowLayout布局可以实现最简单的gridview视图
 */
@interface XXBManageCityController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, CitySelectDelegate>

@property (nonatomic, strong) NSArray *weatherInfos;

@end
