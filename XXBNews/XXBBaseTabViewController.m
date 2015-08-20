//
//  BaseTabViewController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/6.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBBaseTabViewController.h"

@interface XXBBaseTabViewController ()

@end

@implementation XXBBaseTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initTabbarItemWithTitle:(NSString *)title imageNamed:(NSString *)imageName selectedImageNamed:(NSString *)selectedImageName
{
    self.title = title;
    self.tabBarItem.title = title;
    self.tabBarItem.image = [UIImage imageNamed:imageName];
    self.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
}

@end
