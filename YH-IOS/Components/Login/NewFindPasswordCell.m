//
//  NewFindPasswordCell.m
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/7/29.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NewFindPasswordCell.h"

@implementation NewFindPasswordCell

static  NSString *PeopleString;
static  NSString *PhoneString;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSString *)type
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
      if([type isEqualToString:@"PeopleNumber"])
      {
                    UITextField *PeopleNumber =[[UITextField alloc] init];
                    [self.contentView addSubview:PeopleNumber];
                    PeopleNumber.placeholder=@"员工号";
                    PeopleNumber.font=[UIFont systemFontOfSize:16];
                    PeopleNumber.textAlignment=NSTextAlignmentLeft;
                    PeopleNumber.textColor=[UIColor colorWithHexString:@"#bcbcbc"];
                    [PeopleNumber addTarget:self action:@selector(PeopleNumberDidChange:) forControlEvents:UIControlEventEditingChanged];
                    [PeopleNumber mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
                        make.centerY.mas_equalTo(self.contentView.mas_centerY);
                        make.size.mas_equalTo(CGSizeMake(self.contentView.frame.size.width, 50));
                    }];
      }
                else if([type isEqualToString:@"PhoneNumber"])
                    {
                        UITextField *PhoneNumber =[[UITextField alloc] init];
                        [self.contentView addSubview:PhoneNumber];
                        PhoneNumber.font=[UIFont systemFontOfSize:16];
                        PhoneNumber.textAlignment=NSTextAlignmentLeft;
                        [PhoneNumber addTarget:self action:@selector(PhoneNumberDidChange:) forControlEvents:UIControlEventEditingChanged];
                        PhoneNumber.textColor=[UIColor colorWithHexString:@"#666666"];
                        [PhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
                            make.centerY.mas_equalTo(self.contentView.mas_centerY);
                            make.size.mas_equalTo(CGSizeMake(self.contentView.frame.size.width, 50));
                        }];
        
                    }
                else if([type isEqualToString:@"textLabel"])
                {
                    UILabel *textLabel=[[UILabel alloc] init];
                    [self.contentView addSubview:textLabel];
                    NSString *str=@"如遇到手机号不匹配，请至OA办公系统-个人信息-我的信息中修改手机号，隔天生效";
                    textLabel.numberOfLines=2;
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    [paragraphStyle setLineSpacing:8];
                    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
                    textLabel.attributedText = attributedString;
                    textLabel.textColor=[UIColor colorWithHexString:@"bcbcbc"];
                    textLabel.textAlignment=NSTextAlignmentLeft;
                    textLabel.font=[UIFont systemFontOfSize:13];
                    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.contentView.mas_bottom).offset(-16);
                        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
                        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
                        make.centerY.mas_equalTo(self.mas_centerY);
                        make.size.mas_equalTo(CGSizeMake(self.contentView.size.width, 60));
                    }];
                    [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"]];
        
                }
               else if([type isEqualToString:@"upDataBtn"])
                    {
                      UIButton  *upDataBtn=[[UIButton alloc]init];
                        [upDataBtn setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];
                        [upDataBtn setBackgroundColor:[UIColor greenColor] forState:UIControlStateSelected];
                        [upDataBtn setBackgroundColor:[UIColor greenColor] forState:UIControlStateHighlighted];
                        [upDataBtn setTitle:@"提交" forState:UIControlStateNormal];
                        upDataBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
                        [upDataBtn addTarget:self action:@selector(upTodata) forControlEvents:UIControlEventTouchUpInside];
                        [upDataBtn setTitleColor:[UIColor colorWithHexString:@"#00a4e9"] forState:UIControlStateNormal];
                        [upDataBtn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                        [upDataBtn setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"]  forState:UIControlStateSelected];
                        [upDataBtn setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"] forState:UIControlStateHighlighted];
                        [self.contentView addSubview:upDataBtn];
                        [upDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.mas_equalTo(self.contentView.mas_centerX);
                            make.centerY.mas_equalTo(self.contentView.mas_centerY);
                            make.size.mas_equalTo(CGSizeMake(self.contentView.frame.size.width, 50));
                        }];
                    }
    }
    return self;
}
-(void)PeopleNumberDidChange:(UITextField*)PeopleNumber
{
    PeopleString=PeopleNumber.text;
}
-(void)PhoneNumberDidChange:(UITextField*)PhoneNumber
{
    PhoneString=PhoneNumber.text;
}
//-(void)upTodata
//{
//    NSString *userNum = PeopleString;
//    NSString *userPhone = PhoneString;
//    NSLog(@"%@%@",userNum,userPhone);
//    if (userNum && userPhone) {
//        HttpResponse *reponse =  [APIHelper findPassword:userNum withMobile:userPhone];
//        NSString *message = [NSString stringWithFormat:@"%@",reponse.data[@"info"]];
//        SCLAlertView *alert = [[SCLAlertView alloc] init];
//        if ([reponse.statusCode isEqualToNumber:@(201)]) {
//            [alert addButton:@"重新登录" actionBlock:^(void){
////                [self dismissFindPwd];
//            }];
//                                [alert showSuccess:self.contentView title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
//      
//            [RMessage showNotificationInViewController:self.contentView
//                                                 title:@"提交成功"
//                                              subtitle:nil
//                                             iconImage:nil
//                                                  type:RMessageTypeSuccess
//                                        customTypeName:nil
//                                              duration:RMessageDurationAutomatic
//                                              callback:nil
//                                           buttonTitle:nil
//                                        buttonCallback:nil
//                                            atPosition:RMessagePositionNavBarOverlay
//                                  canBeDismissedByUser:YES];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                /*
//                 * 用户行为记录, 单独异常处理，不可影响用户体验
//                 */
//                @try {
//                    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
//                    logParams[@"action"] = @"找回密码";
//                    [APIHelper actionLog:logParams];
//                }
//                @catch (NSException *exception) {
//                    NSLog(@"%@", exception);
//                }
//            });
//            
//        }
//        else {
//            // [self changLocalPwd:newPassword];
//            [alert addButton:@"好的" actionBlock:^(void) {
////                [self dismissViewControllerAnimated:YES completion:^{
////                    self.webView.delegate = nil;
////                    self.webView = nil;
////                    self.bridge = nil;
////                }];
//            }];
////            [alert showWarning:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
//        }
//    }
//}


-(void)upTodata
{
          NSString *userNum = PeopleString;
          NSString *userPhone = PhoneString;
         NSLog(@"%@%@",userNum,userPhone);
            if (userNum && userPhone) {
                HttpResponse *reponse =  [APIHelper findPassword:userNum withMobile:userPhone];
                NSString *message = [NSString stringWithFormat:@"%@",reponse.data[@"info"]];
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                if ([reponse.statusCode isEqualToNumber:@(201)]) {
                    [alert addButton:@"重新登录" actionBlock:^(void){
//                        [self dismissFindPwd];
                    }];
//                    [alert showSuccess:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
//                    if (self.navigationController.navigationBarHidden) {
//                        [self.navigationController setNavigationBarHidden:NO];
//                    }
                    
                    
                    [RMessage showNotificationInViewController:self.viewController
                                                         title:message
                                                      subtitle:nil
                                                     iconImage:nil
                                                          type:RMessageTypeSuccess
                                                customTypeName:nil
                                                      duration:RMessageDurationAutomatic
                                                      callback:nil
                                                   buttonTitle:nil
                                                buttonCallback:nil
                                                    atPosition:RMessagePositionNavBarOverlay
                                          canBeDismissedByUser:YES];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        /*
                         * 用户行为记录, 单独异常处理，不可影响用户体验
                         */
                        @try {
                            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                            logParams[@"action"] = @"找回密码";
                            [APIHelper actionLog:logParams];
                        }
                        @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        }
                    });

                }
                else {
                    // [self changLocalPwd:newPassword];
//                    [alert addButton:@"好的" actionBlock:^(void) {
//                        [self dismissViewControllerAnimated:YES completion:^{
//                            self.webView.delegate = nil;
//                            self.webView = nil;
//                            self.bridge = nil;
//                        }];
//                    }];
//                    [alert showWarning:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
                    
                    
                    [RMessage showNotificationInViewController:self.viewController
                                                         title:message
                                                      subtitle:nil
                                                     iconImage:nil
                                                          type:RMessageTypeSuccess
                                                customTypeName:nil
                                                      duration:RMessageDurationAutomatic
                                                      callback:nil
                                                   buttonTitle:nil
                                                buttonCallback:nil
                                                    atPosition:RMessagePositionNavBarOverlay
                                          canBeDismissedByUser:YES];

                    
                    
                }
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
