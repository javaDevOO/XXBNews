//
//  XXBFileUtilities.h
//  XXBNews
//
//  Created by xuxubin on 15/8/10.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXBFileUtilities : NSObject

/**
 *  获取文件路径
 *
 *  @param filename  文件名
 *  @param extention 扩展名
 *
 *  @return 文件路径字符串
 */
+ (NSString *)getFilePathString:(NSString *)filename ofType:(NSString *)extention;

@end
