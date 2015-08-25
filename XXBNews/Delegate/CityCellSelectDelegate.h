//
//  CityCellSelectDelegate.h
//  XXBNews
//
//  Created by xuxubin on 15/8/25.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#ifndef XXBNews_CityCellSelectDelegate_h
#define XXBNews_CityCellSelectDelegate_h

@protocol CityCellSelectDelegate <NSObject>

- (void) manageCityViewDidSelectCityCell:(NSString *)city;

@end

#endif
