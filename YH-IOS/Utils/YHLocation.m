//
//  YHLocation.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/7/13.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface YHLocation()<CLLocationManagerDelegate,AMapLocationManagerDelegate>

//@property (nonatomic, strong)CLLocationManager *locationManager;

@end

@implementation YHLocation

+(instancetype)shareInstance{
    static YHLocation* _shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[YHLocation alloc]init];
    });
    return _shareInstance;
}

//-(void)startLocation {
//    if ([CLLocationManager locationServicesEnabled]) {
//        self.locationManager = [[CLLocationManager alloc]init];
//        self.locationManager.delegate = self;
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
//        [self.locationManager requestAlwaysAuthorization];
//        self.locationManager.distanceFilter = 10.0f;
//        [self.locationManager requestAlwaysAuthorization];
//        [self.locationManager startUpdatingLocation];
//    }
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    if ([error code] == kCLErrorDenied) {
//        NSLog(@"访问被拒绝");
//    }
//    if ([error code] == kCLErrorLocationUnknown) {
//        NSLog(@"无法获取位置信息");
//    }
//}
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    CLLocation *newLocation = locations[0];
//    
//    // 获取当前所在的城市名
//    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
//    
//    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
//    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
//    [manager stopUpdatingLocation];
//    self.userlatitude = [NSString stringWithFormat:@"%f",oldCoordinate.latitude];
//    self.userLongitude = [NSString stringWithFormat:@"%f", oldCoordinate.longitude];
//    
//}
#pragma mark 定位初始化化
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    //    偏差 100米
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setLocationTimeout:6];
    
    [self.locationManager setReGeocodeTimeout:3];
}

#pragma mark 以下为定位得出经纬度
- (void)locateAction
{
    //带逆地理的单次定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        NSLog(@"旧的经度：%f,旧的纬度：%f",location.coordinate.longitude,location.coordinate.latitude);
        self.userLongitude=[NSString stringWithFormat:@"%.6f",location.coordinate.longitude];
        self.userlatitude =[NSString stringWithFormat:@"%f",location.coordinate.latitude];
    }];
}



@end
