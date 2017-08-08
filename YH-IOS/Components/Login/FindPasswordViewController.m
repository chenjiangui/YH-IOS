//
//  FindPasswordViewController.m
//  YH-IOS
//
//  Created by li hao on 17/1/13.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "NewFindPasswordCell.h"
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
@interface FindPasswordViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *FindPwdTableview;
    NSString * PeopleString;
    NSString * PhoneString;
    UIButton *upDataBtn;
}
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) Version *version;
@property (nonatomic, strong) UIWebView *webView;
@property WebViewJavascriptBridge* bridge;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSString *assetsPath;

@end

@implementation FindPasswordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [[User alloc] init];
    if(self.user.userID) {
        self.assetsPath = [FileUtils dirPath:kHTMLDirName];
    }
    else{
        self.assetsPath = [FileUtils sharedPath];
    }
    self.title = @"找回密码";
    [self.view setBackgroundColor:[NewAppColor yhapp_8color]];
    [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]},@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[NewAppColor yhapp_6color]}] ;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    UIImage *imageback = [[UIImage imageNamed:@"newnav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn addSubview:bakImage];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
    [self setTableView];
    

    

    
//    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-60)];
//    self.webView.delegate = self;
//    [self.view addSubview:self.webView];
//     self.edgesForExtendedLayout = UIRectEdgeNone;
//    [WebViewJavascriptBridge enableLogging];
//    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"ResetPasswordViewController - ObjC received message from JS: %@", data);
//        responseCallback(@"ResetPasswordViewController - Response for message from ObjC");
//    }];
//    
//    [self.bridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
//        
//        /*
//         * 用户行为记录, 单独异常处理，不可影响用户体验
//         */
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            @try {
//                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
//                logParams[@"action"] = @"JS异常";
//                logParams[@"obj_title"] = [NSString stringWithFormat:@"重置密码页面/%@", data[@"ex"]];
//                [APIHelper actionLog:logParams];
//            }
//            @catch (NSException *exception) {
//                NSLog(@"%@", exception);
//            }
//        });
//    }];

    
//    [self.bridge registerHandler:@"ForgetPassword" handler:^(id data, WVJBResponseCallback responseCallback){
//        
//        NSString *userNum = data[@"usernum"];
//        NSString *userPhone = data[@"mobile"];
//        NSLog(@"%@%@",userNum,userPhone);
//        
//        if (userNum && userPhone) {
//            HttpResponse *reponse =  [APIHelper findPassword:userNum withMobile:userPhone];
//            NSString *message = [NSString stringWithFormat:@"%@",reponse.data[@"info"]];
//            SCLAlertView *alert = [[SCLAlertView alloc] init];
//            if ([reponse.statusCode isEqualToNumber:@(201)]) {
//                [alert addButton:@"重新登录" actionBlock:^(void){
//                    [self dismissFindPwd];
//                }];
//                
//                [alert showSuccess:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    /*
//                     * 用户行为记录, 单独异常处理，不可影响用户体验
//                     */
//                    @try {
//                        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
//                        logParams[@"action"] = @"找回密码";
//                        [APIHelper actionLog:logParams];
//                    }
//                    @catch (NSException *exception) {
//                        NSLog(@"%@", exception);
//                    }
//                });
//                
//            }
//            else {
//                // [self changLocalPwd:newPassword];
//                [alert addButton:@"好的" actionBlock:^(void) {
//                    [self dismissViewControllerAnimated:YES completion:^{
//                        self.webView.delegate = nil;
//                        self.webView = nil;
//                        self.bridge = nil;
//                    }];
//                }];
//                [alert showWarning:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
//            }
//        }
//    }];
}
-(void)setTableView
{
    FindPwdTableview=[[UITableView alloc] init];
    [self.view addSubview:FindPwdTableview];
    FindPwdTableview.scrollEnabled =NO; //设置tableview 不能滚动
    [FindPwdTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height));
    }];
    [FindPwdTableview setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"]];
    //    GroupTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    FindPwdTableview.dataSource = self;
    FindPwdTableview.delegate = self;
}
#pragma  get GroupArray count  to set number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        return 64;
    }
    else
         return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return self.view.frame.size.height-210;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        static NSString *Identifier = @"Cell";
        NewFindPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell=[[NewFindPasswordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier andType:@"PeopleNumber"];
        }
        FindPwdTableview.separatorColor = [UIColor colorWithHexString:@"#e6e6e6"];
                //设置 分割线长度
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row==1)
    {
        static NSString *Identifier = @"Cell2";
        NewFindPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
          
            cell=[[NewFindPasswordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier andType:@"PhoneNumber"];
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row==2)
    {
        static NSString *Identifier = @"Cell3";
        NewFindPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {

            cell=[[NewFindPasswordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier andType:@"textLabel"];
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString *Identifier = @"Cell4";
        NewFindPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell=[[NewFindPasswordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier andType:@"upDataBtn"];
        }
        return cell;
    }
}
- (void)backAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self _loadHtml];
}
#pragma mark - assistant methods
- (void)loadHtml {
    DeviceState deviceState = [APIHelper deviceState];
    if(deviceState == StateOK) {
        [self _loadHtml];
    }
    else if(deviceState == StateForbid) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:@"知道了" actionBlock:^(void) {
            [self dismissFindPwd];
        }];
        [alert showError:self title:@"温馨提示" subTitle:@"您被禁止在该设备使用本应用" closeButtonTitle:nil duration:0.0f];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading:LoadingRefresh];
        });
    }
}
- (void)showLoading:(LoadingType)loadingType {
    NSString *loadingPath = [FileUtils loadingPath:loadingType];
    NSString *loadingContent = [NSString stringWithContentsOfFile:loadingPath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:loadingContent baseURL:[NSURL fileURLWithPath:loadingPath]];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}
- (void)_loadHtml {
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlstring = [NSString stringWithFormat:@"%@/mobile/v2/forget_user_password",kBaseUrl];
        HttpResponse *httpResponse = [HttpUtils checkResponseHeader:urlstring assetsPath:self.assetsPath];
        __block NSString *htmlPath;
        if([httpResponse.statusCode isEqualToNumber:@(200)]) {
            htmlPath = [HttpUtils urlConvertToLocal:urlstring content:httpResponse.string assetsPath:self.assetsPath writeToLocal:kIsUrlWrite2Local];
        }
        else {
            NSString *htmlName = [HttpUtils urlTofilename:urlstring suffix:@".html"][0];
            htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            NSString *htmlContent = [FileUtils loadLocalAssetsWithPath:htmlPath];
            [self.webView loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:[FileUtils sharedPath]]];
        });
    });
}
- (void)clearBrowserCache {
    [self.webView stopLoading];
    }
- (void)dismissFindPwd {
    [self dismissViewControllerAnimated:YES completion:^{
        self.webView.delegate = nil;
        self.webView = nil;
        self.bridge = nil;
    }];
}

@end
