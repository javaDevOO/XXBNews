//
//  XXBMemoEditController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/21.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBMemoEditController.h"

@interface XXBMemoEditController ()

@end

@implementation XXBMemoEditController

- (id) init
{
    self = [super init];
    if(self)
    {
        self.title = @"编辑备忘";
        UILabel *lb = [[UILabel alloc] initWithFrame:self.view.frame];
        self.view.backgroundColor = [UIColor blueColor];
        lb.text = @"编辑";
        [self.view addSubview:lb];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
