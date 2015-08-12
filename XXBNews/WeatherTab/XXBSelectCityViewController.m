//
//  XXBSelectCityViewController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/10.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBSelectCityViewController.h"
#import "UIDevice+Resolutions.h"

#import "XXBFileUtilities.h"

@interface XXBSelectCityViewController ()

@property (nonatomic, strong) NSArray *provincesAndCities;
@property (nonatomic, strong) NSMutableArray *searchResultList;

@end

@implementation XXBSelectCityViewController

- (id) init
{
    self = [super init];
    if(self)
    {
        if(self.provincesAndCities == nil)
        {
            //加载plist文件中的城市列表
            self.provincesAndCities = [NSArray arrayWithContentsOfFile:[XXBFileUtilities getFilePathString:@"ProvincesAndCities.plist" ofType:nil]];
        }
        
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.searchController.searchResultsUpdater = self;
        self.searchController.dimsBackgroundDuringPresentation = NO;
        self.searchController.hidesNavigationBarDuringPresentation = NO;
        self.searchController.searchBar.frame = CGRectMake(0,0, self.searchController.searchBar.frame.size.width, 44.0);
        self.tableView.tableHeaderView = self.searchController.searchBar;
        
        self.tableView.frame = CGRectMake(0, 0, [UIDevice currentWidth],[UIDevice currentHeight]);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择城市";
}

# pragma tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.searchController.active)
        return self.searchResultList.count;
    else
        return self.provincesAndCities.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.searchController.active)
    {
        NSDictionary *provinces = self.searchResultList[section];
        NSArray *cities = provinces[@"Cities"];
        return cities.count;
    }
    else
    {
        NSDictionary *provinces = self.provincesAndCities[section];
        NSArray *cities = provinces[@"Cities"];
        return cities.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cityCellID = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellID];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cityCellID];
    }
    
    NSDictionary *provinces = self.provincesAndCities[indexPath.section];
    if(self.searchController.active)
        provinces = self.searchResultList[indexPath.section];
    NSArray *cities = provinces[@"Cities"];
    NSDictionary *cityInfoDic = cities[indexPath.row];
    cell.textLabel.text = cityInfoDic[@"city"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSDictionary *provinces = self.provincesAndCities[section];
    if(self.searchController.active)
    {
        provinces = self.searchResultList[section];
    }
    return provinces[@"State"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *provinces = self.provincesAndCities[indexPath.section];
    if(self.searchController.active)
    {
        provinces = self.searchResultList[indexPath.section];
    }
    NSArray *cities = provinces[@"Cities"];
    NSDictionary *cityInfoDic = cities[indexPath.row];
    NSString *city = cityInfoDic[@"city"];

    [self.citySelDelegate selectCityViewDidSelectCity:city];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void) updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchController.searchBar text];
    
    NSPredicate *provincePreicate = [NSPredicate predicateWithFormat:@"State CONTAINS[c] %@", searchString];
    
    NSPredicate *cityPredicate = [NSPredicate predicateWithFormat:@"city CONTAINS[c] %@",
                                  searchString];
    
    if (self.searchResultList!= nil) {
        [self.searchResultList removeAllObjects];
    }
    //过滤数据
    // TODO:目前只能按省搜索，暂时不知道怎么用谓词搜索到城市
//    self.searchResultList= [NSMutableArray arrayWithArray:[self.provincesAndCities filteredArrayUsingPredicate:provincePreicate]];
    self.searchResultList = [[NSMutableArray alloc] init];
    for(id pro in self.provincesAndCities)
    {
        NSArray *filterResult = [pro[@"Cities"] filteredArrayUsingPredicate:cityPredicate];
        //[NSMutableArray arrayWithArray:[pro[@"Cities"] filteredArrayUsingPredicate:cityPredicate]];
        if(filterResult.count!=0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:filterResult forKey:@"Cities"];
            [dict setObject:pro[@"State"] forKey:@"State"];
            [self.searchResultList addObject:dict];
        }
    }

    //刷新表格
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //TODO: 当前页面消失的时候searchbar依然存在，不会自动消失。
    self.searchController.searchBar.hidden = YES;
    self.searchController.active = NO;
}



@end
