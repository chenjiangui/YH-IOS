//
//  NewLoginViewController.m
//  YH-IOS
//
//  Created by li hao on 16/8/4.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "LoginViewController.h"
#import "DashboardViewController.h"
#import "APIHelper.h"
#import "NSString+MD5.h"
#import <PgyUpdate/PgyUpdateManager.h>
#import "UMessage.h"
#import "Version.h"
#import "FindPasswordViewController.h"
#import "MianTabBarViewController.h"
#import "YHLocation.h"
#import <CoreLocation/CoreLocation.h>
#import "OpenUDID.h"
#import "HttpModel.h"

#define kSloganHeight [[UIScreen mainScreen]bounds].size.height / 6


@interface LoginViewController () <UITextFieldDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate,AMapLocationManagerDelegate>


@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *sloganLabel;
@property (nonatomic, strong) UIImageView *loginUserImage;
@property (nonatomic, strong) UIView *seperateView1;
@property (nonatomic, strong) UIImageView *loginPasswordImage;
@property (nonatomic, strong) UIView *seperateView2;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, assign) int sideblank;
@property (nonatomic, strong) Version *version;
@property (nonatomic, strong) UIButton *registerBtn;
//@property (nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) NSString *userLongitude;
@property(nonatomic, strong) NSString *userlatitude;
@property(nonatomic, strong) UIButton *logoInBtn;



@property (nonatomic, strong)UITextField *passwordNumber;
@property (nonatomic, strong)UITextField  *peopleNumber;


@property (nonatomic, copy)NSString *peopleNumString;

@property (nonatomic, copy)NSString *passwordNumString;

@property (nonatomic, strong)UIView *PasswordUnderLine;
@property (nonatomic, strong)UIView *PeopleUnderLine;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self startLocation];
    [self configLocationManager];
    [self locateAction];
    UIImageView *Logo =[[UIImageView alloc] init];
    [self.view addSubview:Logo];
    [Logo setImage:[UIImage imageNamed:@"logo"]];
    [Logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_topMargin).offset(adaptHeight(132));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    _PeopleUnderLine = [[UIView alloc]init];
    _PeopleUnderLine.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.view addSubview:_PeopleUnderLine];
    [_PeopleUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Logo.mas_bottom).offset(101);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(245, 1));
    }];
    
    
    _peopleLogo=[[UIImageView alloc] init];
    [_peopleLogo setImage:[UIImage imageNamed:@"login_name"]];
    [self.view addSubview:_peopleLogo];
    [_peopleLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Logo.mas_bottom).offset(75);
        make.left.mas_equalTo(_PeopleUnderLine.mas_left);
        make.size.mas_equalTo(CGSizeMake(14, 18));
    }];
    
    _peopleNumber=[[UITextField alloc] init];
    [self.view addSubview:_peopleNumber];
    _peopleNumber.font=[UIFont systemFontOfSize:15];
    _peopleNumber.textAlignment=NSTextAlignmentLeft;
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if (![userDict[@"user_name"] isEqualToString:@""] && userDict[@"user_name"]) {
        _peopleNumber.text = userDict[@"user_num"];
        _peopleNumString=userDict[@"user_num"];
    }
    else
    {
        _peopleNumber.placeholder=@"员工号";
    }
    _peopleNumber.borderStyle = UITextBorderStyleNone;
    [_peopleNumber addTarget:self action:@selector(peopleNumberChange:) forControlEvents:UIControlEventEditingChanged];
    [_peopleNumber addTarget:self action:@selector(peopleDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_peopleNumber addTarget:self action:@selector(peopleDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [_peopleNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_peopleLogo.mas_centerY);
        make.top.mas_equalTo(Logo.mas_bottom).offset(76);
        make.left.mas_equalTo(_peopleLogo.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(195, 30));
    }];
    _PasswordLogo=[[UIImageView alloc] init];
    [_PasswordLogo setImage:[UIImage imageNamed:@"login_password"]];
    [self.view addSubview:_PasswordLogo];
    [_PasswordLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_PeopleUnderLine.mas_bottom).offset(20);
        make.left.mas_equalTo(_peopleLogo);
        make.size.mas_equalTo(CGSizeMake(14, 18));
    }];
    
    
    _passwordNumber=[[UITextField alloc] init];
    [self.view addSubview:_passwordNumber];
    [_passwordNumber setSecureTextEntry:YES];
    _passwordNumber.placeholder = @"密码";
    _passwordNumber.font=[UIFont systemFontOfSize:16];
    _passwordNumber.textAlignment=NSTextAlignmentLeft;
    _passwordNumber.textColor=[UIColor colorWithHexString:@"#666666"];
    [_passwordNumber addTarget:self action:@selector(PasswordDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_passwordNumber addTarget:self action:@selector(PasswordDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_passwordNumber addTarget:self action:@selector(PasswordDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [_passwordNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_peopleNumber.mas_left);
        make.centerY.mas_equalTo(_PasswordLogo.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(195, 30));
    }];
    
    _PasswordUnderLine = [[UIView alloc]init];
    _PasswordUnderLine.backgroundColor= [UIColor colorWithHexString:@"#e6e6e6"];
    [self.view addSubview:_PasswordUnderLine];
    [_PasswordUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(_PeopleUnderLine.mas_left);
        make.top.mas_equalTo(_PasswordLogo.mas_bottom).offset(8);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(245, 1));
    }];
    
    
    
    //    UIButton *deleteLogo=[[UIButton alloc] init];
    //    [deleteLogo setBackgroundImage:[UIImage imageNamed:@"btn_empty"] forState:UIControlStateNormal];
    //    [deleteLogo addTarget:self action:@selector(deleteOldPassword) forControlEvents:UIControlEventTouchDown];
    //    [self.view addSubview:deleteLogo];
    //    [deleteLogo mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.mas_equalTo(_PasswordLogo);
    //        make.right.mas_equalTo(_PasswordUnderLine).offset(-8);
    //        make.size.mas_equalTo(CGSizeMake(10, 10));
    //    }];
    //
    WeakSelf;
    _logoInBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_logoInBtn setTitle:@"登录" forState:UIControlStateNormal];
    _logoInBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
    [_logoInBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [weakSelf loginBtnClick];
    }];
    [_logoInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logoInBtn setBackgroundImage:@"btn_login".imageFromSelf forState:UIControlStateNormal];
    _logoInBtn.clipsToBounds=YES;
    _logoInBtn.titleEdgeInsets = UIEdgeInsetsMake(-6, 0, 6, 0);
    [self.view addSubview:_logoInBtn];
    [_logoInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_PasswordUnderLine.mas_bottom).offset(24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(@"btn_login".imageFromSelf.size);
    }];
    UIButton *forGotPwd=[UIButton buttonWithType:UIButtonTypeCustom];
    [forGotPwd setTitle:@"忘记密码" forState:UIControlStateNormal];
    forGotPwd.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    //    forGotPwd.titleLabel.font = [UIFont systemFontOfSize:13];
    [forGotPwd addTarget:self action:@selector(jumpToFindPassword) forControlEvents:UIControlEventTouchDown];
    [forGotPwd setTitleColor:[UIColor colorWithHexString:@"bcbcbc"] forState:UIControlStateNormal];
    [self.view addSubview:forGotPwd];
    
    UIView *line=[[UIView alloc] init];
    [line setBackgroundColor:[UIColor colorWithHexString:@"bcbcbc"]];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(forGotPwd.mas_centerY).offset(0);
        make.left.mas_equalTo(forGotPwd.mas_right).offset(16);
        make.size.mas_equalTo(CGSizeMake(0.5,14));
    }];
    [forGotPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-40);
        make.right.mas_equalTo(line.mas_left).offset(-16);
        // make.size.mas_equalTo(CGSizeMake(55,13));
    }];
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"申请注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchDown];
    [registerBtn setTitleColor:[UIColor colorWithHexString:@"bcbcbc"] forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-40);
        make.left.mas_equalTo(line.mas_right).offset(16);
        // make.size.mas_equalTo(CGSizeMake(55,13));
    }];
}

-(void)peopleNumberChange:(UITextField*)PeopleNumber
{
    _PeopleUnderLine.backgroundColor = [UIColor colorWithRed:0.24 green:0.69 blue:0.98 alpha:1];
    
    _peopleNumString=PeopleNumber.text;
}

-(void)peopleDidBegin:(UITextField*)PeopleNumber
{
    // NSLog(@"PhoneNumberDidChange===%@",peopleNumber.text);
    _peopleNumString=PeopleNumber.text;
    _PeopleUnderLine.backgroundColor = [UIColor colorWithRed:0.24 green:0.69 blue:0.98 alpha:1];
    
    _PeopleDelete=[[UIButton alloc] init];
    [_PeopleDelete setBackgroundImage:[UIImage imageNamed:@"btn_empty"] forState:UIControlStateNormal];
    [_PeopleDelete addTarget:self action:@selector(deleteNumber) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_PeopleDelete];
    [_PeopleDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_peopleLogo);
        make.right.mas_equalTo(_PeopleUnderLine).offset(-8);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    _BigPeopleDelete=[[UIButton alloc] init];
    [_BigPeopleDelete addTarget:self action:@selector(deleteNumber) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_BigPeopleDelete];
    [_BigPeopleDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_peopleLogo);
        make.right.mas_equalTo(_PeopleUnderLine);
        make.size.mas_equalTo(CGSizeMake(20, 47));
    }];
    
}

-(void)peopleDidEnd:(UITextField*)PeopleNumber
{
    _PeopleUnderLine.backgroundColor= [UIColor colorWithHexString:@"#e6e6e6"];
    [_PeopleDelete removeFromSuperview];
    [_BigPeopleDelete removeFromSuperview];
}

-(void)PasswordDidChange:(UITextField*)PasswordNumber
{
    _passwordNumString=PasswordNumber.text;
    _PasswordUnderLine.backgroundColor = [UIColor colorWithRed:0.24 green:0.69 blue:0.98 alpha:1];
    
}
-(void)PasswordDidBegin:(UITextField*)PeopleNumber
{
    // NSLog(@"PhoneNumberDidChange===%@",peopleNumber.text);
    _passwordNumString=PeopleNumber.text;
    _PasswordUnderLine.backgroundColor = [UIColor colorWithRed:0.24 green:0.69 blue:0.98 alpha:1];
    
    _PasswoedDelete=[[UIButton alloc] init];
    [_PasswoedDelete setBackgroundImage:[UIImage imageNamed:@"btn_empty"] forState:UIControlStateNormal];
    [_PasswoedDelete addTarget:self action:@selector(deleteOldPassword) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_PasswoedDelete];
    [_PasswoedDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_PasswordLogo);
        make.right.mas_equalTo(_PasswordUnderLine).offset(-8);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    _BigPasswoedDelete=[[UIButton alloc] init];
    [_BigPasswoedDelete addTarget:self action:@selector(deleteOldPassword) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_BigPasswoedDelete];
    [_BigPasswoedDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_PasswordLogo);
        make.right.mas_equalTo(_PasswordUnderLine);
        make.size.mas_equalTo(CGSizeMake(20, 47));
    }];
}

-(void)PasswordDidEnd:(UITextField*)PeopleNumber
{
    _PasswordUnderLine.backgroundColor= [UIColor colorWithHexString:@"#e6e6e6"];
    [_PasswoedDelete removeFromSuperview];
    [_BigPasswoedDelete removeFromSuperview];
}

-(void)deleteOldPassword
{
    _passwordNumber.text=@"";
    _PasswordUnderLine.backgroundColor= [UIColor colorWithHexString:@"#cccccc"];
}
-(void)deleteNumber
{
    _peopleNumber.text=@"";
    _peopleNumber.placeholder=@"员工号";
    _peopleNumString=@"";
    _PeopleUnderLine.backgroundColor= [UIColor colorWithHexString:@"#cccccc"];
}
// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark 定位初始化化
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
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

- (void)userinfomoveToTop:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.bgView.frame = CGRectMake(0, - height + height / 2, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)userinfoMoveToBottom:(NSNotification *)aNotification {
    self.bgView.frame = self.view.frame;
}


// 找回密码
- (void)jumpToFindPassword {
    
    FindPasswordViewController *findPwdViewController = [[FindPasswordViewController alloc]init];
    UINavigationController *findPwdCtrl = [[UINavigationController alloc]initWithRootViewController:findPwdViewController];
    [self presentViewController:findPwdCtrl animated:YES completion:nil];
}

// 点击注册按钮
-(void)clickRegisterBtn {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?keyname=prompt-info-when-register&api_token=%@",kBaseUrl,YHAPI_REGISTER,ApiToken(YHAPI_REGISTER)];
    
    [YHHttpRequestAPI yh_getWithUrl:urlString Finish:^(BOOL success, id model, NSString *jsonObjc)  {
        if (success) {
            HttpModel *httpModel = [HttpModel mj_objectWithKeyValues:model];
            [HudToolView showTopWithText:httpModel.data color:[NewAppColor yhapp_11color]];
        }
        else {
            [HudToolView showTopWithText:@"请到数据化运营平台申请开通账号" color:[NewAppColor yhapp_11color]];
        }
    }];
}

//延时执行函数
-(void)delayMethod
{
  self.view.userInteractionEnabled=YES;
  [HudToolView hideLoadingInView:self.view];

}

//add: 登录按钮事件
- (void)loginBtnClick {
    
    self.view.userInteractionEnabled=NO;
    
    if ([self.peopleNumString length]==0) {
        [HudToolView showTopWithText:@"请输入用户名" correct:false];
        [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
        return;
    }
    else if ([self.passwordNumString length] == 0) {
        [HudToolView showTopWithText:@"请输入密码" correct:false];
        [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
        return;
    }
    [HudToolView showLoadingInView:self.view];
    NSString *coordianteString = [NSString stringWithFormat:@"%@,%@",self.userLongitude,self.userlatitude];
    [[NSUserDefaults standardUserDefaults] setObject:coordianteString forKey:@"USERLOCATION"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *msg = [APIHelper userAuthentication:_peopleNumString password:_passwordNumString.md5 coordinate:coordianteString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HudToolView hideLoadingInView:self.view];
            if (!(msg.length == 0)) {
                if (self.navigationController.navigationBarHidden) {
                    [self.navigationController setNavigationBarHidden:NO];
                }
                [HudToolView showTopWithText:msg correct:false];
                
                //        [HudToolView hideLoadingInView:self.view];
                [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
                
                _logoInBtn.userInteractionEnabled=YES;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    // 用户行为记录, 单独异常处理，不可影响用户体验
                    
                    @try {
                        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                        NSString *coordianteString = [NSString stringWithFormat:@"%@,%@",self.userLongitude,self.userlatitude];
                        logParams[@"action"]  = @"unlogin";
                        logParams[@"user_name"] = [NSString stringWithFormat:@"%@|;|%@",self.userNameText.text,[self.userPasswordText.text md5]];
                        logParams[@"coordinate"] = coordianteString;
                        logParams[@"platform"] = @"iOS";
                        logParams[@"obj_title"] = msg;
                        logParams[@"app_version"] =[NSString stringWithFormat:@"i%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
                        NSString *urlString = [NSString stringWithFormat:kActionLogAPIPath, kBaseUrl];
                        NSMutableDictionary *params = [NSMutableDictionary dictionary];
                        params[kActionLogALCName] = logParams;
                        [HttpUtils httpPost:urlString Params:params];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"%@", exception);
                    }
                });
                return;
            }

            NSMutableDictionary *deviceDict = [NSMutableDictionary dictionary];
            deviceDict[kAPI_TOEKN] = ApiToken(YHAPI_UPLOAD_DEVICEMESSAGE);
            deviceDict[kUserNumCUName] = _peopleNumString;
            deviceDict[@"device"] = @{
                                      @"name": [[UIDevice currentDevice] name],
                                      @"platform": @"ios",
                                      @"os": [Version machineHuman],
                                      @"os_version": [[UIDevice currentDevice] systemVersion],
                                      @"uuid": [OpenUDID value],
                                      };
            deviceDict[@"app_version"] = [NSString stringWithFormat:@"i%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
            deviceDict[@"coordinate"] = coordianteString;
            deviceDict[@"browser"] = @"Mozilla/5.0 (iPhone; CPU iPhone OS 9_2_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13D15";
            [YHHttpRequestAPI yh_postDict:deviceDict to:YHAPI_UPLOAD_DEVICEMESSAGE Finish:^(BOOL success, id model, NSString *jsonObjc) {
                if (success) {
                    NSLog(@"成功");
                    [self saveUserDict:jsonObjc];
                }
            }];
            
            NSDictionary *storeIdDict = @{
                                           kAPI_TOEKN:ApiToken(YHAPI_USER_STORELIST),
                                           kUserNumCUName:_peopleNumString
                                          };
        
            [YHHttpRequestAPI yh_getDataFrom:YHAPI_USER_STORELIST with:storeIdDict Finish:^(BOOL success, id model, NSString *jsonObjc) {
                if (success) {
                    [self saveUserStoreDict:jsonObjc];
                }
            }];
            
            [HudToolView hideLoadingInView:self.view];
            [self jumpToDashboardView];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                /*
                 * 用户行为记录, 单独异常处理，不可影响用户体验
                 */
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName] = @"登录";
                [APIHelper actionLog:logParams];
            });

        });
        return;
    });

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[kActionALCName] = @"登录";
        [APIHelper actionLog:logParams];
    });
   

}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)saveUserDict:(NSString *)jsonString{
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    NSDictionary *dict = [self dictionaryWithJsonString:jsonString][@"data"];
    userDict[kDeviceUUIDCUName] = SafeText(dict[@"device_uuid"]);
    if (dict[@"user_device_id"] !=nil) {
         userDict[kUserDeviceIDCUName] = dict[@"user_device_id"];
    }
    if (dict[@"device_state"] !=nil) {
         userDict[kDeviceStateCUName] = dict[@"device_state"];
    }
    
    NSString *settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kSettingConfigFileName];
    [userDict writeToFile:userConfigPath atomically:YES];
    [userDict writeToFile:settingsConfigPath atomically:YES];
}

-(void)saveUserStoreDict:(NSString*)jsonString {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    NSDictionary *dict = [self dictionaryWithJsonString:jsonString];
    if (dict[@"data"] != nil) {
         userDict[kStoreIDsCUName] = dict[@"data"];
    }
    
    NSString *settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kSettingConfigFileName];
    [userDict writeToFile:userConfigPath atomically:YES];
    [userDict writeToFile:settingsConfigPath atomically:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//跳转到仪表盘页面
- (void)jumpToDashboardView {
    UIWindow *window = self.view.window;
    LoginViewController *previousRootViewController = (LoginViewController *)window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // DashboardViewController *dashboardViewController = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    //dashboardViewController.fromViewController = @"LoginViewController";
    MainTabbarViewController *mainTabbar = [MainTabbarViewController instance];
    window.rootViewController = mainTabbar;
    // Nasty hack to fix http://stackoverflow.com/questions/26763020/leaking-views-when-changing-rootviewcontroller-inside-transitionwithview
    // The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
    for (UIView *subview in window.subviews) {
        if ([subview isKindOfClass:self.class]) {
            [subview removeFromSuperview];
        }
    }
    // Allow the view controller to be deallocated
    [previousRootViewController dismissViewControllerAnimated:NO completion:^{
        // Remove the root view in case its still showing
        [previousRootViewController.view removeFromSuperview];
    }];
}

- (void)showProgressHUD:(NSString *)text {
    [self showProgressHUD:text mode:MBProgressHUDModeIndeterminate];
}

- (void)showProgressHUD:(NSString *)text mode:(MBProgressHUDMode)mode {
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progressHUD.labelText = text;
    self.progressHUD.mode = mode;
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

#pragma mark - 缓存当前应用版本，每次检测，不一致时，有所动作
- (void)checkVersionUpgrade:(NSString *)assetsPath {
    NSDictionary *bundleInfo       =[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion       = bundleInfo[@"CFBundleShortVersionString"];
    NSString *versionConfigPath    = [NSString stringWithFormat:@"%@/%@", assetsPath, kCurrentVersionFileName];
    
    BOOL isUpgrade = YES;
    NSString *localVersion = @"no-exist";
    if([FileUtils checkFileExist:versionConfigPath isDir:NO]) {
        localVersion = [NSString stringWithContentsOfFile:versionConfigPath encoding:NSUTF8StringEncoding error:nil];
        
        if(localVersion && [localVersion isEqualToString:currentVersion]) {
            isUpgrade = NO;
        }
    }
    
    if(isUpgrade) {
        NSLog(@"version modified: %@ => %@", localVersion, currentVersion);
        NSString *cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", assetsPath, kCachedDirName];
        [FileUtils removeFile:cachedHeaderPath];
        NSLog(@"remove header: %@", cachedHeaderPath);
        
        [currentVersion writeToFile:versionConfigPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        // 消息推送，重新上传服务器
        NSString *pushConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kPushConfigFileName];
        NSMutableDictionary *pushDict = [FileUtils readConfigFile:pushConfigPath];
        pushDict[@"push_valid"] = @(NO);
        [pushDict writeToFile:pushConfigPath atomically:YES];
    }
}



# pragma mark - 登录界面不支持旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
