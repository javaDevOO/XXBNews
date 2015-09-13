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
    
    // 创建一个manager对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
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
    
//    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"GET" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//    } error:nil];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if(success)
//        {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if(failure)
//        {
//            failure(error);
//        }
//    }];
//    [operation start];
}

@end
