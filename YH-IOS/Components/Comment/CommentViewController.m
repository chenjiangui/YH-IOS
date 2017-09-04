//
//  CommentViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/11.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "CommentViewController.h"
#import "APIHelper.h"

@interface CommentViewController ()<UINavigationBarDelegate,UINavigationControllerDelegate>
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.translucent = NO;
    
    self.title = self.bannerName;
    self.urlString = [NSString stringWithFormat:kCommentMobilePath, kBaseUrl, [FileUtils currentUIVersion], self.objectID, @(self.commentObjectType)];
    
    [WebViewJavascriptBridge enableLogging];
    WeakSelf;
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"Response for message from ObjC");
    }];
 
    [self.bridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName]   = @"JS异常";
                logParams[kObjIDALCName]    = weakSelf.objectID;
                logParams[kObjTypeALCName]  = @(
                weakSelf.commentObjectType);
                logParams[kObjTitleALCName] = [NSString stringWithFormat:@"评论页面/%@/%@",
                                               weakSelf.bannerName, data[@"ex"]];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    
    [self.bridge registerHandler:@"writeComment" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *apiUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_COMMENT_PUBLISH];
        NSString *appversion =  [NSString stringWithFormat:@"i%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
         NSString *userlocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERLOCATION"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kObjTitleAPCCName] = SafeText(weakSelf.bannerName);
        params[kAPI_TOEKN] = ApiToken(YHAPI_COMMENT_PUBLISH);
        params[@"user_num"] = SafeText(self.user.userNum);
        params[@"content"] = SafeText(data[@"content"]);
        params[@"_user_num"]=SafeText(self.user.userNum);
        params[@"_user_device_id"] = SafeText(self.user.deviceID);
        params[@"_app_version"] = SafeText(appversion);
        params[@"_coordinate"] = SafeText(userlocation);
        
        if (self.objectID != nil) {
            params[@"object_id"] = self.objectID;
        }
        if (self.commentObjectType) {
            params[@"object_type"] = @(self.commentObjectType);
        }
   
        
        HttpResponse *response = [HttpUtils httpPost:apiUrl Params:params];
        NSString *message = [NSString stringWithFormat:@"%@", response.data[@"message"]];
        [YHHttpRequestAPI yh_postCommentWithDict:params Finish:^(BOOL success, id model, NSString *jsonObjc) {
            if (success) {
                NSLog(@"成功");
            }
        }];
        if(response.statusCode && [response.statusCode isEqualToNumber:@(200)]) {
            [HudToolView showTopWithText:message color:[NewAppColor yhapp_1color]];
            [weakSelf loadHtml];
        }
        else{
            [HudToolView showTopWithText:message color:[NewAppColor yhapp_1color]];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName]   = @"评论";
                logParams[kObjTitleALCName] = weakSelf.bannerName;
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.browser.scrollView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.
}

- (void)viewWillAppear:(BOOL)animated {
    [HudToolView showLoadingInView:self.view];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
       self.navigationController.navigationBar.translucent = NO;
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 40)];
    UIImage *imageback = [[UIImage imageNamed:@"newnav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addSubview:bakImage];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.title =self.bannerName;
    [self loadHtml];
}

-(void)backAction {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.browser stopLoading];
        [self.browser cleanForDealloc];
        self.browser.delegate = nil;
        self.browser = nil;
        [self.progressHUD hide:YES];
        self.progressHUD = nil;
        self.bridge = nil;
        self.title = nil;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   

}

#pragma mark - UIWebview pull down to refresh
-(void)handleRefresh:(UIRefreshControl *)refresh {
    [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
    [self loadHtml];
    [refresh endRefreshing];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[kActionALCName]   = @"刷新/评论页面/浏览器";
        logParams[kObjTitleALCName] = self.urlString;
        [APIHelper actionLog:logParams];
    });
}

- (void)dealloc {
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
    self.title = nil;
}

- (void)loadHtml {
   [self _loadHtml];
}
- (void)_loadHtml {
    [self clearBrowserCache];
//    [self showLoading:LoadingLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.urlString assetsPath:self.assetsPath];
        
        __block NSString *htmlPath;
        if([httpResponse.statusCode isEqualToNumber:@(200)]) {
            htmlPath = [HttpUtils urlConvertToLocal:self.urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:kIsUrlWrite2Local];
        }
        else {
            NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
            htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            NSString *htmlContent = [FileUtils loadLocalAssetsWithPath:htmlPath];
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:self.sharedPath]];
        });
    });
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
  [HudToolView hideLoadingInView:self.view];
}
# pragma mark - 支持旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}
@end
