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
#import "XXBMemoEditController.h"
#import "Memo.h"
#import "AppDelegate.h"
#import "XXBTimeTool.h"

@interface XXBMemoTabController ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation XXBMemoTabController

- (id) init
{
    self = [super init];
    if(self)
    {
        [self initTabbarItemWithTitle:NSLocalizedString(@"memoTabTitle", @"") imageNamed:@"tabbar_more" selectedImageNamed:@"tabbar_more_selected"];
        
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMemo)];
        [self initSections];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    DDLogDebug(@"%@",@"view did load");
    
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
    
    [self fetchData];
//    [self deleteData];
//    [self insertData:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) fetchData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:self.managedObjectContext];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc]
                                         initWithKey:@"createDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]
                                initWithObjects:sortDescriptor1, nil];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error;
    NSArray *fetchObjs = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    DDLogDebug(@"%d",[fetchObjs count]);
    for(Memo *memo in fetchObjs)
    {
        DDLogDebug(@"memo content:%@",memo.content);
        DDLogDebug(@"memo date:%@",memo.createDate);
        XXBMemoSection *section = [self.sections objectAtIndex:0];
        [section.memoArray addObject:memo];
    }
}


- (void) insertData:(Memo *)memo
{
    Memo *memo1 = [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:self.managedObjectContext];
    memo1.content = @"还书！！";
    memo1.isFinished = [NSNumber numberWithBool:YES];
    memo1.createDate = [XXBTimeTool localeDate];
    NSError *error;
    if(![self.managedObjectContext save:&error])
    {
        DDLogDebug(@"%@",@"保存失败");
    }
    DDLogDebug(@"%@",@"数据已保存");
}


- (void) deleteData
{
    // 1. 实例化查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Memo"];
    
    // 2. 设置谓词条件
    request.predicate = [NSPredicate predicateWithFormat:@"content CONTAINS '还书'"];
    
    // 3. 由上下文查询数据
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    // 4. 输出结果
    for (Memo *memo in result) {
        // 删除一条记录
        [self.managedObjectContext deleteObject:memo];
    }
    
    // 5. 通知_context保存数据
    if ([self.managedObjectContext save:nil]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

//更新
- (void)updateData:(NSString*)newsId  withContent:(NSString*)content
{
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"id like[cd] %@",newsId];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Memo" inManagedObjectContext:self.managedObjectContext]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    for (Memo *memo in result) {
         memo.content = content;
    }
    
    //保存
    if ([self.managedObjectContext save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
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
    return [sec.memoArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXBMemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemoTabCollectionCellIdentifier" forIndexPath:indexPath];
    // 注册过cell,不用再判断是否为nil，若为nil会自动创建
    XXBMemoSection *sec = [self.sections objectAtIndex:indexPath.section];
    Memo *memo = [sec.memoArray objectAtIndex:indexPath.item];
    cell.label.text = memo.content;
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
    XXBMemoSection *sec = [self.sections objectAtIndex:indexPath.section];
    Memo *memo = [sec.memoArray objectAtIndex:indexPath.item];
    XXBMemoEditController *editController = [[XXBMemoEditController alloc] initWithMode:MemoEditModeUpdate withMemo:memo];
    editController.delegate = self;
    [self.navigationController pushViewController:editController animated:YES];
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

- (void) addMemo
{
    XXBMemoEditController *editController = [[XXBMemoEditController alloc] initWithMode:MemoEditModeAdd withMemo:nil];
    editController.delegate = self;
    [self.navigationController pushViewController:editController animated:YES];
}

- (void)memoEditController:(XXBMemoEditController *)memoEditController addMemo:(Memo *)memo
{
    DDLogDebug(@"%@",@"should update the record");
}

- (void)memoEditController:(XXBMemoEditController *)memoEditController updateMemo:(Memo *)memo
{
    DDLogDebug(@"%@",@"should insert new record");
    DDLogDebug(@"%@",memo.content);
}

@end
