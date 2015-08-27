//
//  XXBMemoEditController.h
//  XXBNews
//
//  Created by xuxubin on 15/8/21.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memo.h"
#import "MemoEditDelegate.h"

typedef NS_ENUM (NSUInteger, MemoEditMode) {
    MemoEditModeAdd,
    MemoEditModeUpdate
};


@interface XXBMemoEditController : UIViewController

@property (nonatomic, strong) UITextView *contentTv;
@property (nonatomic) MemoEditMode mode;
@property (nonatomic, strong) Memo *memo;
@property (nonatomic, weak) id<MemoEditDelegate> delegate;

- (id) initWithMode:(MemoEditMode)mode withMemo:(Memo *)memo;

@end
