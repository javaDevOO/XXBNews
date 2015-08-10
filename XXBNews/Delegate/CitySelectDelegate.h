//
//  CitySelectDelegate.h
//  XXBNews
//
//  Created by xuxubin on 15/8/10.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#ifndef XXBNews_CitySelectDelegate_h
#define XXBNews_CitySelectDelegate_h

@protocol CitySelectDelegate <NSObject>

- (void) selectCityViewDidSelectCity:(NSString *)city;

@end

#endif
