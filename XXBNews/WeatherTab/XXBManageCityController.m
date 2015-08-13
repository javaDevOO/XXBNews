//
//  XXBManageCityController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/12.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBManageCityController.h"
#import "XXBFileUtilities.h"

#import "XXBCityCell.h"

#import "XXBSelectCityViewController.h"

@interface XXBManageCityController()

@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation XXBManageCityController

- (id) init
{
    self = [super init];
    if(self)
    {
        self.title = @"管理城市";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(selectCity)];
        
        self.cityArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:[XXBFileUtilities getFilePathString:@"ProvincesAndCities.plist" ofType:nil]]];
        
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(100, 100);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        //要注册cell
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        [self.collectionView registerClass:[XXBCityCell class] forCellWithReuseIdentifier:@"CollectionCellIdentifier"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self.view addSubview:self.collectionView];

    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
}


//多少行
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    DDLogDebug(@"return the number of section");
    return 3;
}

//多少列
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXBCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellIdentifier" forIndexPath:indexPath];
    if(cell == nil)
    {
        
    }
    cell.label.text = @"深圳";
    
    return cell;
}

- (void) selectCity
{
    XXBSelectCityViewController *selectController = [[XXBSelectCityViewController alloc] init];
    selectController.citySelDelegate = self;
    //隐藏tabbar,pop的时候tabbar会重新显示
    selectController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:selectController animated:YES];
}

#pragma citySelectDelegate
- (void) selectCityViewDidSelectCity:(NSString *)city
{
    self.title = city;
}


@end
