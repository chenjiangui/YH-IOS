//
//  NewMinepResetPwdCell.m
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/7/30.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NewMinepResetPwdCell.h"

@implementation NewMinepResetPwdCell

static  NSString *oldPwdString;
static  NSString *NewPwdString;
static  NSString *RequstPwdString;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSString*)type
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self)
    {
        if ([type isEqualToString:@"OldPwdNumber"])
        {
            UITextField *OldPwdNumber =[[UITextField alloc] init];
            [self.contentView addSubview:OldPwdNumber];
            OldPwdNumber.placeholder=@"旧密码";
            [OldPwdNumber setSecureTextEntry:YES];
            OldPwdNumber.font=[UIFont systemFontOfSize:16];
            OldPwdNumber.textAlignment=NSTextAlignmentLeft;
            OldPwdNumber.textColor=[NewAppColor yhapp_3color];
            [OldPwdNumber addTarget:self action:@selector(OldPwdDidChange:) forControlEvents:UIControlEventEditingChanged];
            [OldPwdNumber mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView.mas_left).offset(20);
                make.size.mas_equalTo(CGSizeMake(self.contentView.frame.size.width, 50));
            }];
        }
        else if ([type isEqualToString:@"NewPwdNumber"] )
        {
            NewPwdNumber =[[UITextField alloc] init];
            [self.contentView  addSubview:NewPwdNumber];
            NewPwdNumber.placeholder=@"新密码";
            NewPwdNumber.font=[UIFont systemFontOfSize:16];
            NewPwdNumber.textAlignment=NSTextAlignmentLeft;
            [NewPwdNumber setSecureTextEntry:YES];
            NewPwdNumber.textColor=[NewAppColor yhapp_3color];
            [NewPwdNumber addTarget:self action:@selector(NewPwdDidChange:) forControlEvents:UIControlEventEditingChanged];
            [NewPwdNumber mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView.mas_left).offset(20);
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width-44, 50));
            }];
            NewPwdON=[UIButton buttonWithType:UIButtonTypeCustom];
            NewPwdON.tag=100;
            [self.contentView addSubview:NewPwdON];
            [NewPwdON setBackgroundImage:[UIImage imageNamed:@"look-on"] forState:UIControlStateNormal];
            [NewPwdON addTarget:self action:@selector(newPwdOnOrOffBtn:) forControlEvents:UIControlEventTouchUpInside];
            [NewPwdON mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-28);
                make.size.mas_equalTo(CGSizeMake(16, 16));
            }];
        }
        else if ([type isEqualToString:@"RequestPwdNumber"] )
        {
            RequestPwdNumber =[[UITextField alloc] init];
            [self.contentView addSubview:RequestPwdNumber];
            RequestPwdNumber.placeholder=@"确认密码";
            RequestPwdNumber.font=[UIFont systemFontOfSize:16];
            [RequestPwdNumber setSecureTextEntry:YES];
            RequestPwdNumber.textAlignment=NSTextAlignmentLeft;
            RequestPwdNumber.textColor=[NewAppColor yhapp_3color];
            [RequestPwdNumber addTarget:self action:@selector(RequestPwdDidChange:) forControlEvents:UIControlEventEditingChanged];
            [RequestPwdNumber mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView.mas_left).offset(20);
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width-44, 50));
            }];
            RequestON=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.contentView addSubview:RequestON];
            RequestON.tag=200;
            [RequestON setBackgroundColor:[UIColor blueColor] forState:UIControlStateNormal];
            [RequestON setBackgroundImage:[UIImage imageNamed:@"look-on"] forState:UIControlStateNormal];
            [RequestON addTarget:self action:@selector(RequestOnOrOffBtn:) forControlEvents:UIControlEventTouchUpInside];
            [RequestON mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-28);
                make.size.mas_equalTo(CGSizeMake(16, 16));
            }];
        }
        else if ([type isEqualToString:@"textLabel"] )
        {
            UILabel *textLabel=[[UILabel alloc] init];
            [self.contentView addSubview:textLabel];
            textLabel.text=@"密码需为6位以上，数字和字母的组合";
            textLabel.textColor=[NewAppColor yhapp_4color];
            textLabel.textAlignment=NSTextAlignmentLeft;
            textLabel.font=[UIFont systemFontOfSize:13];
            [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView.mas_left).offset(20);
                make.centerY.mas_equalTo(self.mas_centerY);
            }];
            [self.contentView setBackgroundColor:[NewAppColor yhapp_8color]];
        }
        else
        {
            saveBtn=[[UIButton alloc]init];
            [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
            saveBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
            saveBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
            [saveBtn addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
            [saveBtn setTitleColor:[NewAppColor yhapp_1color]forState:UIControlStateNormal];
            [saveBtn setBackgroundColor:[NewAppColor yhapp_10color] forState:UIControlStateNormal];
            [saveBtn setBackgroundColor:[NewAppColor yhapp_8color]  forState:UIControlStateSelected];
            [saveBtn setBackgroundColor:[NewAppColor yhapp_8color] forState:UIControlStateHighlighted];
            [self.contentView addSubview:saveBtn];
            [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerX.mas_equalTo(self.contentView.mas_centerX);
//                                make.centerY.mas_equalTo(cell.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
            }];
        }

    }
    return self;
}

-(void)newPwdOnOrOffBtn:(UIButton *)newBtn
{
    if (newBtn.tag==100) {
        [NewPwdON setBackgroundImage:[UIImage imageNamed:@"look-off"] forState:UIControlStateNormal];
        NewPwdON.tag=101;
        [NewPwdNumber setSecureTextEntry:NO];
    }
    else
    {
        [NewPwdON setBackgroundImage:[UIImage imageNamed:@"look-on"] forState:UIControlStateNormal];
        NewPwdON.tag=100;
        [NewPwdNumber setSecureTextEntry:YES];
    }
}
-(void)RequestOnOrOffBtn:(UIButton *)RequestPwdBtn
{
    if (RequestPwdBtn.tag==200) {
        [RequestON setBackgroundImage:[UIImage imageNamed:@"look-off"] forState:UIControlStateNormal];
        RequestON.tag=201;
        [RequestPwdNumber setSecureTextEntry:NO];
    }
    else
    {
        [RequestON setBackgroundImage:[UIImage imageNamed:@"look-on"] forState:UIControlStateNormal];
        RequestON.tag=200;
        [RequestPwdNumber setSecureTextEntry:YES];
    }
}
-(void)OldPwdDidChange:(UITextField*)OldPwdNumber
{
    oldPwdString=OldPwdNumber.text;
}
-(void)NewPwdDidChange:(UITextField*)NewPwdTextField
{
    NewPwdString=NewPwdTextField.text;
}
-(void)RequestPwdDidChange:(UITextField*)RequestTextField
{
    RequstPwdString=RequestTextField.text;
}

//延时执行函数
-(void)delayMethod
{
    self.contentView.userInteractionEnabled=YES;
    [HudToolView hideLoadingInView:self.window];
    
}

-(void)saveBtn
{
    self.contentView.userInteractionEnabled=NO;
    
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];

    
    user = [[User alloc]init];
    NSLog(@"%@",user);
    if (![oldPwdString.md5 isEqualToString:SafeText(user.password)]) {
        [HudToolView showTopWithText:@"原密码输入错误" color:[NewAppColor yhapp_11color]];
        return;
    }
    if (![NewPwdString isEqualToString:RequstPwdString]) {
        [HudToolView showTopWithText:@"新密码 输入不一致" color:[NewAppColor yhapp_11color]];
        return;
    }
    if ([self checkIsHaveNumAndLetter:NewPwdString]!=3 || [NewPwdString length] <6 ) {
        [HudToolView showTopWithText:@"密码需为6位以上，数字和字母的组合" color:[NewAppColor yhapp_11color]];
        return;
    }
    [HudToolView showLoadingInView:self.window];

    if([oldPwdString.md5 isEqualToString:SafeText(user.password)]) {
        HttpResponse *response = [APIHelper resetPassword: SafeText(user.userNum) newPassword:NewPwdString.md5];
        NSString *message = [NSString stringWithFormat:@"%@", response.data[@"message"]];
        if(response.statusCode && [response.statusCode isEqualToNumber:@(201)]) {
            [self changLocalPwd:NewPwdString];
            [self jumpToLogin];
             [HudToolView showTopWithText:message color:[NewAppColor yhapp_1color]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                /*
                 * 用户行为记录, 单独异常处理，不可影响用户体验
                 */
                @try {
                    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                    logParams[@"action"] = @"点击/密码修改";
                    [APIHelper actionLog:logParams];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }
            });
        }
        else {
             [self changLocalPwd:NewPwdString];
            [HudToolView showTopWithText:message color:[NewAppColor yhapp_11color]];
        }
    }
    else {
        [HudToolView showTopWithText:@"原始密码输入有误" color:[NewAppColor yhapp_11color]];
    }
}
- (void)jumpToLogin {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[kIsLoginCUName] = @(NO);
    [userDict writeToFile:userConfigPath atomically:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kMainSBName bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:kLoginVCName];
   //暂定
    self.contentView.window.rootViewController = loginViewController;
}
- (void)changLocalPwd:(NSString *)newPassword {
    NSString  *noticeFilePath = [FileUtils dirPath:@"Cached" FileName:@"local_notifition.json"];
    NSMutableDictionary *noticeDict = [FileUtils readConfigFile:noticeFilePath];
    noticeDict[@"setting_password"] = @(-1);
    noticeDict[@"setting"] = @(0);
    [FileUtils writeJSON:noticeDict Into:noticeFilePath];
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[@"user_md5"] = newPassword.md5;
    [FileUtils writeJSON:userDict Into:userConfigPath];
}
//直接调用这个方法就行
-(int)checkIsHaveNumAndLetter:(NSString*)password{
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password
                                                                       options:NSMatchingReportProgress
                                                                         range:NSMakeRange(0, password.length)];
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    //符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    if (tNumMatchCount == password.length) {
        //全部符合数字，表示沒有英文
        return 1;
    } else if (tLetterMatchCount == password.length) {
        //全部符合英文，表示沒有数字
        return 2;
    } else if (tNumMatchCount + tLetterMatchCount == password.length) {
        //符合英文和符合数字条件的相加等于密码长度
        return 3;
    } else {
        return 4;
        //可能包含标点符号的情況，或是包含非英文的文字，这里再依照需求详细判断想呈现的错误
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
@end
