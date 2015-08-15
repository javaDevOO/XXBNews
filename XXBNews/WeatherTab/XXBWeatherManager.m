//
//  XXBWeatherManager.m
//  XXBNews
//
//  Created by xuxubin on 15/8/8.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBWeatherManager.h"
#import "XXBHttpTool.h"

#define baidukey @"a84HFGPpNOFhgrfGWb2qIBBh"

@implementation XXBWeatherManager

+ (void)getWeatherDataWithCity:(NSArray *)cities success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 百度开放平台上的文档没写清楚，还需要一个mcode参数
    params[@"location"] = [cities componentsJoinedByString:@"|"];
    params[@"output"] = @"json";
    params[@"ak"] = baidukey;
    params[@"mcode"] = @"sysu.XXBNews";
    
    // 发送请求
    [XXBHttpTool getWithURL:@"http://api.map.baidu.com/telematics/v3/weather?" params:params success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
            DDLogDebug(@"%@",error);
        }
    }];
    
    DDLogDebug(@"send the weather to baidu");
    DDLogDebug(params[@"location"]);
}

@end
