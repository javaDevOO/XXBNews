//
//  XXBManageCityController.h
//  XXBNews
//
//  Created by xuxubin on 15/8/12.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CitySelectDelegate.h"
#import "CityCellSelectDelegate.h"

/**
 *  管理城市页面，利用FlowLayout布局可以实现最简单的gridview视图
 */
@interface XXBManageCityController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, CitySelectDelegate>

@property (nonatomic, strong) NSMutableArray *weatherInfos;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, weak) id<CityCellSelectDelegate> cityCellSelDelegate;

- (id) initWithCityArray:(NSMutableArray *)cityArray;

@end
