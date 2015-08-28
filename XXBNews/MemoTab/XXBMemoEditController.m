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

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation XXBMemoEditController

- (id) initWithMode:(MemoEditMode)mode withMemo:(Memo *)memo
{
    self = [super init];
    if(self)
    {
        self.title = @"编辑备忘";
        self.memo = memo;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveMemo)];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentTv = [[UITextView alloc] initWithFrame:self.view.frame];
    self.contentTv.backgroundColor = [UIColor blueColor];
    self.contentTv.font = [UIFont systemFontOfSize:15.0];
    if(self.memo != nil)
    {
        self.contentTv.text = self.memo.content;
    }
    [self.contentTv becomeFirstResponder];
    [self.view addSubview:self.contentTv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) saveMemo
{
    NSString *content = self.contentTv.text;
    Memo *newMemo = [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:self.managedObjectContext];
    newMemo.content = content;
    newMemo.isFinished = [NSNumber numberWithBool:NO];
    newMemo.createDate = [XXBTimeTool localeDate];
    if(self.mode == MemoEditModeUpdate && ![self.memo.content isEqualToString:content])
        [self.delegate memoEditController:self updateOldMemo:self.memo toNewMemo:newMemo];
    if(self.mode == MemoEditModeAdd)
        [self.delegate memoEditController:self addMemo:newMemo];
    DDLogDebug(@"should save memo %@",content);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
