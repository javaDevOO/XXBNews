//
//  XXBMemoItem.h
//  XXBNews
//
//  Created by xuxubin on 15/8/16.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXBMemoItem : NSObject

@property (nonatomic, copy)   NSString *content;
@property (nonatomic, strong) NSDate   *date;
@property (nonatomic)         BOOL     isDone;

@end
