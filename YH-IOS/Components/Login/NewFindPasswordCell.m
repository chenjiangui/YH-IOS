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
                    PeopleNumber.textColor=[NewAppColor yhapp_3color];
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
                        PhoneNumber.placeholder=@"手机号";
                        PhoneNumber.font=[UIFont systemFontOfSize:16];
                        PhoneNumber.textAlignment=NSTextAlignmentLeft;
                        PhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
                        [PhoneNumber addTarget:self action:@selector(PhoneNumberDidChange:) forControlEvents:UIControlEventEditingChanged];
                        PhoneNumber.textColor=[NewAppColor yhapp_3color];
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
                            make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width, 50));
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
//延时执行函数
-(void)delayMethod
{
    self.contentView.userInteractionEnabled=YES;
    [HudToolView hideLoadingInView:self.window];
    
}
-(void)upTodata
{
    self.contentView.userInteractionEnabled=NO;
    
    [HudToolView showLoadingInView:self.window];
    
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];

         NSString *userNum = PeopleString;
         NSString *userPhone = PhoneString;
         NSLog(@"%@%@",userNum,userPhone);
            if (userNum && userPhone) {
                HttpResponse *reponse =  [APIHelper findPassword:userNum withMobile:userPhone];
                NSString *message = [NSString stringWithFormat:@"%@",reponse.data[@"info"]];
                if ([reponse.statusCode isEqualToNumber:@(201)]) {
                    [HudToolView showTopWithText:message color:[NewAppColor yhapp_1color]];
                    [[self viewController] dismissViewControllerAnimated:YES completion:nil];
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
                    [HudToolView showTopWithText:message color:[NewAppColor yhapp_11color]];
                }
            }
            else
            {
                [HudToolView showTopWithText:@"信息有误，请重新输入" color:[NewAppColor yhapp_11color]];
            }
}


- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
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
