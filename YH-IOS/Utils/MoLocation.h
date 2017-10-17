//
//  MoLocation.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/10/17.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef void(^MoLocationSuccess) (double lat, double lbg);
typedef void(^MoLocationFailed) (NSError *error);


@interface MoLocation : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *manager;
    MoLocationSuccess successCallBack;
    MoLocationFailed fialedCallBack;
}

+(MoLocation *)shareGpsManager;
+(void)getMoLocationWithSuccess:(MoLocationSuccess)success Failure:(MoLocationFailed)failed;
+(void)stop;

@end
