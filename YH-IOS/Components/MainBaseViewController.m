//
//  MainBaseViewController.m
//  YH-IOS
//
//  Created by li hao on 17/3/30.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MainBaseViewController.h"
#import "LoginViewController.h"
#import <PgyUpdate/PgyUpdateManager.h>
#import "AppDelegate.h"
#import "AFNetworking.h"
#import <SSZipArchive.h>
#import "Version.h"
#import "DropViewController.h"
#import "DropTableViewCell.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"
#import "NewSettingViewController.h"
#import "SettingViewController.h"

@interface MainBaseViewController ()<LTHPasscodeViewControllerDelegate,UINavigationControllerDelegate>

@end

@implementation MainBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Banner-Logo"]];
    imageView.contentMode =UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(self.view.frame.size.width/2-30, 0, 60, 40);
    [self.navigationController.navigationBar addSubview:imageView];
    self.user = [[User alloc] init];
    [self initDropMenu];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.sharedPath = [FileUtils sharedPath];
    if(self.user.userID) {
        self.assetsPath = [FileUtils dirPath:kHTMLDirName];
    }
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Banner-Setting"] style:UIBarButtonItemStylePlain target:self action:@selector(dropTableView:)];
}

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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [LTHPasscodeViewController sharedUser].delegate = self;
   // [LTHPasscodeViewController useKeychain:NO];
    //[LTHPasscodeViewController sharedUser].allowUnlockWithTouchID = NO;
}

- (void)initDropMenu {
    NSMutableArray *tmpTitles = [NSMutableArray array];
    NSMutableArray *tmpIcons = [NSMutableArray array];
    
    if(kDropMenuScan) {
        [tmpTitles addObject:kDropMentScanText];
        [tmpIcons addObject:@"DropMenu-Scan"];
    }
    
    if(kDropMenuVoice) {
        [tmpTitles addObject:kDropMentVoiceText];
        [tmpIcons addObject:@"DropMenu-Voice"];
    }
    
    if(kDropMenuSearch) {
        [tmpTitles addObject:kDropMentSearchText];
        [tmpIcons addObject:@"DropMenu-Search"];
    }
    
    if(kDropMenuUserInfo) {
        [tmpTitles addObject:kDropMentUserInfoText];
        [tmpIcons addObject:@"DropMenu-UserInfo"];
    }
    
    self.dropMenuTitles = [NSArray arrayWithArray:tmpTitles];
    self.dropMenuIcons = [NSArray arrayWithArray:tmpIcons];
}

#pragma mark - action methods

/**
 *  标题栏设置按钮点击显示下拉菜单
 *
 *  @param sender
 */
-(void)dropTableView:(UIBarButtonItem *)sender {
    DropViewController *dropTableViewController = [[DropViewController alloc]init];
    dropTableViewController.view.frame = CGRectMake(0, 0, 150, 150);
    dropTableViewController.preferredContentSize = CGSizeMake(150,self.dropMenuTitles.count*150/4);
    dropTableViewController.modalPresentationStyle = UIModalPresentationPopover;
    dropTableViewController.view.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    dropTableViewController.dropTableView.delegate = self;
    dropTableViewController.dropTableView.dataSource = self;
    UIPopoverPresentationController *popover = [dropTableViewController popoverPresentationController];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.barButtonItem = self.navigationItem.rightBarButtonItem;
    popover.delegate = self;
    [popover setSourceRect:sender.customView.frame];
    [popover setSourceView:self.view];
    popover.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    [self presentViewController:dropTableViewController animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

# pragma mark - UITableView Delgate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dropMenuTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DropTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dorpcell"];
    if (!cell) {
        cell = [[DropTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dorpcell"];
    }
    cell.tittleLabel.text = self.dropMenuTitles[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:self.dropMenuIcons[indexPath.row]];
    
    UIView *cellBackView = [[UIView alloc]initWithFrame:cell.frame];
    cellBackView.backgroundColor = [UIColor darkGrayColor];
    cell.selectedBackgroundView = cellBackView;
    cell.tittleLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150 / 4;
}


#pragma mark - action methods

/**
 *  标题栏设置按钮点击显示下拉菜单
 *
 *  @param sender
 */
-(void)dropTableView{
    DropViewController *dropTableViewController = [[DropViewController alloc]init];
    dropTableViewController.view.frame = CGRectMake(0, 0, 150, 150);
    dropTableViewController.modalPresentationStyle = UIModalPresentationPopover;
    dropTableViewController.view.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    //dropTableViewController.dropTableView.delegate = self;
    //dropTableViewController.dropTableView.dataSource =self;
    dropTableViewController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 150, 150);
    UIPopoverPresentationController *popover = [dropTableViewController popoverPresentationController];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
   // popover.delegate = self;
   // popover.barButtonItem = self.navigationItem.rightBarButtonItem;
    [popover setSourceRect:self.navigationItem.rightBarButtonItem.customView.frame];
    [popover setSourceView:self.view];
    popover.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    
    [self presentViewController:dropTableViewController animated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *itemName = self.dropMenuTitles[indexPath.row];
        
        if([itemName isEqualToString:kDropMentScanText]) {
            [self actionBarCodeScanView:nil];
        }
        else if([itemName isEqualToString:kDropMentVoiceText]) {
            [ViewUtils showPopupView:self.view Info:@"功能开发中，敬请期待"];
        }
        else if([itemName isEqualToString:kDropMentSearchText]) {
            [ViewUtils showPopupView:self.view Info:@"功能开发中，敬请期待"];
        }
        else if([itemName isEqualToString:kDropMentUserInfoText]) {
            NewSettingViewController *settingViewController = [[NewSettingViewController alloc]init];
            UINavigationController *userInfoViewControlller = [[UINavigationController alloc]initWithRootViewController:settingViewController];
            [self presentViewController:userInfoViewControlller animated:YES completion:nil];
        }
    }];
}


- (IBAction)actionBarCodeScanView:(UIButton *)sender {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if(!userDict[kStoreIDsCUName] || [userDict[kStoreIDsCUName] count] == 0) {
        [[[UIAlertView alloc] initWithTitle:kWarningTitleText message:kWarningNoStoreText delegate:nil cancelButtonTitle:kSureBtnText otherButtonTitles:nil] show];
        
        return;
    }
    
    if(![self cameraPemission]) {
        [[[UIAlertView alloc] initWithTitle:kWarningTitleText message:kWarningNoCaremaText delegate:nil cancelButtonTitle:kSureBtnText otherButtonTitles:nil] show];
        
        return;
    }
    
    [self qqStyle];
}


#pragma mark - LBXScan Delegate Methods

- (BOOL)cameraPemission {
    BOOL isHavePemission = NO;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }
    
    return isHavePemission;
}


#pragma mark - 扫描商品二维码（模仿qq界面）

- (void)qqStyle {
    //设置扫码区域参数设置
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    vc.isQQSimulator = YES;
    vc.isVideoZoom = YES;
    
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)clearBrowserCache {
    [self.browser stopLoading];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
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

#pragma mark - status bar settings
//- (BOOL)prefersStatusBarHidden {
//    return NO;
//}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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

#pragma mark - LTHPasscodeViewControllerDelegate methods

- (void)passcodeWasEnteredSuccessfully {
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
            
            NSString *msg = [APIHelper userAuthentication:userDict[kUserNumCUName] password:userDict[kPasswordCUName]];
            if(msg.length > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self jumpToLogin];
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




@end
