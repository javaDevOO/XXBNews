//
//  Memo.h
//  XXBNews
//
//  Created by xuxubin on 15/8/27.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Memo : NSManagedObject

//TODO:需要一个属性来唯一确定一条记录
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * isFinished;//[self.isFinished boolValue];[NSNumber numberWithBool:YES];
@property (nonatomic, retain) NSDate * createDate;

@end
