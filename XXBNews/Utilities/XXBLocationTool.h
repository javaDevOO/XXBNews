//
//  XXBLocationTool.h
//  XXBNews
//
//  Created by xuxubin on 15/8/12.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface XXBCity : NSObject
@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end

/**
 *  模拟器上暂时没法调试
 *  使用了单例
 */
@interface XXBLocationTool : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) XXBCity *locationCity;

+ (XXBLocationTool *) sharedInstance;

@end
