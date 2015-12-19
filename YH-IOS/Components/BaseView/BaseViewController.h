//
//  BaseView.h
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "const.h"
#import "FileUtils.h"
#import "HttpUtils.h"
#import <MBProgressHUD.h>
#import "WebViewJavascriptBridge.h"
#import "HttpResponse.h"
#import <SCLAlertView.h>
#import "UIColor+Hex.h"
#import "User.h"
//#import <WebKit/WebKit.h>

@interface BaseViewController : UIViewController<UIWebViewDelegate>

@property WebViewJavascriptBridge* bridge;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (weak, nonatomic) IBOutlet UILabel *labelTheme;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) User *user;

- (NSString *)stringWithContentsOfFile:(NSString *)htmlPath;
- (void)clearBrowserCache;
- (void)showLoading;
- (void)showLoading:(BOOL)isLogin;

- (void)showProgressHUD:(NSString *)text;

@end