//
//  ChartViewController.h
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//


#import "UMSocialControllerService.h"
#import "BaseWebViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>

#define WeakSelf  __weak typeof(*&self) weakSelf = self;

@interface SubjectViewController: BaseWebViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UMSocialUIDelegate>

@property (strong, nonatomic) NSString *bannerName;
@property (strong, nonatomic) NSString *link;
@property (assign, nonatomic) CommentObjectType commentObjectType;
@property (strong, nonatomic) NSNumber *objectID;
// 内部报表具有胡筛选功能时，用户点击的选项
@property (strong, nonatomic) NSString *selectedItem;
//高德定位
@property(nonatomic,strong) AMapLocationManager *locationManager;

@end
