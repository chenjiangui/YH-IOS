//
//  TemplateSixViewController.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/8/21.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"
#import "BaseWebViewController.h"
#import "BaseViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface TemplateSixViewController :BaseWebViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UMSocialUIDelegate>

@property (strong, nonatomic) NSString *bannerName;
@property (strong, nonatomic) NSString *link;
@property (assign, nonatomic) CommentObjectType commentObjectType;
@property (strong, nonatomic) NSString *objectID;
// 内部报表具有胡筛选功能时，用户点击的选项
@property (strong, nonatomic) NSString *selectedItem;

//高德定位
@property(nonatomic,strong) AMapLocationManager *locationManager;


@end