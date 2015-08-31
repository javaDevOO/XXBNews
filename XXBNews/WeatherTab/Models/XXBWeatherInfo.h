//
//  XXBWeatherInfo.h
//  XXBNews
//
//  Created by xuxubin on 15/8/8.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <Foundation/Foundation.h>

// 细节信息
@interface XXBIndexDetail : NSObject
// 标题
@property (nonatomic, copy) NSString *title;
// 内容
@property (nonatomic, copy) NSString *zs;
// 指数
@property (nonatomic, copy) NSString *tipt;
// 细节
@property (nonatomic, copy) NSString *des;

@end


// 天气详情
@interface XXBWeatherDetail : NSObject

@property (nonatomic, copy) NSString *cityName;
// 日期
@property (nonatomic, copy) NSString *date;
// 天气
@property (nonatomic, copy) NSString *weather;
// 风力
@property (nonatomic, copy) NSString *wind;
// 温度
@property (nonatomic, copy) NSString *temperature;
// 白天图片url
@property (nonatomic, copy) NSString *dayPictureUrl;
// 夜间图片url
@property (nonatomic, copy) NSString *nightPictureUrl;

/**
 *  获取最高温度
 *
 *  @return 最高温度
 */
- (NSNumber *) getHighTemperature;


/**
 *  获取最低温度
 *
 *  @return 最低温度
 */
- (NSNumber *) getLowTemperature;

@end


//天气信息的数据模型，要根据天气API返回的数据格式建立，此处采用的是百度车联网API的天气接口
@interface XXBWeatherInfo : NSObject
// 当前城市
@property (nonatomic, copy) NSString *currentCity;
// 当前日期
@property (nonatomic, copy) NSString *date;
// pm25
@property (nonatomic, copy) NSString *pm25;
// 细节信息，
@property (nonatomic, strong) NSArray *index;
// 天气详情
@property (nonatomic, strong) NSArray *weather_data;

+ (NSDictionary *)objectClassInArray;

- (int) getRealTimeTemp;

- (XXBWeatherDetail *)getTodayDetail;
@end



