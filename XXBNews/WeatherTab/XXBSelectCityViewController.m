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
@property (nonatomic, strong) UITableView *tableView;

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
        
        self.tableView = [[UITableView alloc] init];
        //位置还需要调整一下
        self.tableView.frame = CGRectMake(0, 40, [UIDevice currentWidth],[UIDevice currentHeight]-40);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
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
    return self.provincesAndCities.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *provinces = self.provincesAndCities[section];
    NSArray *cities = provinces[@"Cities"];
    return cities.count;
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
    NSArray *cities = provinces[@"Cities"];
    NSDictionary *cityInfoDic = cities[indexPath.row];
    cell.textLabel.text = cityInfoDic[@"city"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *provinces = self.provincesAndCities[section];
    return provinces[@"State"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *provinces = self.provincesAndCities[indexPath.section];
    NSArray *cities = provinces[@"Cities"];
    NSDictionary *cityInfoDic = cities[indexPath.row];
    NSString *city = cityInfoDic[@"city"];

    [self.citySelDelegate selectCityViewDidSelectCity:city];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
