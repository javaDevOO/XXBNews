//
//  XXBMemoTabViewController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/6.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBMemoTabController.h"
#import "XXBMemoCell.h"
#import "XXBMemoSection.h"
#import "XXBMemoHeaderCell.h"

@interface XXBMemoTabController ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *sections;
@end

@implementation XXBMemoTabController

- (id) init
{
    self = [super init];
    if(self)
    {
        [self initTabbarItemWithTitle:@"备忘" imageNamed:@"tabbar_more" selectedImageNamed:@"tabbar_more_selected"];
        
        [self initSections];
        
        // 创建collection的时候要有layout属性
        self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        UICollectionViewFlowLayout* flowLayout = [self setupFlowLayout];
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        //要注册cell,如果用到了header和footer（supplementary views），也要进行注册
        [self.collectionView registerClass:[XXBMemoCell class] forCellWithReuseIdentifier:@"MemoTabCollectionCellIdentifier"];
        [self.collectionView registerClass:[XXBMemoHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MemoTabHeaderIdentifier"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self.view addSubview:self.collectionView];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma datasource委托
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    DDLogDebug(@"return the number of section");
    return [self.sections count];
}


// 一个section有多少个cell，flowlayout中有多少列由cell的大小来决定
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    XXBMemoSection *sec = [self.sections objectAtIndex:section];
    return [sec.memoArray count]+4;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXBMemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemoTabCollectionCellIdentifier" forIndexPath:indexPath];
    // 注册过cell,不用再判断是否为nil，若为nil会自动创建
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        XXBMemoHeaderCell *cell = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MemoTabHeaderIdentifier" forIndexPath:indexPath];
        cell.titleLabel.text = [self.sections[indexPath.section] title];
        return cell;
    }
    return nil;
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
    
}


- (void) initSections
{
    self.sections = [NSMutableArray array];
    XXBMemoSection *undoSection = [[XXBMemoSection alloc] init];
    undoSection.title = @"未完成";
    XXBMemoSection *finishSection = [[XXBMemoSection alloc] init];
    finishSection.title = @"已完成";
    [self.sections addObject:undoSection];
    [self.sections addObject:finishSection];
}


// flowlayout专门管理布局，比如设置header的大小
- (UICollectionViewFlowLayout *) setupFlowLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(300.0f, 30.0f);  //设置head大小
    //设置其它各种属性
    return flowLayout;
}

@end
