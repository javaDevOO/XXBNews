//
//  AppDelegate.m
//  REMenuExample
//
//  Created by Roman Efimov on 2/20/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "AppDelegate.h"
#import "XXBMainTabBarController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    XXBMainTabBarController *tab = [[XXBMainTabBarController alloc] init];
    
    
    self.window.rootViewController = tab;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
