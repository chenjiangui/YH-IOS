//
//  NewMineResetPwdController.m
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/7/26.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NewMineResetPwdController.h"
#import "User.h"
#import "APIHelper.h"
#import "HttpResponse.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "FileUtils.h"
#import "LoginViewController.h"
#import "NewMinepResetPwdCell.h"
@interface NewMineResetPwdController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *ResetPwdTableView;
    UIButton *saveBtn;
    UITextField *NewPwdNumber;
    UITextField *RequestPwdNumber;
    UIButton *NewPwdON;
    UIButton *RequestON;
    User *user;
}

@property (nonatomic,copy) NSString *oldPwdString;
@property (nonatomic,copy) NSString *NewPwdString;
@property (nonatomic,copy) NSString *RequstPwdString;

@end

@implementation NewMineResetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [[User alloc]init];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController setNavigationBarHidden:false];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[NewAppColor yhapp_6color]}] ;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    
    UIImage *imageback = [[UIImage imageNamed:@"newnav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    bakImage.image = imageback;
    
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(NewPwdViewBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn addSubview:bakImage];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
    [self setTableView];
}
-(void)setTableView
{
    ResetPwdTableView=[[UITableView alloc] init];
    [self.view addSubview:ResetPwdTableView];
    ResetPwdTableView.scrollEnabled =NO; //设置tableview 不能滚动
    [ResetPwdTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height));
    }];
    [ResetPwdTableView setBackgroundColor:[NewAppColor yhapp_8color]];
    ResetPwdTableView.dataSource = self;
    ResetPwdTableView.delegate = self;
}

#pragma  get GroupArray count  to set number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else{
        return 4;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1 && indexPath.row==2) {
        return 45;
    }
    else
        return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    else
        return self.view.frame.size.height-265;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString *Identifier = @"oldPwdCell";
        NewMinepResetPwdCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[NewMinepResetPwdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell=[[NewMinepResetPwdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier andType:@"OldPwdNumber"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section==1 && indexPath.row==0)
    {
        static NSString *Identifier = @"newPwdCell";
        
        NewMinepResetPwdCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[NewMinepResetPwdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell=[[NewMinepResetPwdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier andType:@"NewPwdNumber"];
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section==1 && indexPath.row==1)
    {
        static NSString *Identifier = @"RequestPwdCell";
        NewMinepResetPwdCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[NewMinepResetPwdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell=[[NewMinepResetPwdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier andType:@"RequestPwdNumber"];
        }
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section==1 && indexPath.row==2)
    {
        static NSString *Identifier = @"LabelCell";
        NewMinepResetPwdCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[NewMinepResetPwdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell=[[NewMinepResetPwdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier andType:@"textLabel"];
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *Identifier = @"saveCell";
        NewMinepResetPwdCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[NewMinepResetPwdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell=[[NewMinepResetPwdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier andType:@"saveBtn"];
        }
        return cell;
    }
}
//old way
//-(void)saveBtn
//{
//    if (![_oldPwdString.md5 isEqualToString:user.password]) {
//        [ViewUtils showPopupView:self.view Info:@"密码输入错误"];
//        return;
//    }
//    if (![_NewPwdString isEqualToString:_RequstPwdString]) {
//        [ViewUtils showPopupView:self.view Info:@"新密码输入不一致"];
//        return;
//    }
//    if ([self checkIsHaveNumAndLetter:_NewPwdString]!=3 || [_NewPwdString length] <6 ) {
//        [ViewUtils showPopupView:self.view Info:@"密码需为6位以上，数字和字母的组合"];
//        return;
//    }
//    if([_oldPwdString.md5 isEqualToString:user.password]) {
//        
//        HttpResponse *response = [APIHelper resetPassword:user.userID newPassword:_NewPwdString.md5];
//        NSString *message = [NSString stringWithFormat:@"%@", response.data[@"info"]];
//        
//        SCLAlertView *alert = [[SCLAlertView alloc] init];
//        if(response.statusCode && [response.statusCode isEqualToNumber:@(201)]) {
//            [self changLocalPwd:_NewPwdString];
//            [alert addButton:@"重新登录" actionBlock:^(void) {
//                [self jumpToLogin];
//            }];
//            
//            [alert showSuccess:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                /*
//                 * 用户行为记录, 单独异常处理，不可影响用户体验
//                 */
//                @try {
//                    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
//                    logParams[@"action"] = @"点击/密码修改";
//                    [APIHelper actionLog:logParams];
//                }
//                @catch (NSException *exception) {
//                    NSLog(@"%@", exception);
//                }
//            });
//        }
//        else {
////            [self changLocalPwd:newPassword];
//            [alert addButton:@"好的" actionBlock:^(void) {
//                [self dismissViewControllerAnimated:YES completion:^{
//                }];
//            }];
//            [alert showWarning:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
//        }
//    }
//    else {
//        [ViewUtils showPopupView:self.view Info:@"原始密码输入有误"];
//    }
//    
//}
-(void)NewPwdViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
    [super didReceiveMemoryWarning];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
