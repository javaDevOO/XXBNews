//
//  XXBHttpTool.m
//  XXBNews
//
//  Created by xuxubin on 15/8/8.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBHttpTool.h"
#import <AFNetworking.h>

@implementation XXBHttpTool

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                DDLogDebug(@"%@",@"无网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                DDLogDebug(@"%@",@"WiFi网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                DDLogDebug(@"%@",@"无线网络");
                break;
            }
            default:
                break;
        }
    }];
    
    // 创建一个manager对象，单例
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObj)
         {
             if(success)
             {
                 success(responseObj);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError * error)
         {
            if(failure)
            {
                failure(error);
            }
         }
     ];
}

@end
