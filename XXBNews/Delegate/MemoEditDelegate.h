//
//  MemoEditDelegate.h
//  XXBNews
//
//  Created by xuxubin on 15/8/27.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#ifndef XXBNews_MemoEditDelegate_h
#define XXBNews_MemoEditDelegate_h


#import "Memo.h"
//如果这里import .h文件，会造成头文件循环引用
//解决方法1：用@class
//解决方法2：用XXBMemoEditController的基类，基类指针可以指向子类
//#import "XXBMemoEditController.h"

@protocol MemoEditDelegate <NSObject>

- (void) memoEditController:(UIViewController *)memoEditController addMemo:(Memo *)memo;

- (void) memoEditController:(UIViewController *)memoEditController updateMemo:(Memo *)memo;

@end

#endif
