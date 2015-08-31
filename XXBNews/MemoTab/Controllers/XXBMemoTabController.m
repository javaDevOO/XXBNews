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
#import "XXBMemoEditController.h"
#import "Memo.h"
#import "AppDelegate.h"
#import "XXBTimeTool.h"

@interface XXBMemoTabController ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation XXBMemoTabController
{
    NSIndexPath *longPressedIndex;
}

- (id) init
{
    self = [super init];
    if(self)
    {
        [self initTabbarItemWithTitle:NSLocalizedString(@"memoTabTitle", @"") imageNamed:@"tabbar_more" selectedImageNamed:@"tabbar_more_selected"];
        
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMemo)];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
        
        [self setupFetchResultsController];
        
        DDLogDebug(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);
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
    
    // 要注册cell,如果用到了header和footer（supplementary views），也要进行注册
    [self.collectionView registerClass:[XXBMemoCell class] forCellWithReuseIdentifier:@"MemoTabCollectionCellIdentifier"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
}


// 重写get方法,要注意，如果使用self.实际上是调用getter方法，会陷入循环
- (NSFetchedResultsController *)fetchedResultsController
{
    if(_fetchedResultsController == nil)
    {
        [self setupFetchResultsController];
    }
    
    return _fetchedResultsController;
}


- (void) setupFetchResultsController
{
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *sectionSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"isFinished" ascending:NO];
    NSSortDescriptor *contentSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO];
    [fetchRequest setSortDescriptors:@[sectionSortDescriptor, contentSortDescriptor]];
    
    NSFetchedResultsController *fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    fetchResultController.delegate  = self;
    _fetchedResultsController = fetchResultController;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error])
    {
        /*
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


#pragma mark - collectionview data source and delegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    DDLogDebug(@"return the number of section");
    return [[self.fetchedResultsController sections] count];
}


// 一个section有多少个cell，flowlayout中有多少列由cell的大小来决定
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXBMemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemoTabCollectionCellIdentifier" forIndexPath:indexPath];
    // 注册过cell,不用再判断是否为nil，若为nil会自动创建
    
    Memo *memo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.label.text = memo.content;
    
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    [cell addGestureRecognizer:longPressGesture];
    
    return cell;
}


// 设置每个cell的大小
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


// 设置行与行之间的间距，由于只有一个section，section参数没有用到
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0;
}

// 选择了某个cell
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Memo *memo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    XXBMemoEditController *editController = [[XXBMemoEditController alloc] initWithMode:MemoEditModeUpdate withMemo:memo];
    editController.delegate = self;
    editController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editController animated:YES];
}


// flowlayout专门管理布局，比如设置header的大小
- (UICollectionViewFlowLayout *) setupFlowLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置其它各种属性
    return flowLayout;
}


#pragma mark - EditMemo finish delegate
- (void)memoEditController:(XXBMemoEditController *)memoEditController addMemoWithContent:(NSString *)content
{
    DDLogDebug(@"%@",@"should add a new record");
    Memo *newMemo = [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:self.managedObjectContext];
    newMemo.content = content;
    newMemo.isFinished = [NSNumber numberWithBool:NO];
    newMemo.createDate = [XXBTimeTool localeDate];
    
    NSError *error;
    if(![self.managedObjectContext save:&error])
    {
        DDLogDebug(@"%@",@"添加失败");
    }
    DDLogDebug(@"%@",@"添加成功");
}


#pragma mark - Fetched results controller delegate
// insert或者delete时，当调用context的save方法的时候就会执行代理方法
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    DDLogDebug(@"%@",@"fetch result will change content");
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
        {
            DDLogDebug(@"%@",@"a new section insert");
            break;
        }
        case NSFetchedResultsChangeDelete:
            break;
        default:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
        {
            DDLogDebug(@"%@",@"insert new record");
            // 更新视图
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
            }
                completion:nil];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            DDLogDebug(@"%@",@"update the record");
            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
            // fetchResult里面的数据被改变了，但是数据库里面的没有改变，要调用context的save方法
            NSError *error;
            if(![self.managedObjectContext save:&error])
            {
                DDLogDebug(@"%@",@"更新失败");
            }
            DDLogDebug(@"%@",@"更新数据成功");
            break;
        }
        case NSFetchedResultsChangeMove:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    DDLogDebug(@"%@",@"fetch result did change content");
}


- (void) addMemo
{
    XXBMemoEditController *editController = [[XXBMemoEditController alloc] initWithMode:MemoEditModeAdd withMemo:nil];
    editController.delegate = self;
    editController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editController animated:YES];
}


- (void) deleteMemo:(id)sender
{
    DDLogDebug(@"%@",@"should delete the memo");
    [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:longPressedIndex]];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void) cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        // 获取被长按的cell的indexpath
        CGPoint location = [recognizer locationInView:self.collectionView];
        NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:location];
        XXBMemoCell *cell = (XXBMemoCell *)recognizer.view;
        // 这里把cell做为第一响应(cell默认是无法成为responder,需要重写canBecomeFirstResponder方法)
        [cell becomeFirstResponder];
        
        UIMenuItem *itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMemo:)];
        // 暂时找不到见indexPath传给action的方法，先用实例变量存起来
        longPressedIndex = indexPath;
        DDLogDebug(@"%d,%d",indexPath.section,indexPath.item);
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:itDelete, nil]];
        [menu setTargetRect:cell.frame inView:self.collectionView];
        [menu setMenuVisible:YES animated:YES];
    }
}


- (BOOL) collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXBMemoCell* cell = (XXBMemoCell*)[collectionView cellForItemAtIndexPath:indexPath];
    //设置(Highlight)高亮下的颜色
    UIImageView *bgImg = (UIImageView *)cell.backgroundView;
    bgImg.image = [UIImage imageNamed:@"tabbar_more_selected"];
    DDLogDebug(@"%@",@"change the background of the cell");
}


- (void) collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    //设置(Nomal)正常状态下的颜色
    UIImageView *bgImg = (UIImageView *)cell.backgroundView;
    bgImg.image = [UIImage imageNamed:@"memo_cell_bg"];
}

@end
