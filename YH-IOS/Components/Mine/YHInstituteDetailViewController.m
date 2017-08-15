//
//  YHInstituteDetailViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/30.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHInstituteDetailViewController.h"
#import "SDWebView.h"

@interface YHInstituteDetailViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic,strong)SDWebView *webView;

@end

@implementation YHInstituteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"数据学院";
    NSString *kpiString = [NSString stringWithFormat:@"%@/mobile/v2/user/%@/article/%@",kBaseUrl,self.userId,self.dataId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kpiString]];
    self.webView = [[SDWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.webView.webDelegate = self;
    [_webView loadRequest:request];

    [self.view addSubview:_webView];
  
}


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [HudToolView hideLoadingInView:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [HudToolView showLoadingInView:self.view];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 84, 40)];
    UIImage *imageback = [[UIImage imageNamed:@"list_ic_arroow.png-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
}
-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [HudToolView hideLoadingInView:self.view];
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
