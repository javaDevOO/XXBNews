//
//  MoreInfoViewController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/5.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBMoreInfoTabController.h"

@interface XXBMoreInfoTabController ()

@end

@implementation XXBMoreInfoTabController

- (id) init
{
    self = [super init];
    if(self)
    {
        [self initTabbarItemWithTitle:@"更多" imageNamed:@"tabbar_more" selectedImageNamed:@"tabbar_more_selected"];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
