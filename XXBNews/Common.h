//
//  Common.h
//  XXBNews
//
//  Created by xuxubin on 15/8/7.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//
#import <CocoaLumberjack/DDLog.h>
#ifndef XXBNews_Common_h
#define XXBNews_Common_h
#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif

#endif
