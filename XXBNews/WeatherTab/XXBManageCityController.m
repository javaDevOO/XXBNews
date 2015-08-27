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
#import "XXBWeatherInfo.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "XXBWeatherManager.h"
#import "XXBCityCellAdd.h"

@interface XXBManageCityController()

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation XXBManageCityController
{
    BOOL isDeleteMode;  //是否处于删除模式下
    UIBarButtonItem *refreshBtn;
    UIBarButtonItem *editBtn;
    
    __block dispatch_semaphore_t getInfoFinishSemaphore;

}

- (id) initWithCityArray:(NSMutableArray *)cityArray
{
    self = [super init];
    if(self)
    {
        isDeleteMode = NO;
        self.title = @"管理城市";
        
        // TODO: 从属性列表中获取已选择的城市
        self.cityArray = cityArray;
        if(![[self.cityArray lastObject]  isEqualToString: @"+"])
            [self.cityArray addObject:@"+"];
        
        getInfoFinishSemaphore = dispatch_semaphore_create(1);
    }
    return self;
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    DDLogDebug(@"%@",@"manage city view did load");
    
    refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    editBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(toggleDeleteMode)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editBtn,refreshBtn, nil];
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupCollectionView];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DDLogDebug(@"%@",@"view did appear");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        //要等到返回天气数据时才往下执行
        dispatch_semaphore_wait(getInfoFinishSemaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refresh];
            dispatch_semaphore_signal(getInfoFinishSemaphore);
        });
    });
}


- (void) setupCollectionView
{
    // 创建collection的时候要有layout属性
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //要注册cell,如果用到了header和footer（supplementary views），也要进行注册
    [self.collectionView registerClass:[XXBCityCell class] forCellWithReuseIdentifier:@"CollectionCellIdentifier"];
    [self.collectionView registerClass:[XXBCityCellAdd class] forCellWithReuseIdentifier:@"CollectionCityCellAddIdentifier"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //允许多选
    //self.collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:self.collectionView];
}


#pragma datasource委托
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    DDLogDebug(@"return the number of section");
    return 1;
}


// 一个section有多少个cell，flowlayout中有多少列由cell的大小来决定
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cityArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 注册过cell,不用再判断是否为nil，若为nil会自动创建
    if(![[self.cityArray objectAtIndex:indexPath.item] isEqualToString:@"+"])
    {
        XXBCityCell *cell =
        
        [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellIdentifier" forIndexPath:indexPath];
        cell.weatherDetail.cityName = [self.cityArray objectAtIndex:indexPath.item];
        // 先把cell加上，当数据返回时再更新天气数据
        if(indexPath.item == self.weatherInfos.count)
            return cell;
        XXBWeatherInfo *weatherInfo = [self.weatherInfos objectAtIndex:indexPath.item];
        XXBWeatherDetail *detailToday = [weatherInfo.weather_data objectAtIndex:0];
        
        cell.weatherDetail.dayPictureUrl = detailToday.dayPictureUrl;
        cell.weatherDetail.weather = detailToday.weather;
        cell.weatherDetail.temperature = detailToday.temperature;

        return cell;
    }
    else
    {
        XXBCityCellAdd *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCityCellAddIdentifier" forIndexPath:indexPath];
        return cell;
    }
}


//设置每个cell的大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 120);
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


//设置行与行之间的间距，由于只有一个section，section参数没有用到
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0;
}


// 选择了某个cell
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 正常模式下跳回天气详情
    if(isDeleteMode == NO)
    {
        if(indexPath.item == [self.cityArray count]-1)
            [self selectCity];
        else
        {
            [self.cityCellSelDelegate manageCityViewDidSelectCityCell:[self.cityArray objectAtIndex:indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    // 否则直接删除
    else
    {
        [self deleteCityAtIndexPath:indexPath];
        //将选择的城市存到属性列表当中
    }
}


#pragma citySelectDelegate
// 在collection中添加cell
- (void) selectCityViewDidSelectCity:(NSString *)city
{
    [self.collectionView performBatchUpdates:^{
        // 先更改数据源
        NSInteger oldCount = [self.cityArray count];
        [self.cityArray insertObject:city atIndex:oldCount-1];
        
        NSArray *arrayWithIndexPaths = [NSArray arrayWithObjects:
                                        [NSIndexPath indexPathForRow:oldCount-1 inSection:0], nil];
        
        [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
    } completion:^(BOOL finished){
        if(finished)
            [self updateCellToMode:YES];
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        dispatch_semaphore_wait(getInfoFinishSemaphore, DISPATCH_TIME_FOREVER);
        [XXBWeatherManager getWeatherDataWithCity:[NSArray arrayWithObject:city]
                                          success:^(id json)
         {
             [XXBWeatherInfo setupObjectClassInArray:^NSDictionary *{
                 return [XXBWeatherInfo objectClassInArray];
             }];
             NSArray *weatherInfos = [XXBWeatherInfo objectArrayWithKeyValuesArray:json[@"results"]];
             XXBWeatherInfo *info = weatherInfos[0];
             info.date = json[@"date"];
             [self.weatherInfos addObject:weatherInfos[0]];
             
             NSInteger oldCount = [self.cityArray count];
             NSArray *arrayWithIndexPaths = [NSArray arrayWithObjects:
                                             [NSIndexPath indexPathForRow:oldCount-2 inSection:0], nil];
             [self.collectionView reloadItemsAtIndexPaths:arrayWithIndexPaths];
             dispatch_semaphore_signal(getInfoFinishSemaphore);
         }
                                          failure:^(NSError *error)
         {
             DDLogDebug(@"get weather info error");
             dispatch_semaphore_signal(getInfoFinishSemaphore);
         }];
    });

    //将选择的城市存到属性列表当中
    [self saveCityArrayToDefault];
}


// 删除path对应的cell
- (void) deleteCityAtIndexPath:(NSIndexPath *)path
{
    [self.collectionView performBatchUpdates:^{
        NSArray *itemPathsToDel = [NSArray arrayWithObjects:path, nil];
        
        for (NSIndexPath *path in itemPathsToDel) {
            [self.cityArray removeObjectAtIndex:path.item];
            [self.weatherInfos removeObjectAtIndex:path.item];
        }
        [self.collectionView deleteItemsAtIndexPaths:itemPathsToDel];
    } completion:nil];
}


#pragma select city delegate
- (void) selectCity
{
    XXBSelectCityViewController *selectController = [[XXBSelectCityViewController alloc] init];
    selectController.citySelDelegate = self;
    //隐藏tabbar,pop的时候tabbar会重新显示
    selectController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:selectController animated:YES];
}


- (void) toggleDeleteMode
{
    UIBarButtonItem *edit = self.navigationItem.rightBarButtonItems[0];
    if(isDeleteMode == NO)
    {
        isDeleteMode = YES;
        edit.title = @"返回";
        // 隐藏增加城市的cell
        [self.collectionView performBatchUpdates:^{
            NSArray *itemPathsToDel = [NSArray arrayWithObjects:
                                       [NSIndexPath indexPathForItem:[self.cityArray count]-1 inSection:0], nil];
            [self.cityArray removeLastObject];
            
            [self.collectionView deleteItemsAtIndexPaths:itemPathsToDel];
        } completion:^(BOOL finished){
            if(finished)
                [self updateCellToMode:NO];
        }];
    }else
    {
        isDeleteMode = NO;
        edit.title = @"编辑";
        // 恢复增加城市的cell
        [self.collectionView performBatchUpdates:^{
            NSArray *itemPathsToAdd = [NSArray arrayWithObjects:
                                       [NSIndexPath indexPathForItem:[self.cityArray count] inSection:0], nil];
            [self.cityArray addObject:@"+"];
            
            [self.collectionView insertItemsAtIndexPaths:itemPathsToAdd];
        } completion:^(BOOL finished){
            if(finished)
                [self updateCellToMode:YES];
        }];
    }
}


// TODO:重新获取天气信息，更新完数据源之后reloadData
- (void) refresh
{
    DDLogDebug(@"refresh the weather");
    //清除缓存
    [[SDImageCache sharedImageCache] cleanDisk];
    
    [self.collectionView reloadData];
}


// 将城市存到属性列表中
- (void) saveCityArrayToDefault
{
    [[NSUserDefaults standardUserDefaults] setObject:self.cityArray forKey:@"SelectedCities"];
}


// 更新cell的内容，或许有更好的遍历cell的方式
- (void) updateCellToMode:(BOOL)isNormal
{
    if(isNormal)
    {
        for(NSInteger i = 0; i < [self.cityArray count]-1 ;i++)
        {
            XXBCityCell *cell = (XXBCityCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            cell.shouldShowDel = NO;
        }
    }
    else
    {
        for(NSInteger i = 0; i < [self.cityArray count] ;i++)
        {
            XXBCityCell *cell = (XXBCityCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            cell.shouldShowDel = YES;
        }
    }
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // DDLogDebug(@"the manage controller will disappear");
    [self saveCityArrayToDefault];
}

@end
