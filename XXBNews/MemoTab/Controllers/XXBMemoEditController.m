//
//  XXBMemoEditController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/21.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBMemoEditController.h"
#import "Memo.h"
#import "AppDelegate.h"
#import "XXBTimeTool.h"

@interface XXBMemoEditController ()

@end

@implementation XXBMemoEditController

- (id) initWithMode:(MemoEditMode)mode withMemo:(Memo *)memo
{
    self = [super init];
    if(self)
    {
        self.title = @"编辑备忘";
        self.memo = memo;
        self.mode = mode;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveMemo)];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentTv = [[UITextView alloc] initWithFrame:self.view.frame];
    self.contentTv.font = [UIFont systemFontOfSize:24.0];
    if(self.memo != nil)
    {
        self.contentTv.text = self.memo.content;
    }
    if(self.mode == MemoEditModeAdd)
    {
        [self.contentTv becomeFirstResponder];
    }
    [self.view addSubview:self.contentTv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) saveMemo
{
    NSString *content = self.contentTv.text;
    NSString *trimContent = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(self.mode == MemoEditModeUpdate && ![trimContent isEqualToString:@""] && ![self.memo.content isEqualToString:content])
    {
        // 更新数据库里面的记录
        self.memo.content = content;
    }
    if(self.mode == MemoEditModeAdd && ![trimContent isEqualToString:@""])
    {
        // 通过代理添加一条新的记录
        [self.delegate memoEditController:self addMemoWithContent:content];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
