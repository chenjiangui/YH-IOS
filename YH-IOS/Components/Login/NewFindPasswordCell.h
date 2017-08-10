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

@interface NewFindPasswordCell : UITableViewCell

@property WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) Version *version;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *assetsPath;
@property (nonatomic, strong) UIButton *upDataBtn;

-(void)PeopleNumberDidChange:(UITextField*)PeopleNumber;
-(void)PhoneNumberDidChange:(UITextField*)PhoneNumber;
-(void)upTodata;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSString*)type;

@end
