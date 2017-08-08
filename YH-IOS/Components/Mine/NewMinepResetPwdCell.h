//
//
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/7/30.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "APIHelper.h"
#import "HttpResponse.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "FileUtils.h"
#import "LoginViewController.h"

@interface NewMinepResetPwdCell : UITableViewCell
{
    UITableView *ResetPwdTableView;
    UIButton *saveBtn;
    UITextField *NewPwdNumber;
    UITextField *RequestPwdNumber;
    UIButton *NewPwdON;
    UIButton *RequestON;
    User *user;
}
-(void)newPwdOnOrOffBtn:(UIButton *)newBtn;
-(void)RequestOnOrOffBtn:(UIButton *)RequestPwdBtn;
-(void)OldPwdDidChange:(UITextField*)OldPwdNumber;
-(void)NewPwdDidChange:(UITextField*)NewPwdTextField;
-(void)RequestPwdDidChange:(UITextField*)RequestTextField;
-(void)saveBtn;
- (void)jumpToLogin;
- (void)changLocalPwd:(NSString *)newPassword;
-(int)checkIsHaveNumAndLetter:(NSString*)password;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSString*)type;

@end
