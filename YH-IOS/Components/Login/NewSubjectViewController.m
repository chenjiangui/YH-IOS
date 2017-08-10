//
//  NewSubjectViewController.m
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/7/31.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NewSubjectViewController.h"
#import "LoginViewController.h"
#import <PgyUpdate/PgyUpdateManager.h>
#import "ViewUtils.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import <SSZipArchive.h>
#import "Version.h"

#import "UMSocial.h"
#import "APIHelper.h"
#import "FileUtils+Report.h"
#import "CommentViewController.h"
#import "ReportSelectorViewController.h"
#import "DropTableViewCell.h"
#import "DropViewController.h"
#import "ViewUtils.h"
#import "DropTableViewCell.h"
#import "DropViewController.h"
#import "CommentViewController.h"
#import "ThreeSelectViewController.h"
#import "RootTableController.h"
#import "SelectDataModel.h"
#import <CoreLocation/CoreLocation.h>
#import "YHPopMenuView.h"


#define WeakSelf __weak typeof(*&self) weakSelf = self;
static NSString *const kCommentSegueIdentifier        = @"ToCommentSegueIdentifier";
static NSString *const kReportSelectorSegueIdentifier = @"ToReportSelectorSegueIdentifier";


@interface NewSubjectViewController ()<LTHPasscodeViewControllerDelegate,UIPopoverPresentationControllerDelegate,DropViewDelegate,DropViewDataSource,CLLocationManagerDelegate,WKUIDelegate,WKNavigationDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UMSocialUIDelegate,UIScrollViewDelegate,WebViewJavascriptBridgeBaseDelegate>
{
    NSMutableDictionary *betaDict;
    UIImageView *navBarHairlineImageView;
}

@property (assign, nonatomic) BOOL isInnerLink;
@property (assign, nonatomic) BOOL isSupportSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) NSString *reportID;
@property (strong, nonatomic) NSString *templateID;
@property (strong, nonatomic) NSString *javascriptPath;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintBannerView;
@property (strong, nonatomic) NSArray *dropMenuTitles;
@property (strong, nonatomic) NSArray *dropMenuIcons;
@property (assign, nonatomic) BOOL isLoadFinish;
@property (strong, nonatomic) UIView* idView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) NSString *userLongitude;
@property(nonatomic, strong) NSString *userlatitude;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) YHPopMenuView *popView;
@property (nonatomic, assign) BOOL rBtnSelected;
@property (nonatomic, strong) NSMutableArray *iconNameArray;
@property (nonatomic, strong) NSMutableArray *itemNameArray;

@end

@implementation NewSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [[User alloc] init];
    

    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    
    // 自适应屏幕宽度js
    
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    // 添加自适应屏幕宽度js调用的方法
    
    
    
//    self.browser = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.browser = [[SDWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) ];

    
    // self.browser.scrollView.bounces = NO;
    //self.navigationController.navigationBar.c;
    [self.view addSubview:_browser];
    self.browser.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.sharedPath = [FileUtils sharedPath];
    if(self.user.userID) {
        self.assetsPath = [FileUtils dirPath:kHTMLDirName];
    }
    
    [self startLocation];
    self.isLoadFinish = NO;
    [self hiddenShadow];
    
    /**
     * 被始化页面样式
     */
    //[self idColor];
    self.tabBarController.tabBar.hidden = YES;
    //self.bannerName = self.bannerName;
    /**
     * 服务器内链接需要做缓存、点击事件处理；
     */
    self.isInnerLink = !([self.link hasPrefix:@"http://"] || [self.link hasPrefix:@"https://"]);
    self.urlString   = self.link;
    // navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //self.browser = [[UIWebView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 60, self.view.frame.size.width, self.view.frame.size.height + 40)];
    //[self.view addSubview:self.browser];
    self.browser.UIDelegate = self;
    self.browser.navigationDelegate=self;
//    self.browser.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if(self.isInnerLink) {
        /*
         * /mobil/report/:report_id/group/:group_id
         * eg: /mobile/repoprt/1/group/%@
         */
        NSString *urlPath = [NSString stringWithFormat:self.link, self.user.groupID];
        self.urlString =[NSString stringWithFormat:@"%@%@", kBaseUrl, urlPath];
    }
    else {
        /*
         *  外部链接，支持手势放大缩小
         */
//        self.browser.scalesPageToFit = YES;
        
        self.browser.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    [self.browser setBackgroundColor:[UIColor whiteColor]];
//    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
//    //     设置进程池 用来配置同一个进程池webView的共享数据 如cookies 用户凭证等
//    WKProcessPool * pool = [[WKProcessPool alloc] init];
//    config.processPool = pool;
//    // 进程偏好设置
//    WKPreferences * prefer = [[WKPreferences alloc] init];
//    prefer.javaScriptEnabled = YES;
//    //     是否可以不进过用户交互由javascript自动打开窗口
//    prefer.javaScriptCanOpenWindowsAutomatically = YES;
//    config.preferences = prefer;
    //设置内容交互控制器 用于处理JavaScript与native交互
//    WKUserContentController * userController = [[WKUserContentController alloc]init];
//    //设置处理代理并且注册要被js调用的方法名称
//    [userController addScriptMessageHandler:self.bridge name:@"name"];
//    //js注入，注入一个测试方法。
//    NSString *javaScriptSource = @"function userFunc(){window.webkit.messageHandlers.name.postMessage( {\"name\":\"HS\"})}";
//    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScriptSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
//    // forMainFrameOnly:NO(全局窗口)，yes（只限主窗口）
//    [userController addUserScript:userScript];
//    config.userContentController = userController;

    

    //[self idColor];
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"SubjectViewController - Response for message from ObjC");
    }];
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(320, 3)]];
    /* [LTHPasscodeViewController sharedUser].delegate = self;
     [LTHPasscodeViewController useKeychain:NO];
     [LTHPasscodeViewController sharedUser].allowUnlockWithTouchID = NO;*/
    [self hiddenShadow];
    //[MRProgressOverlayView showOverlayAddedTo:self.browser title:@"加载中" mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    //[self showProgressHUD:@"加载中" mode:MBProgressHUDModeIndeterminate];
    
    // self.bannerView.height = 0;
    // self.browser.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height + 40);
    [self.navigationController setNavigationBarHidden:false];
    // [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[NewAppColor yhapp_6color]}];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 40)];
    UIImage *imageback = [[UIImage imageNamed:@"newnav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn addSubview:bakImage];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"btn_add"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onRightBtn:)];
    self.title =self.bannerName;


 
    /*
     * 主题页面,允许横屏
     */
    [self setAppAllowRotation:YES];
    /**
     *  横屏时，隐藏标题栏，增大可视区范围
     */
    // [self checkInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    [self displayBannerViewButtonsOrNot];
    [self isLoadHtmlFromService];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRefresh) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
}

// 弹出框
#pragma mark - Action
- (void)onRightBtn:(id)sender{
    
    _rBtnSelected = !_rBtnSelected;
    if (_rBtnSelected) {
        [self showPopMenu];
    }else{
        [self hidePopMenuWithAnimation:YES];
    }
}

- (void)showPopMenu{
    CGFloat itemH = 40;
    CGFloat w = 120;
    CGFloat h = self.iconNameArray.count*itemH;
    CGFloat x = SCREEN_WIDTH -9-120;
    CGFloat y = -9;
    _popView = [[YHPopMenuView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    _popView.iconNameArray =self.iconNameArray;
    _popView.itemNameArray =self.itemNameArray;
    _popView.itemH     = itemH;
    _popView.fontSize  = 14.0f;
    _popView.fontColor = [NewAppColor yhapp_10color];
    _popView.canTouchTabbar = YES;
    _popView.iconLeftSpace=15;
    _popView.iconW=19;
    _popView.itemNameLeftSpace=32;
    [_popView show];
    WeakSelf;
    [_popView dismissHandler:^(BOOL isCanceled, NSInteger row) {
        if (!isCanceled) {
            NSLog(@"点击第%ld行",(long)row);
            NSString *itemName = self.dropMenuTitles[row];
            
            if([itemName isEqualToString:kDropCommentText]) {
                [self actionWriteComment];
            }
            else if([itemName isEqualToString:kDropSearchText]) {
                [self actionDisplaySearchItems];
            }
            else if([itemName isEqualToString:kDropShareText]) {
                [self actionWebviewScreenShot];
            }
            else if ([itemName isEqualToString:kDropRefreshText]){
                [self handleRefresh];
            }
            else if ([itemName isEqualToString:kDropCopyLinkText]){
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = self.link;
                if (![pasteboard.string isEqualToString:@""]) {
                    [ViewUtils showPopupView:self.view Info:@"链接复制成功"];
                }
            }
            
        }
        
        weakSelf.rBtnSelected = NO;
    }];
}

- (void)hidePopMenuWithAnimation:(BOOL)animate{
    [_popView hideWithAnimation:animate];
}



#pragma mark - private method


//解决 uinavigationBar 透明之后出现黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)clearBrowserCache {
    [self.browser stopLoading];
    
    NSString *domain = [[NSURL URLWithString:self.urlString] host];
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if([[cookie domain] isEqualToString:domain]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}
- (void)showLoading:(LoadingType)loadingType {
    NSString *loadingPath = [FileUtils loadingPath:loadingType];
    NSString *loadingContent = [NSString stringWithContentsOfFile:loadingPath encoding:NSUTF8StringEncoding error:nil];
    [self.browser loadHTMLString:loadingContent baseURL:[NSURL fileURLWithPath:loadingPath]];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

- (void)showProgressHUD:(NSString *)text {
    [self showProgressHUD:text mode:MBProgressHUDModeIndeterminate];
}

- (void)showProgressHUD:(NSString *)text mode:(MBProgressHUDMode)mode {
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.browser animated:YES];
    self.progressHUD.labelText = text;
    self.progressHUD.mode = mode;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}
- (void)jumpToLogin {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[kIsLoginCUName] = @(NO);
    [userDict writeToFile:userConfigPath atomically:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kMainSBName bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:kLoginVCName];
    self.view.window.rootViewController = loginViewController;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。注意跟ios6.0之前的区分
    // Add code to clean up any of your own resources that are no longer necessary.
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
//            self.browser=nil;
//            [self.view removeAllSubviews];
//            [self.browser removeAllSubviews];
            
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
    NSLog(@"收到IOS系统，内存警告.");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"警告/内存";
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}

/**
 *  设置是否允许横屏
 *
 *  @param allowRotation 允许横屏
 */
- (void)setAppAllowRotation:(BOOL)allowRotation {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = allowRotation;
}

/**
 *  检测服务器端静态文件是否更新
 */
- (void)checkAssetsUpdate {
    // 初始化队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    AFHTTPRequestOperation *op;
    op = [self checkAssetUpdate:kLoadingAssetsName info:kLoadingPopupText isInAssets: NO];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kFontsAssetsName info:kFontsPopupText isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kImagesAssetsName info:kImagesPopupText isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kStylesheetsAssetsName info:kStylesheetsPopupText isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kJavascriptsAssetsName info:kJavascriptsPopupText isInAssets: YES];
    if(op) { [queue addOperation:op]; }
    op = [self checkAssetUpdate:kBarCodeScanAssetsName info:kBarCodeScanPopupText isInAssets: NO];
    if(op) { [queue addOperation:op]; }
    // op = [self checkAssetUpdate:kAdvertisementAssetsName info:kAdvertisementPopupText isInAssets: NO];
    // if(op) { [queue addOperation:op]; }
}

- (AFHTTPRequestOperation *)checkAssetUpdate:(NSString *)assetName info:(NSString *)info isInAssets:(BOOL)isInAssets {
    BOOL isShouldUpdateAssets = NO;
    __block NSString *sharedPath = [FileUtils sharedPath];
    
    NSString *assetsZipPath = [sharedPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", assetName]];
    if(![FileUtils checkFileExist:assetsZipPath isDir:NO]) {
        isShouldUpdateAssets = YES;
    }
    
    __block NSString *assetKey = [NSString stringWithFormat:@"%@_md5", assetName];
    __block  NSString *localAssetKey = [NSString stringWithFormat:@"local_%@_md5", assetName];
    __block NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    __block NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if(!isShouldUpdateAssets && ![userDict[assetKey] isEqualToString:userDict[localAssetKey]]) {
        isShouldUpdateAssets = YES;
        NSLog(@"%@ - local: %@, server: %@", assetName, userDict[localAssetKey], userDict[assetKey]);
    }
    if(!isShouldUpdateAssets) { return nil; }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.tag       = 1000;
    HUD.mode      = MBProgressHUDModeDeterminate;
    HUD.labelText = [NSString stringWithFormat:@"更新%@", info];
    HUD.square    = YES;
    [HUD show:YES];
    // 下载地址
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kDownloadAssetsAPIPath, kBaseUrl, assetName]];
    // 保存路径
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    op.outputStream = [NSOutputStream outputStreamToFileAtPath:assetsZipPath append:NO];
    // 根据下载量设置进度条的百分比
    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
        HUD.progress = precent;
    }];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [FileUtils checkAssets:assetName isInAssets:isInAssets bundlePath:[[NSBundle mainBundle] bundlePath]];
        [HUD removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@" 下载失败 ");
        [HUD removeFromSuperview];
    }];
    return op;
}

-(void)dealloc{
    NSLog(@"%@",[NSString stringWithFormat:@"%@----->%@---->%@",self.title,NSStringFromClass(self.class),@"销毁了"]);
}

#pragma mark - LTHPasscodeViewControllerDelegate methods

- (void)passcodeWasEnteredSuccessfully {
    __weak typeof(*&self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"解屏";
            [APIHelper actionLog:logParams];
            
            /**
             *  解屏验证用户信息，更新用户权限
             */
            NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
            NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
            if(!userDict[kUserNumCUName]) {
                return;
            }
            
            NSString *userlocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERLOCATION"];
            NSString *msg = [APIHelper userAuthentication:userDict[kUserNumCUName] password:userDict[kPasswordCUName] coordinate:userlocation];
            if(msg.length > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf jumpToLogin];
                });
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}


- (BOOL)didPasscodeTimerEnd {
    return YES;
}
- (NSString *)passcode {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if([userDict[kIsLoginCUName] boolValue] && [userDict[kIsUseGesturePasswordCUName] boolValue]) {
        return userDict[kGesturePasswordCUName] ?: @"";
    }
    return @"";
}

- (void)savePasscode:(NSString *)passcode {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[kIsUseGesturePasswordCUName] = @(YES);
    userDict[kGesturePasswordCUName] = passcode;
    [userDict writeToFile:userConfigPath atomically:YES];
    
    NSString *settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kSettingConfigFileName];
    [userDict writeToFile:settingsConfigPath atomically:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APIHelper screenLock:userDict[kUserDeviceIDCUName] passcode:passcode state:YES];
    });
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"设置锁屏";
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//标识点
- (void)idColor {
    self.idView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50,34, 30, 10)];
    //idView.backgroundColor = [UIColor redColor];
    [self.navigationController.navigationBar addSubview:_idView];
    //400-6701-855
    UIImageView* idColor0 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 4, 4)];
    idColor0.layer.cornerRadius = 2;
    [_idView addSubview:idColor0];
    
    UIImageView* idColor1 = [[UIImageView alloc]initWithFrame:CGRectMake(6, 1, 4, 4)];
    idColor1.layer.cornerRadius = 1;
    [_idView addSubview:idColor1];
    
    UIImageView* idColor2 = [[UIImageView alloc]initWithFrame:CGRectMake(12, 1, 4, 4)];
    idColor2.layer.cornerRadius = 1;
    [_idView addSubview:idColor2];
    
    UIImageView* idColor3 = [[UIImageView alloc]initWithFrame:CGRectMake(18, 1, 4, 4)];
    idColor3.layer.cornerRadius = 1;
    [_idView addSubview:idColor3];
    
    UIImageView* idColor4 = [[UIImageView alloc]initWithFrame:CGRectMake(24, 1, 4, 4)];
    idColor4.layer.cornerRadius = 1;
    [_idView addSubview:idColor4];
    NSArray *colors = @[@"00ffff", @"ffcd0a", @"fd9053", @"dd0929", @"016a43", @"9d203c", @"093db5", @"6a3906", @"192162", @"000000"];
    NSArray *colorViews = @[idColor0, idColor1, idColor2, idColor3, idColor4];
    NSString *userID = [NSString stringWithFormat:@"%@", self.user.userID];
    NSString *color;
    NSInteger userIDIndex, numDiff = colorViews.count - userID.length;
    UIImageView *imageView;
    numDiff = numDiff < 0 ? 0 : numDiff;
    for(NSInteger i = 0; i < colorViews.count; i++) {
        color = colors[0];
        if(i >= numDiff) {
            userIDIndex = [[NSString stringWithFormat:@"%c", [userID characterAtIndex:i-numDiff]] integerValue];
            color = colors[userIDIndex];
        }
        imageView = colorViews[i];
        imageView.image = [self imageWithColor:[UIColor colorWithHexString:color] size:CGSizeMake(5.0, 5.0)];
        imageView.layer.cornerRadius = 2.5f;
        imageView.layer.masksToBounds = YES;
        imageView.hidden = NO;
    }
}
- (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    UIBezierPath* rPath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., size.width, size.height)];
    [color setFill];
    [rPath fill];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)backAction{
    [super dismissViewControllerAnimated:YES completion:^{
        [self.browser stopLoading];
        self.browser.UIDelegate = nil;
        self.browser = nil;
        [self.progressHUD hide:YES];
       self.progressHUD = nil;
        self.bridge = nil;
    }];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (size.width > size.height) { // 横屏
        self.browser.frame = CGRectMake(0, 0,size.width,size.height+30);
        self.idView.frame = CGRectMake(size.width-55, 34, 30, 10);
    } else {
        self.browser.frame = CGRectMake(0, 0, size.width, size.height-34);
    }
}

/*
 -(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
 //  [self checkInterfaceOrientation:toInterfaceOrientation];
 [self dismissViewControllerAnimated:YES completion:nil];
 [self loadHtml];
 }*/
/**
 *  横屏时，隐藏标题栏，增大可视区范围
 *
 *  @param interfaceOrientation 设备屏幕放置方向
 */
/*
 - (void)checkInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 BOOL isLandscape = UIInterfaceOrientationIsLandscape(interfaceOrientation);
 if (!isLandscape) {
 self.browser.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
 }
 else{
 self.browser.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.height, [[UIScreen mainScreen]bounds].size.width);
 }
 //  [self.view layoutIfNeeded];
 
 // [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
 }
 
 */
// 隐藏UINavigationBar 底部黑线

- (void)hiddenShadow {
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
}

//判断是否离线
-(void)isLoadHtmlFromService {
    if (([HttpUtils isNetworkAvailable3] &&  self.isInnerLink) || !self.isInnerLink ) {
        self.title = [NSString stringWithFormat:@"%@",self.bannerName];
        [self loadHtml];
    }
    else{
        self.title = [NSString stringWithFormat:@"%@(离线)",self.bannerName];
        [self clearBrowserCache];
        NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
        NSString* htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
        NSString *htmlContent = [FileUtils loadLocalAssetsWithPath:htmlPath];
        
    
        if (![FileUtils checkFileExist:htmlPath isDir:NO] || ([htmlContent length] == 0 )) {
            [self showLoading:LoadingRefresh];
        }
        else {
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:self.sharedPath]];
        }
    }
}
//根据 url 获取本地文件名
- (NSArray *)urlTofilename:(NSString *)url suffix:(NSString *)suffix {
    NSArray *blackList = @[@".", @":", @"/", @"?"];
    
    url = [url stringByReplacingOccurrencesOfString:kBaseUrl withString:@""];
    NSArray *parts = [url componentsSeparatedByString:@"?"];
    
    NSString *timestamp = nil;
    if([parts count] > 1) {
        url = parts[0];
        timestamp = parts[1];
    }
    if([url hasSuffix:suffix]) {
        url = [url stringByDeletingPathExtension];
    }
    while([url hasPrefix:@"/"]) {
        url = [url substringWithRange:NSMakeRange(1,url.length-1)];
    }
    for(NSString *str in blackList) {
        url = [url stringByReplacingOccurrencesOfString:str withString:@"_"];
    }
    if(![url hasSuffix:suffix]) {
        url = [NSString stringWithFormat:@"%@%@", url, suffix];
    }
    
    NSArray *result = [NSArray array];
    if(timestamp) {
        result = @[url, timestamp];
    }
    else {
        result = @[url];
    }
    
    return result;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    /*
     * 其他页面,禁用横屏
     */
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self setAppAllowRotation:NO];
}


#pragma mark - UIWebview pull down to refresh

-(void)handleRefresh {
//    [self addWebViewJavascriptBridge];
    
    if(self.isInnerLink) {
        NSString *reportDataUrlString = [APIHelper reportDataUrlString:self.user.groupID templateID:self.templateID reportID:self.reportID];
        
        [HttpUtils clearHttpResponeHeader:reportDataUrlString assetsPath:self.assetsPath];
        [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
    }
    
    [self isLoadHtmlFromService];
    //[refresh endRefreshing];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName]   = @"刷新/主题页面/浏览器";
            logParams[kObjTitleALCName] = self.urlString;
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}

- (void)displayBannerViewButtonsOrNot {
    self.btnShare.hidden = !kSubjectShare;
    self.btnComment.hidden = !kSubjectComment;
    self.btnSearch.hidden = YES;
    
    if(!kSubjectComment && !kSubjectShare) {
        self.btnSearch.frame = self.btnComment.frame; // CGRectMake(CGRectGetMaxX(self.btnSearch.frame) + 30, 0, 30, 55);
    }
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
                logParams[kActionALCName]   = @"JS异常";
                logParams[kObjIDALCName]    = weakSelf.objectID;
                logParams[kObjTypeALCName]  = @(weakSelf.commentObjectType);
                logParams[kObjTitleALCName] = [NSString stringWithFormat:@"主题页面/%@/%@", weakSelf.bannerName, data[@"ex"]];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    
    [self.bridge registerHandler:@"refreshBrowser" handler:^(id data, WVJBResponseCallback responseCallback) {
        [HttpUtils clearHttpResponeHeader:weakSelf.urlString assetsPath:weakSelf.assetsPath];
        
        [weakSelf handleRefresh];
    }];
    
    [self.bridge registerHandler:@"pageTabIndex" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *behaviorPath = [FileUtils dirPath:kConfigDirName FileName:kBehaviorConfigFileName];
        NSMutableDictionary *behaviorDict = [FileUtils readConfigFile:behaviorPath];
        
        NSString *action = data[@"action"], *pageName = data[@"pageName"];
        NSNumber *tabIndex = data[@"tabIndex"];
        
        if([action isEqualToString:@"store"]) {
            behaviorDict[kReportUBCName][pageName] = tabIndex;
            [behaviorDict writeToFile:behaviorPath atomically:YES];
        }
        else if([action isEqualToString:@"restore"]) {
            tabIndex = behaviorDict[kReportUBCName] && behaviorDict[kReportUBCName][pageName] ? behaviorDict[kReportUBCName][pageName] : @(0);
            
            responseCallback(tabIndex);
        }
        else {
            NSLog(@"unkown action %@", action);
        }
    }];
    
    [self.bridge registerHandler:@"searchItems" handler:^(id data, WVJBResponseCallback responseCallback) {
        /* NSString *reportDataFileName = [NSString stringWithFormat:kReportDataFileName, weakSelf.user.groupID, weakSelf.templateID, weakSelf.reportID];
         NSString *javascriptFolder = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
         weakSelf.javascriptPath = [javascriptFolder stringByAppendingPathComponent:reportDataFileName];
         NSString *searchItemsPath = [NSString stringWithFormat:@"%@.search_items", self.javascriptPath];
         
         [data[@"items"] writeToFile:searchItemsPath atomically:YES];
         self.iconNameArray = [@[@"Barcode-Scan",@"Barcode-Scan",@"Barcode-Scan",@"Barcode-Scan"] mutableCopy];
         self.itemNameArray = [@[@"分享",@"评论",@"刷新",@"筛选"] mutableCopy];
         
         /**
         *  判断筛选的条件: data[@"items"] 数组不为空
         *  报表第一次加载时，此处为判断筛选功能的关键点
         */
        /* weakSelf.isSupportSearch = [FileUtils reportIsSupportSearch:weakSelf.user.groupID templateID:weakSelf.templateID reportID:weakSelf.reportID];
         if(weakSelf.isSupportSearch) {
         [weakSelf displayBannerTitleAndSearchIcon];
         }*/
    }];
    /*[self.bridge registerHandler:@"toggleShowBanner" handler:^(id data, WVJBResponseCallback responseCallback){
     if ([data[@"state"] isEqualToString:@"show"]) {
     [self.navigationController.navigationBar setHidden:NO];
     self.browser.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
     }
     else {
     [self.navigationController.navigationBar setHidden:YES];
     self.browser.frame = CGRectMake(0, -64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
     }
     }];
     
     
     [self.bridge registerHandler:@"toggleShowBannerBack" handler:^(id data, WVJBResponseCallback responseCallback){
     if ([data[@"state"] isEqualToString:@"show"]) {
     //[self.navigationItem.rightBarButtonItem seth]
     [self.backBtn setHidden:NO];
     }
     else {
     [self.backBtn setHidden:YES];
     }
     }];
     
     [self.bridge registerHandler:@"toggleShowBannerMenu" handler:^(id data, WVJBResponseCallback responseCallback){
     if ([data[@"state"] isEqualToString:@"show"]) {
     //[self.navigationItem.rightBarButtonItem seth]
     self.navigationItem.rightBarButtonItem.customView.hidden=NO;
     }
     else {
     self.navigationItem.rightBarButtonItem.customView.hidden=YES;
     }
     }];
     [self.bridge registerHandler:@"setBannerTitle" handler:^(id data, WVJBResponseCallback responseCallback){
     self.title = data[@"title"];
     }];
     
     NSString *coordianteString = [NSString stringWithFormat:@"%@,%@",self.userLongitude,self.userlatitude];
     if (self.userlatitude == nil || [self.userlatitude isEqualToString:@""]) {
     coordianteString = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERLOCATION"];
     }
     else {
     [[NSUserDefaults standardUserDefaults] setObject:coordianteString forKey:@"USERLOCATION"];
     }
     [self.bridge registerHandler:@"closeSubjectView" handler:^(id data, WVJBResponseCallback responseCallback) {
     [super dismissViewControllerAnimated:YES completion:nil];
     }];
     
     [self.bridge registerHandler:@"getLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
     NSLog(@"%@",coordianteString);
     responseCallback(coordianteString);
     }];
     */
    [self.bridge registerHandler:@"selectedItem" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *reportDataFileName = [NSString stringWithFormat:kReportDataFileName, weakSelf.user.groupID, weakSelf.templateID, weakSelf.reportID];
        NSString *javascriptFolder = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
        weakSelf.javascriptPath = [javascriptFolder stringByAppendingPathComponent:reportDataFileName];
        NSString *selectedItemPath = [NSString stringWithFormat:@"%@.selected_item", weakSelf.javascriptPath];
        NSString *selectedItem = NULL;
        if([FileUtils checkFileExist:selectedItemPath isDir:NO]) {
            selectedItem = [NSString stringWithContentsOfFile:selectedItemPath encoding:NSUTF8StringEncoding error:nil];
        }
        responseCallback(selectedItem);
    }];
    [self.bridge registerHandler:@"setSearchItemsV2" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *reportDataFileName = [NSString stringWithFormat:kReportDataFileName, weakSelf.user.groupID, weakSelf.templateID, weakSelf.reportID];
        NSString *javascriptFolder = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
        weakSelf.javascriptPath = [javascriptFolder stringByAppendingPathComponent:reportDataFileName];
        NSString *searchItemsPath = [NSString stringWithFormat:@"%@.search_items", weakSelf.javascriptPath];
        
        [data[@"items"] writeToFile:searchItemsPath atomically:YES];
        weakSelf.iconNameArray = [@[@"Barcode-Scan",@"Barcode-Scan",@"Barcode-Scan",@"Barcode-Scan"] mutableCopy];
        weakSelf.itemNameArray = [@[@"分享",@"评论",@"刷新",@"筛选"] mutableCopy];
        
        /**
         *  判断筛选的条件: data[@"items"] 数组不为空
         *  报表第一次加载时，此处为判断筛选功能的关键点
         */
        weakSelf.isSupportSearch = [FileUtils reportIsSupportSearch:weakSelf.user.groupID templateID:weakSelf.templateID reportID:weakSelf.reportID];
        if(weakSelf.isSupportSearch) {
            [weakSelf displayBannerTitleAndSearchIcon];
        }
        
    }];
    
    
    [self.bridge registerHandler:@"showAlert" handler:^(id data, WVJBResponseCallback responseCallback){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:data[@"title"]
                                                                       message:data[@"content"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                              }];
        
        
        [alert addAction:defaultAction];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
    
    // UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    //[refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    //[self.browser.scrollView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.
}

// 获取经纬度
-(void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    // 获取当前所在的城市名
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    self.userlatitude = [NSString stringWithFormat:@"%.14f",oldCoordinate.latitude];
    self.userLongitude = [NSString stringWithFormat:@"%.14f", oldCoordinate.longitude];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
#pragma mark - assistant methods
- (void)loadHtml {
    DeviceState deviceState = [APIHelper deviceState];
    if(deviceState == StateOK) {
        self.isInnerLink ? [self loadInnerLink] : [self loadOuterLink];
    }
    else if(deviceState == StateForbid) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:kIAlreadyKnownText actionBlock:^(void) {
            [self jumpToLogin];
        }];
        
        [alert showError:self title:kWarningTitleText subTitle:kAppForbiedUseText closeButtonTitle:nil duration:0.0f];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading:LoadingRefresh];
        });
    }
}

- (void)loadOuterLink {
    
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 2000];
    NSString *splitString = [self.urlString containsString:@"?"] ? @"&" : @"?";
    NSString *appendParams = [NSString stringWithFormat:@"user_num=%@&timestamp=%@", self.user.userNum, timestamp];
    self.urlString = [NSString stringWithFormat:@"%@%@%@", self.urlString, splitString, appendParams];
    
    [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    self.isLoadFinish = !self.browser.isLoading;
}

- (void)loadInnerLink {
    /**
     *  only inner link clean browser cache
     */
    [self clearBrowserCache];
    // [self showLoading:LoadingLoad];
    
    /*
     * format: /mobile/v1/group/:group_id/template/:template_id/report/:report_id
     * deprecated
     * format: /mobile/report/:report_id/group/:group_id
     */
    NSArray *components = [self.link componentsSeparatedByString:@"/"];
    self.templateID = components[5];
    self.reportID = components[8];
    
    /**
     * 内部报表具有筛选功能时
     *   - 如果用户已选择，则 banner 显示该选项名称
     *   - 未设置时，默认显示筛选项列表中第一个
     *
     *  初次加载时，判断筛选功能的条件还未生效
     *  此处仅在第二次及以后才会生效
     */
    self.isSupportSearch = [FileUtils reportIsSupportSearch:self.user.groupID templateID:self.templateID reportID:self.reportID];
    if(self.isSupportSearch) {
        [self displayBannerTitleAndSearchIcon];
    }
    __weak typeof(*&self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APIHelper reportData:weakSelf.user.groupID templateID:weakSelf.templateID reportID:weakSelf.reportID];
        
        HttpResponse *httpResponse = [HttpUtils checkResponseHeader:weakSelf.urlString assetsPath:weakSelf.assetsPath];
        
         NSString *htmlPath;
        if([httpResponse.statusCode isEqualToNumber:@(200)]) {
            htmlPath = [HttpUtils urlConvertToLocal:weakSelf.urlString content:httpResponse.string assetsPath:weakSelf.assetsPath writeToLocal:kIsUrlWrite2Local];
        }
        else {
            NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
            htmlPath = [[FileUtils sharedPath] stringByAppendingPathComponent:htmlName];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            NSURL* baseurl = [NSURL fileURLWithPath:htmlPath];
            [self.browser loadFileURL:baseurl allowingReadAccessToURL:[NSURL fileURLWithPath:[FileUtils sharedPath]]];
            [HudToolView hideLoadingInView:self.view];
            self.isLoadFinish = !self.browser.isLoading;
        });
    });
}


- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}




- (void)displayBannerTitleAndSearchIcon {
    self.btnSearch.hidden = NO;
    
    NSString *reportSelected = [FileUtils reportSelectedItem:self.user.groupID templateID:self.templateID reportID:self.reportID];
    NSString *reportSelectedItem = [reportSelected stringByReplacingOccurrencesOfString:@"||" withString:@"•"];
    
    if(reportSelectedItem == NULL || [reportSelectedItem length] == 0) {
        NSArray *reportSearchItems = [FileUtils reportSearchItems:self.user.groupID templateID:self.templateID reportID:self.reportID];
        if([reportSearchItems count] > 0) {
            NSArray<SelectDataModel *>  *allarray = [MTLJSONAdapter modelsOfClass:SelectDataModel.class fromJSONArray:reportSearchItems error:nil];
            if (allarray[0].deep == 1) {
                reportSelectedItem = [NSString stringWithFormat:@"%@", allarray[0].titles];
            }
            else if(allarray[0].deep == 2){
                reportSelectedItem = [NSString stringWithFormat:@"%@•%@", allarray[0].titles,allarray[0].infos[0].titles];
            }
            else if (allarray[0].deep == 3){
                reportSelectedItem = [NSString stringWithFormat:@"%@•%@•%@", allarray[0].titles,allarray[0].infos[0].titles,allarray[0].infos[0].infos[0].titles];
            }
        }
        else {
            reportSelectedItem = [NSString stringWithFormat:@"%@(NONE)", self.title];
        }
    }
    if ([HttpUtils isNetworkAvailable3]) {
        self.title = [NSString stringWithFormat:@"%@",reportSelectedItem];
    }
    else{
        self.title = [NSString stringWithFormat:@"%@(离线)",reportSelectedItem];
    }
}


#pragma 下拉菜单功能块

- (void)initDropMenu {
    NSMutableArray *tmpTitles = [NSMutableArray array];
    NSMutableArray *tmpIcons = [NSMutableArray array];
    if(kSubjectShare) {
        [tmpTitles addObject:kDropShareText];
        [tmpIcons addObject:@"Subject-Share"];
    }
    if(kSubjectComment) {
        [tmpTitles addObject:kDropCommentText];
        [tmpIcons addObject:@"Subject-Comment"];
    }
    if(self.isSupportSearch) {
        [tmpTitles addObject:kDropSearchText];
        [tmpIcons addObject:@"筛选"];
    }
    if (!self.isInnerLink) {
        [tmpTitles addObject:kDropCopyLinkText];
        [tmpIcons addObject:@"Subject_Copylink"];
    }
    [tmpTitles addObject:kDropRefreshText];
    [tmpIcons addObject:@"Subject-Refresh"];
    self.dropMenuTitles = [NSArray arrayWithArray:tmpTitles];
    self.dropMenuIcons = [NSArray arrayWithArray:tmpIcons];
}


/**
 *  标题栏设置按钮点击显示下拉菜单
 *
 *  @param sender
 */
-(void)dropTableView:(UIBarButtonItem *)sender {
    [self initDropMenu];
    DropViewController *dropTableViewController = [[DropViewController alloc]init];
    dropTableViewController.view.frame = CGRectMake(0, 0, 150, 150);
    dropTableViewController.preferredContentSize = CGSizeMake(150,self.dropMenuTitles.count*150/4);
    dropTableViewController.dataSource = self;
    dropTableViewController.delegate = self;
    UIPopoverPresentationController *popover = [dropTableViewController popoverPresentationController];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.barButtonItem = self.navigationItem.rightBarButtonItem;
    popover.delegate = self;
    [popover setSourceRect:sender.customView.frame];
    [popover setSourceView:self.view];
    popover.backgroundColor = [UIColor colorWithHexString:kDropViewColor];
    [self presentViewController:dropTableViewController animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(NSInteger)numberOfPagesIndropView:(DropViewController *)flowView{
    return self.dropMenuTitles.count;
}

-(UITableViewCell *)dropView:(DropViewController *)flowView cellForPageAtIndex:(NSIndexPath *)index{
    DropTableViewCell*  cell = [[DropTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dorpcell"];
    cell.tittleLabel.text = self.dropMenuTitles[index.row];
    cell.iconImageView.image = [UIImage imageNamed:self.dropMenuIcons[index.row]];
    
    UIView *cellBackView = [[UIView alloc]initWithFrame:cell.frame];
    cellBackView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = cellBackView;
    cell.tittleLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

-(void)dropView:(DropViewController *)flowView didTapPageAtIndex:(NSIndexPath *)index{
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *itemName = self.dropMenuTitles[index.row];
        
        if([itemName isEqualToString:kDropCommentText]) {
            [self actionWriteComment];
        }
        else if([itemName isEqualToString:kDropSearchText]) {
            [self actionDisplaySearchItems];
        }
        else if([itemName isEqualToString:kDropShareText]) {
            [self actionWebviewScreenShot];
        }
        else if ([itemName isEqualToString:kDropRefreshText]){
            [self handleRefresh];
        }
        else if ([itemName isEqualToString:kDropCopyLinkText]){
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.link;
            if (![pasteboard.string isEqualToString:@""]) {
                [ViewUtils showPopupView:self.view Info:@"链接复制成功"];
            }
        }
    }];
}


#pragma mark - ibaction block
- (IBAction)actionBack:(id)sender {
    [super dismissViewControllerAnimated:YES completion:^{
        [self.browser stopLoading];
//        [self.browser cleanForDealloc];
        self.browser.UIDelegate = nil;
        self.browser = nil;
//        [self.progressHUD hide:YES];
//        self.progressHUD = nil;
        self.bridge = nil;
    }];
}

- (void)actionWriteComment{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CommentViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    subjectView.bannerName = self.bannerName;
    subjectView.objectID = self.objectID;
    subjectView.commentObjectType  =self.commentObjectType;
    UINavigationController *commentCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[kActionALCName] = @"点击/主题页面/评论";
        [APIHelper actionLog:logParams];
    });
    [self.navigationController presentViewController:commentCtrl animated:YES completion:nil];
}

- (void)actionDisplaySearchItems {
    
    ThreeSelectViewController *selectorView = [[ThreeSelectViewController alloc]init];
    UINavigationController *commentCtrl = [[UINavigationController alloc]initWithRootViewController:selectorView];
    selectorView.bannerName = self.bannerName;
    selectorView.groupID = self.user.groupID;
    selectorView.reportID = self.reportID;
    selectorView.templateID  =self.templateID;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[kActionALCName] = @"点击/主题页面/筛选";
        [APIHelper actionLog:logParams];
    });
    [self.navigationController presentViewController:commentCtrl animated:YES completion:nil];
    
    /*RootTableController *selectorView = [[RootTableController alloc]init];
     UINavigationController *commentCtrl = [[UINavigationController alloc]initWithRootViewController:selectorView];
     selectorView.bannerName = self.bannerName;
     selectorView.groupID = self.user.groupID;
     selectorView.reportID = self.reportID;
     selectorView.templateID  =self.templateID;
     [self.navigationController presentViewController:commentCtrl animated:YES completion:nil];*/
    
    
    /* UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     
     ReportSelectorViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ReportSelectorSegueIdentifier"];
     subjectView.bannerName = self.bannerName;
     subjectView.groupID = self.user.groupID;
     subjectView.reportID = self.reportID;
     subjectView.templateID  =self.templateID;
     UINavigationController *commentCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
     [self.navigationController presentViewController:commentCtrl animated:YES completion:nil];*/
    
}

- (void)actionWebviewScreenShot{
    if (self.isLoadFinish) {
        @try {
            UIImage *image;
            NSString *settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kSettingConfigFileName];
            betaDict = [FileUtils readConfigFile:settingsConfigPath];
            if (betaDict[@"image_within_screen"] && [betaDict[@"image_within_screen"] boolValue]) {
                image = [self saveWebViewAsImage];
                // image = [self createViewImage:self.navigationController.view];
            }
            else {
                image = [self createViewImage:self.navigationController.view];
            }
            dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1ull *NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
                [UMSocialData defaultData].extConfig.title = kWeiXinShareText;
                [UMSocialData defaultData].extConfig.qqData.url = kBaseUrl;
                [UMSocialSnsService presentSnsIconSheetView:self
                                                     appKey:kUMAppId
                                                  shareText:self.bannerName
                                                 shareImage:image
                                            shareToSnsNames:@[UMShareToWechatSession]
                                                   delegate:self];
            });
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"分享提示"
                                                                       message:@"正在加载数据，请稍后分享"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  self.isLoadFinish = self.browser.isLoading;
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (UIImage *)createViewImage:(UIView *)shareView {
    UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, NO, [UIScreen mainScreen].scale);
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)saveWebViewAsImage {
    UIScrollView *scrollview = self.browser.scrollView;
    UIImage *image = nil;
    CGSize boundsSize = self.browser.scrollView.contentSize;
    if (boundsSize.height > kScreenHeight * 3) {
        boundsSize.height = kScreenHeight * 3;
    }
    UIGraphicsBeginImageContextWithOptions(boundsSize ,NO, 0.0);
    CGPoint savedContentOffset = scrollview.contentOffset;
    CGRect savedFrame = scrollview.frame;
    scrollview.contentOffset = CGPointZero;
    scrollview.frame = CGRectMake(0,0, boundsSize.width, boundsSize.height);
    [scrollview.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    scrollview.contentOffset = savedContentOffset;
    scrollview.frame = savedFrame;
    UIGraphicsEndImageContext();
    return image;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(self.isInnerLink) {
        [self isLoadHtmlFromService];
        [self.browser stopLoading];
    }
    if([segue.identifier isEqualToString:kCommentSegueIdentifier]) {
        CommentViewController *viewController = (CommentViewController *)segue.destinationViewController;
        viewController.bannerName        = self.bannerName;
        viewController.commentObjectType = self.commentObjectType;
        viewController.objectID          = self.objectID;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"点击/主题页面/评论";
            [APIHelper actionLog:logParams];
        });
    }
    else if([segue.identifier isEqualToString:kReportSelectorSegueIdentifier]) {
        ReportSelectorViewController *viewController = (ReportSelectorViewController *)segue.destinationViewController;
        viewController.bannerName  = self.bannerName;
        viewController.groupID     = self.user.groupID;
        viewController.reportID    = self.reportID;
        viewController.templateID  = self.templateID;
    }
}

#pragma mark - UIWebview delegate
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSDictionary *browerDict = [FileUtils readConfigFile:[FileUtils dirPath:kConfigDirName FileName:kBetaConfigFileName]];
//    self.isLoadFinish = YES;
//    [MRProgressOverlayView dismissOverlayForView:self.browser animated:YES];
//    if ([browerDict[@"allow_brower_copy"] boolValue]) {
//        return;
//    }
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
//}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    /**
     *  忽略 NSURLErrorDomain 错误 - 999
     */
    if([error code] == NSURLErrorCancelled) {
        return;
    }
    
    NSLog(@"dvc: %@", error.description);
}

#pragma mark - bug#fix
/**
 2015-12-25 10:08:20.848 YH-IOS[52214:1924885] http://izoom.mobi/demo/upload.html?userid=3026
 2015-12-25 10:08:27.117 YH-IOS[52214:1924885] Passed in type public.item doesn't conform to either public.content or public.data. If you are exporting a new type, please ensure that it conforms to an appropriate parent type.
 2015-12-25 10:08:27.189 YH-IOS[52214:1924885] the behavior of the UICollectionViewFlowLayout is not defined because:
 2015-12-25 10:08:27.190 YH-IOS[52214:1924885] the item width must be less than the width of the UICollectionView minus the section insets left and right values, minus the content insets left and right values.
 2015-12-25 10:08:30.497 YH-IOS[52214:1924885] Warning: Attempt to present <UIImagePickerController: 0x7f857a84b000> on <ChartViewController: 0x7f857b8daa60> whose view is not in the window hierarchy!
 *
 *  @return return value description
 */
-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if(self.presentedViewController) {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}
//#pragma mark - UIWebview delegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//        NSURL *url = [request URL];
//        if (![[url scheme] hasPrefix:@";file"] && ![[url relativeString] hasPrefix:@"http://222.76.27.51"]) {
//            [[UIApplication sharedApplication] openURL:url];
//            return NO;
//        }
//    }
//    
//    return YES;
//}
#pragma mark - UMSocialUIDelegate
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    @try {
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[kActionALCName]   = [NSString stringWithFormat:@"微信分享(%d)", fromViewControllerType];
        logParams[kObjIDALCName]    = self.objectID;
        logParams[kObjTypeALCName]  = @(self.commentObjectType);
        logParams[kObjTitleALCName] = self.bannerName;
        logParams[kScreenshotType] = ( betaDict[@"image_within_screen"] && [betaDict[@"image_within_screen"] boolValue]) ? @"screenIamge" : @"allImage";
        [APIHelper actionLog:logParams];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

// 下面得到分享完成的回调
// {
//    data = {
//        wxsession = "";
//    };
//    responseCode = 200;
//    responseType = 5;
//    thirdPlatformResponse = "<SendMessageToWXResp: 0x136479db0>";
//    viewControllerType = 3;
// }
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    @try {
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[kActionALCName]   = [NSString stringWithFormat:@"微信分享完成(%d)", response.viewControllerType];
        logParams[kObjIDALCName]    = self.objectID;
        logParams[kObjTypeALCName]  = @(self.commentObjectType);
        logParams[kObjTitleALCName] = self.bannerName;
        logParams[kScreenshotType] = ( betaDict[@"image_within_screen"] && [betaDict[@"image_within_screen"] boolValue]) ? @"screenIamge" : @"allImage";
        [APIHelper actionLog:logParams];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}
#pragma mark --UINaviagtionDelegate
//页面开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"start");
}
//页面完成加载时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self addWebViewJavascriptBridge];
    
    
    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.images.length"] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        
        if (response != 0) {
            
            for (int i=0; i<[response intValue]; i++) {
                [webView evaluateJavaScript:[NSString stringWithFormat:@"document.images[%d].style.maxWidth='100%'",i] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                    //                    NSLog(@"response1: %@ error: %@", response, error);
                }];
                [webView evaluateJavaScript:[NSString stringWithFormat:@"document.images[%d].style.height='auto'",i] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                    //                    NSLog(@"response2: %@ error: %@", response, error);
                }];
            }
            
        }
        //        NSLog(@"response0: %@ error: %@", response, error);
    }];
    
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '100%'" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //        NSLog(@"response3: %@ error: %@", response, error);
    }];
    
}
//页面加载错误时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%@",error);
}
//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//身份验证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    // 不要证书验证
    completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}





@end
