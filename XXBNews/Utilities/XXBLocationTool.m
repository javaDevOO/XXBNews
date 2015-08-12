//
//  XXBLocationTool.m
//  XXBNews
//
//  Created by xuxubin on 15/8/12.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "XXBLocationTool.h"

//注意这里的implementation不要漏掉
@implementation XXBCity

@end

@interface XXBLocationTool ()

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) CLGeocoder *geoCoder;

@end

@implementation XXBLocationTool

static XXBLocationTool *sharedSingleton;

+ (XXBLocationTool *) sharedInstance
{
    static dispatch_once_t onceToken;
    //只调用一次，多次调用也只会执行一次
    dispatch_once(&onceToken, ^(void)
                  {
                      sharedSingleton = [[self alloc] init];
                  });
    return sharedSingleton;
}

- (id) init
{
    self = [super init];
    if(self)
    {
        self.geoCoder = [[CLGeocoder alloc] init];
        
        self.locMgr = [[CLLocationManager alloc] init];
        self.locMgr.delegate = self;
        [self.locMgr startUpdatingLocation];
    }
    return self;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    DDLogDebug(@"update location delegate");
    [self.locMgr stopUpdatingLocation];
    
    CLLocation *loc = locations[0];
    [self.geoCoder reverseGeocodeLocation:loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *place = placemarks[0];
         
         NSString *cityName = place.locality;
         cityName = [cityName substringToIndex:cityName.length-1];
         
         self.locationCity = [[XXBCity alloc] init];
         self.locationCity.city = cityName;
         self.locationCity.coordinate = loc.coordinate;
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationCity" object:nil];
     }];
}



@end
