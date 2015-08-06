//
//  XXBMainTabBarController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/5.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBMainTabBarController.h"
#import "NavigationViewController.h"
#import "NewsPageViewController.h"
#import "XXBMainTabBarController.h"
#import "FirstPageViewController.h"
#import "MoreInfoViewController.h"

@interface XXBMainTabBarController ()

@property (nonatomic, weak) MoreInfoViewController *more;
@property (nonatomic) NSInteger lastIndex;

@end

@implementation XXBMainTabBarController
{
    UIView *tabButtonsContainerView;
    UIView *contentContainerView;
    
    CGSize mainSize;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        mainSize = [[UIScreen mainScreen] bounds].size;
    }
    self.lastIndex = 0;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化TabBar
    [self initTabBar];
    
    // 设置每个tab对应的view
    [self initChildViewContent];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabBar
{
    //self.tabBar.backgroundImage = [UIImage imageNamed:@"TabBar_bg"];
    //self.tabBar.delegate = self;
    
}

- (void)initChildViewContent
{
    //创建和添加子控制器
    FirstPageViewController *firstPage = [[FirstPageViewController alloc] init];
    
    NewsPageViewController  *newsPage = [[NewsPageViewController alloc] init];
    
    MoreInfoViewController *morePage = [[MoreInfoViewController alloc] init];
    self.more = morePage;
    
    NSArray *viewControllerAry = @[firstPage,newsPage,morePage];
    NSArray *titleAry = @[@"首页",@"新闻",@"更多"];
    NSArray *normalImgAry = @[@"tabbar_home_normal",@"tabbar_home_normal",@"tabbar_more"];
    NSArray *selectedImgAry = @[@"tabbar_home_selected",@"tabbar_home_selected",@"tabbar_more_selected"];
    
    //TODO: 增加图片资源
    for (int i=0; i< viewControllerAry.count; i++) {
        [self addChildViewController:viewControllerAry[i] title:titleAry[i] normalImgName:normalImgAry[i]
                     selectedImgName:selectedImgAry[i]];
    }
}

- (void)addChildViewController:(UIViewController *)childVc title:(NSString *)title normalImgName:(NSString *)normalImgName selectedImgName:(NSString *)selectedImgName
{
    childVc.title = title;
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:normalImgName];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImgName];
    
    // 添加到导航控制器
    NavigationViewController *childVcNav = [[NavigationViewController alloc]initWithRootViewController:childVc];
    [self addChildViewController:childVcNav];
}

- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger selectedIndex = [tabBar.items indexOfObject:item];
    NSLog([NSString stringWithFormat:@"select %d",selectedIndex]);
    if(self.lastIndex != selectedIndex)
    {
        NSLog(@"different index is select");
        self.lastIndex = selectedIndex;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
