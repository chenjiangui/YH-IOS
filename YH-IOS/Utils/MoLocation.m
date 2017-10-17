//
//  MoLocation.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/10/17.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MoLocation.h"
#import <UIKit/UIKit.h>

@implementation MoLocation

static MoLocation *sharedGPs;


+(MoLocation *)shareGpsManager {
    return [[self alloc]init];
}


-(id)init {
    self = [super init];
    if (self) {
        manager = [[CLLocationManager alloc]init];
        manager.delegate = self;
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        // 兼容iOS8.0版本
        /* Info.plist里面加上2项
         NSLocationAlwaysUsageDescription      Boolean YES
         NSLocationWhenInUseUsageDescription   Boolean YES
         */
        
        // 请求授权 requestWhenInUseAuthorization用在>=iOS8.0上
        // respondsToSelector: 前面manager是否有后面requestWhenInUseAuthorization方法
        // 1. 适配 动态适配
        if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [manager requestWhenInUseAuthorization];
            [manager requestAlwaysAuthorization];
        }
        // 2. 另外一种适配 systemVersion 有可能是 8.1.1
        float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (osVersion >= 8) {
            [manager requestWhenInUseAuthorization];
            [manager requestAlwaysAuthorization];
        }
    }
    return self;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGPs = [super allocWithZone:zone];
    });
    return sharedGPs;
}


- (void) stop {
    [manager stopUpdatingLocation];
}

+ (void) stop {
    [[MoLocation shareGpsManager] stop];
}

// 每隔一段时间就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *loc in locations) {
        CLLocationCoordinate2D l = loc.coordinate;
        double lat = l.latitude;
        double lnt = l.longitude;
        
        successCallBack ? successCallBack(lat, lnt) : nil;
    }
}

- (void) getMoLocationWithSuccess:(MoLocationSuccess)success Failure:(MoLocationFailed)failure {
    successCallBack = [success copy];
    fialedCallBack = [failure copy];
    // 停止上一次的
    [manager stopUpdatingLocation];
    // 开始新的数据定位
    [manager startUpdatingLocation];
}


+ (void) getMoLocationWithSuccess:(MoLocationSuccess)success Failure:(MoLocationFailed)failure {
    [[MoLocation shareGpsManager] getMoLocationWithSuccess:success Failure:failure];
}

//失败代理方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    fialedCallBack ? fialedCallBack(error) : nil;
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}

@end
