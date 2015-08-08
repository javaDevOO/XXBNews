//
//  XXBWeatherManager.h
//  XXBNews
//
//  Created by xuxubin on 15/8/8.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXBWeatherManager : NSObject

+ (void)getWeatherDataWithCity:(NSString *)city success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

@end
