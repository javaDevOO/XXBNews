//
//  XXBMemoItem.h
//  XXBNews
//
//  Created by xuxubin on 15/8/16.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXBMemoItem : NSObject

@property (nonatomic, copy)     NSString *content;
@property (nonatomic, readonly) NSDate   *createDate;
@property (nonatomic)           BOOL     isDone;

@end
