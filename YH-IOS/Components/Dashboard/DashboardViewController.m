//
//  DashboardViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "DashboardViewController.h"
#import "FileUtils.h"
#import "HttpUtils.h"
#import "const.h"
#import <MBProgressHUD.h>
#import "WebViewJavascriptBridge.h"
#import "ChartViewController.h"
#import "HttpResponse.h"
#import <SCLAlertView.h>


static NSString *const kChartSegueIdentifier = @"DashboardToChartSegueIdentifier";

@interface DashboardViewController ()
@property WebViewJavascriptBridge* bridge;
@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (strong, nonatomic) NSString *dashboardUrlString;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.assetsPath = [FileUtils dirPath:HTML_DIRNAME];
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"iosCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *bannerName = data[@"bannerName"];
        NSString *link       = data[@"link"];
        [self performSegueWithIdentifier:kChartSegueIdentifier sender:@{@"bannerName": bannerName, @"link": link}];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];

    self.dashboardUrlString = [NSString stringWithFormat:@"%@%@", BASE_URL, KPI_PATH];
    [self loadHtml];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self showProgressHUD:@"收到IOS系统，内存警告."];
    self.progressHUD.mode = MBProgressHUDModeText;
    [_progressHUD hide:YES afterDelay:2.0];
}

- (void)dealloc {
    _browser.delegate = nil;
    _browser = nil;
    [_progressHUD hide:YES];
    _progressHUD = nil;
    _bridge = nil;
}

#pragma mark - status bar settings
-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - assistant methods
- (void)loadHtml {
    NSString *htmlName = [HttpUtils urlTofilename:self.dashboardUrlString suffix:@".html"][0];
    NSString *htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];

    
    if([FileUtils checkFileExist:htmlPath isDir:NO]) {
        NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([HttpUtils isNetworkAvailable]) {
            HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.dashboardUrlString assetsPath:self.assetsPath];
            if([httpResponse.statusCode isEqualToNumber:@(200)]) {
                
                [self showProgressHUD:@"loading..."];
                
                NSString *htmlPath = [HttpUtils urlConvertToLocal:self.dashboardUrlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:[URL_WRITE_LOCAL isEqualToString:@"1"]];
                NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
                [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
                
                [self.progressHUD hide:YES];
            }
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            
            [alert addButton:@"刷新" actionBlock:^(void) {
                [self loadHtml];
            }];
            
            [alert showError:self title:@"温馨提示" subTitle:@"网络环境不稳定" closeButtonTitle:@"先这样" duration:0.0f];
        }
    });
}



- (void)showProgressHUD:(NSString *)text {
    _progressHUD = [MBProgressHUD showHUDAddedTo:_browser animated:YES];
    _progressHUD.labelText = text;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kChartSegueIdentifier]) {
        ChartViewController *chartViewController = (ChartViewController *)segue.destinationViewController;
        chartViewController.bannerName = sender[@"bannerName"];
        chartViewController.link = sender[@"link"];
    }
}

#pragma mark - UITabBar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSString *path = KPI_PATH;
    
    if([item.title isEqualToString:@"KPI"]) {
        path = KPI_PATH;
    }
    else if([item.title isEqualToString:@"分析"]) {
        path = ANALYSE_PATH;
    }
    else if([item.title isEqualToString:@"消息"]) {
        path = MESSAGE_PATH;
    }
    else if([item.title isEqualToString:@"应用"]) {
        path = APPLICATION_PATH;
    }
    

    self.dashboardUrlString = [NSString stringWithFormat:@"%@%@", BASE_URL, path];
    
    [self loadHtml];
}

# pragma mark - 登录界面不支持旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
#pragma mark - 屏幕旋转 刷新页面 
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self loadHtml];
}
@end
