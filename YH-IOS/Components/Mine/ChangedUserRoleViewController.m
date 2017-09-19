//
//  ChangedUserRoleViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/9/18.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "ChangedUserRoleViewController.h"
#import "WebViewJavascriptBridge.h"
#import "APIHelper.h"

@interface ChangedUserRoleViewController ()<UIWebViewDelegate,UINavigationBarDelegate>

@property WebViewJavascriptBridge* bridge;
@property (nonatomic,strong)UIWebView *browser;

@end

@implementation ChangedUserRoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.browser = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_browser];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.browser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    _browser.delegate = self;
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"SubjectViewController - Response for message from ObjC");
    }];
    [WebViewJavascriptBridge enableLogging];
    [self addWebViewJavascriptBridge];
    self.browser.backgroundColor = [UIColor whiteColor];
    [_browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}



- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [HudToolView showLoadingInView:self.view];
    return YES;
}

- (void)addWebViewJavascriptBridge {
    __weak typeof(*&self) weakSelf = self;
    [self.bridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        // [self showLoading:LoadingRefresh];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName]   = @"JS异常",
                logParams[kObjTitleALCName] = [NSString stringWithFormat:@"更改权限页面/%@", data[@"ex"]];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    
    
    [self.bridge registerHandler:@"paste" handler:^(id data, WVJBResponseCallback responseCallback){
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        NSString *boardString = SafeText(board.string);
        if ([boardString isEqualToString:@""]){
            responseCallback(@"暂无数据");
        }
        else{
            responseCallback(boardString);
        }
    }];
    
    [weakSelf.bridge registerHandler:@"closeSubjectView" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf.navigationController popViewControllerAnimated:YES];

    }];
    
    [self.bridge registerHandler:@"toggleShowBanner" handler:^(id data, WVJBResponseCallback responseCallback){
        if ([data[@"state"] isEqualToString:@"show"]) {
            [weakSelf.navigationController.navigationBar setHidden:NO];
            weakSelf.browser.frame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen]bounds].size.height-64);
        }
        else {
            [weakSelf.navigationController.navigationBar setHidden:YES];
        }
    }];
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [HudToolView hideLoadingInView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [HudToolView hideLoadingInView:self.view];
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
