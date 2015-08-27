//
//  MoreInfoViewController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/5.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBMoreInfoTabController.h"

@interface XXBMoreInfoTabController ()

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation XXBMoreInfoTabController

- (id) init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self)
    {
        [self initTabbarItemWithTitle:NSLocalizedString(@"moreTabTitle", @"") imageNamed:@"tabbar_more" selectedImageNamed:@"tabbar_more_selected"];
    }
    return self;
}


- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DDLogDebug(@"%@",@"more tab view did load");
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 40;
    
    [self addShareSection];
    [self addSettingSection];
    [self addSuggestSection];
    [self addAboutSection];
}


- (void)initTabbarItemWithTitle:(NSString *)title imageNamed:(NSString *)imageName selectedImageNamed:(NSString *)selectedImageName
{
    self.title = title;
    self.tabBarItem.title = title;
    self.tabBarItem.image = [UIImage imageNamed:imageName];
    self.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
}

- (void) addShareSection
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    section.headerTitle = @"分享";
    
    RETableViewItem *sendItem = [RETableViewItem itemWithTitle:@"发送给朋友" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        DDLogDebug(@"should jump to the about page");
    }];
    sendItem.image = [UIImage imageNamed:@"tabbar_more_selected"];
    [section addItem:sendItem];
}

- (void) addSuggestSection
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    section.headerTitle = @"反馈与建议";
    
    RETableViewItem *contactItem = [RETableViewItem itemWithTitle:@"联系我们" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        DDLogDebug(@"should jump to the send email page");
    }];
    contactItem.image = [UIImage imageNamed:@"tabbar_more_selected"];
    
    RETableViewItem *scoreItem = [RETableViewItem itemWithTitle:@"打分" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        DDLogDebug(@"should jump to the send email page");
    }];
    scoreItem.image = [UIImage imageNamed:@"tabbar_more_selected"];
    
    [section addItem:contactItem];
    [section addItem:scoreItem];
}


- (void) addAboutSection
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    section.headerTitle = @"关于";
    
    RETableViewItem *aboutItem = [RETableViewItem itemWithTitle:@"关于" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        DDLogDebug(@"should jump to the about page");
    }];
    aboutItem.image = [UIImage imageNamed:@"tabbar_more_selected"];
    [section addItem:aboutItem];
}


- (void) addSettingSection
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    section.headerTitle = @"设置";
    
    RETableViewItem *cacheItem = [RETableViewItem itemWithTitle:@"清理缓存" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        DDLogDebug(@"%@",@"cleaning the cahce");
    }];
    cacheItem.image = [UIImage imageNamed:@"tabbar_more_selected"];
    
    REBoolItem *locationItem = [REBoolItem itemWithTitle:@"定位" value:NO switchValueChangeHandler:^(REBoolItem *item) {
        DDLogDebug(@"%@", @"toggle the location function");
    }];
    locationItem.image = [UIImage imageNamed:@"tabbar_more_selected"];
    
    
    [section addItem:cacheItem];
    [section addItem:locationItem];
}

@end
