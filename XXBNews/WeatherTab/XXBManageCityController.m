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
        self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // TODO: 获取已选择的城市
        self.cityArray = [NSMutableArray arrayWithObjects:@"深圳",@"珠海",@"汕头",@"厦门",nil];
        
        // 创建collection的时候要有layout属性
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        //要注册cell,如果用到了header和footer（supplementary views），也要进行注册
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

// 一个section
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    DDLogDebug(@"return the number of section");
    return 1;
}

// 一个section有多少个cell，flowlayout中有多少列由cell的大小来决定
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cityArray count]+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXBCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellIdentifier" forIndexPath:indexPath];
    // 注册过cell,不用再判断是否为nil，若为nil会自动创建
    if(indexPath.item < [self.cityArray count])
        cell.label.text = [self.cityArray objectAtIndex:indexPath.item];
    else
        cell.label.text = @"添加城市";
    cell.backgroundColor = [UIColor greenColor];
    
   return cell;
}

//设置每个cell的大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

// 设置每组cell的边距，实际上是每个section的边距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0);
}

// 设置最小列间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0;
}

//设置行与行之间的间距，由于只有一个section，section没有用到
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == [self.cityArray count])
        [self selectCity];
    else
        [self.navigationController popViewControllerAnimated:YES];
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
// 在collection中添加cell
- (void) selectCityViewDidSelectCity:(NSString *)city
{
    NSArray *newData = [[NSArray alloc] initWithObjects:city, nil];
    [self.collectionView performBatchUpdates:^{
        NSInteger resultsSize = [self.cityArray count]; //data is the previous array of data
        // 先更改数据源
        [self.cityArray addObjectsFromArray:newData];
        
        NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
        
        // 插入新cell的范围
        for (int i = resultsSize; i < resultsSize + newData.count; i++) {
            [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i
                                                              inSection:0]];
        }
        [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
    } completion:nil];
}


@end
