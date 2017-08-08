//
//  NewSubjectViewController.h
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/7/31.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "User.h"
#import "HttpUtils.h"
#import "APIHelper.h"
#import "FileUtils+Assets.h"
#import <MBProgressHUD.h>
#import "WebViewJavascriptBridge.h"
//use wkwebview
#import "UMSocialControllerService.h"
#import "HttpResponse.h"
#import <SCLAlertView.h>
#import "UIColor+Hex.h"
#import "UIWebview+Clean.h"
#import "LTHPasscodeViewController.h"
#import "ExtendNSLogFunctionality.h"
#import <WebKit/WebKit.h>

#define WeakSelf  __weak typeof(*&self) weakSelf = self;

@interface NewSubjectViewController : UIViewController


//@property (assign) id <WebViewJavascriptBridgeBaseDelegate> bridgeDelegate;
@property WebViewJavascriptBridge* bridge;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) NSString *sharedPath;
@property (strong, nonatomic) User *user;

@property (strong, nonatomic) WKWebView *browser;

- (void)clearBrowserCache;
- (void)showLoading:(LoadingType)loadingType;
- (void)jumpToLogin;
- (void)showProgressHUD:(NSString *)text;
- (void)showProgressHUD:(NSString *)text mode:(MBProgressHUDMode)mode;

/**
 *  设置是否允许横屏
 *
 *  @param allowRotation 允许横屏
 */
- (void)setAppAllowRotation:(BOOL)allowRotation;

/**
 *  检测服务器端静态文件是否更新
 */
- (void)checkAssetsUpdate;

#pragma mark - LTHPasscode delegate methods
- (void)passcodeWasEnteredSuccessfully;
- (BOOL)didPasscodeTimerEnd;
- (NSString *)passcode;
- (void)savePasscode:(NSString *)passcode;
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view;


@property (strong, nonatomic) NSString *bannerName;
@property (strong, nonatomic) NSString *link;
@property (assign, nonatomic) CommentObjectType commentObjectType;
@property (strong, nonatomic) NSNumber *objectID;
// 内部报表具有胡筛选功能时，用户点击的选项
@property (strong, nonatomic) NSString *selectedItem;


- (void) _setupInstance:(WKWebView*)webView;

@end
