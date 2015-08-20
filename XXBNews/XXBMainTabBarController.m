//
//  XXBMainTabBarController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/5.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBMainTabBarController.h"
#import "XXBNavigationViewController.h"

#import "XXBWeatherTabController.h"
#import "XXBNewsTabController.h"
#import "XXBMemoTabController.h"
#import "XXBMoreInfoTabController.h"

@interface XXBMainTabBarController ()

@property (nonatomic, weak) XXBMoreInfoTabController *more;
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
    
    // 增加手势滑动
    [self initGesture];
    //self.selectedIndex = 1;
    
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
    XXBWeatherTabController *weatherTab = [[XXBWeatherTabController alloc] init];
    XXBNewsTabController *newsTab = [[XXBNewsTabController alloc] init];
    XXBMemoTabController *memoTab = [[XXBMemoTabController alloc] init];
    XXBMoreInfoTabController *moreInfoTab = [[XXBMoreInfoTabController alloc] init];
    self.more = moreInfoTab;
    
    
    //各个子ViewController的tabbarItem的title等参数在各自的类中定义，减少耦合
    NSArray *viewControllerAry = @[weatherTab, newsTab, memoTab, moreInfoTab];
    
    //TODO: 增加图片资源
    for (int i=0; i< viewControllerAry.count; i++) {
        [self addChildViewControllerWithNav:viewControllerAry[i]];
    }
}

- (void)addChildViewControllerWithNav:(UIViewController *)childVc{
    // 添加到导航控制器
    XXBNavigationViewController *childVcNav = [[XXBNavigationViewController alloc]initWithRootViewController:childVc];
    [self addChildViewController:childVcNav];
}

- (void)initGesture
{
    
}

// tarbar的代理
- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger selectedIndex = [tabBar.items indexOfObject:item];
    DDLogDebug(@"select %d",(int)selectedIndex);
    if(self.lastIndex != selectedIndex)
    {
        NSLog(@"different index is select");
        self.lastIndex = selectedIndex;
        if(selectedIndex == 3)
            self.more.tabBarItem.badgeValue = nil;
        else
            self.more.tabBarItem.badgeValue = @"5";
    }
}

@end
