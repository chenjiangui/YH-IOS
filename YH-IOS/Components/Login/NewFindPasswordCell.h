//
//  NewFindPasswordCell.h
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/7/29.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIHelper.h"
#import "UIColor+Hex.h"
#import "HttpResponse.h"
#import "Version.h"
#import <SCLAlertView.h>
#import "WebViewJavascriptBridge.h"
#import "FileUtils.h"
#import "HttpUtils.h"
#import "User.h"
#import "FileUtils+Assets.h"
#import "RMessage.h"
#import "RMessageView.h"
@interface NewFindPasswordCell : UITableViewCell<RMessageProtocol>
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) Version *version;
@property (nonatomic, strong) UIWebView *webView;
@property WebViewJavascriptBridge* bridge;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSString *assetsPath;
-(void)PeopleNumberDidChange:(UITextField*)PeopleNumber;
-(void)PhoneNumberDidChange:(UITextField*)PhoneNumber;
-(void)upTodata;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSString*)type;
@end
