//
//  ScanResultViewController.m
//  YH-IOS
//
//  Created by lijunjie on 16/06/07.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "ScanResultViewController.h"
#import "APIHelper.h"
#import "SelectStoreViewController.h"

static NSString *const kReportSelectorSegueIdentifier = @"ToReportSelectorSegueIdentifier";

@interface ScanResultViewController() <UINavigationBarDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintBannerView;
@property (strong, nonatomic) NSString *htmlContent;
@property (strong, nonatomic) NSString *htmlPath;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  被始化页面样式
     */
    [self idColor];
    self.bannerView.backgroundColor = [UIColor colorWithHexString:kBannerBgColor];
    self.labelTheme.textColor = [UIColor colorWithHexString:kBannerTextColor];
    
    self.htmlPath = [FileUtils sharedDirPath:kBarCodeScanFolderName FileName:kBarCodeScanFileName];
    self.htmlContent = [NSString stringWithContentsOfFile:self.htmlPath encoding:NSUTF8StringEncoding error:nil];

    [self.selectBtn addTarget:self action:@selector(actionJumpToSelectStoreViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self loadHtml];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
}

- (void)dealloc {
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
}

#pragma mark - assistant methods
- (void)loadHtml {
    DeviceState deviceState = [APIHelper deviceState];
    if(deviceState == StateOK) {
        [self _loadHtml];
    }
    else if(deviceState == StateForbid) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:kIAlreadyKnownText actionBlock:^(void) {
            [self jumpToLogin];
        }];
        
        [alert showError:self title:kWarmTitleText subTitle:kAppForbiedUseText closeButtonTitle:nil duration:0.0f];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading:LoadingRefresh];
        });
    }
}

- (void)_loadHtml {
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
    
    NSString *cacheJsonPath = [FileUtils dirPath:kCachedDirName FileName:kBarCodeResultFileName];
    NSMutableDictionary *cacheDict = [FileUtils readConfigFile:cacheJsonPath];
    
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    NSString *storeID = @"-1";
    if ((!cacheDict[@"store"] || !cacheDict[@"store"][@"id"]) &&
        userDict[kStoreIDsCUName] && [userDict[kStoreIDsCUName] count] > 0) {
        
        cacheDict[@"store"] = userDict[kStoreIDsCUName][0];
        [FileUtils writeJSON:cacheDict Into:cacheJsonPath];
    }
    storeID = cacheDict[@"store"][@"id"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APIHelper barCodeScan:self.user.userNum group:self.user.groupID role:self.user.roleID store:storeID code:self.codeInfo type:self.codeType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            [self.browser loadHTMLString:[self htmlContentWithTimestamp] baseURL:[NSURL fileURLWithPath:self.htmlPath]];
        });
    });
}

- (void)actionJumpToSelectStoreViewController {
    SelectStoreViewController *select = [[SelectStoreViewController alloc] init];
    [self presentViewController:select animated:YES completion:nil];
}

- (NSString *)htmlContentWithTimestamp {
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000 + arc4random()];
    NSString *newHtmlContent = [self.htmlContent stringByReplacingOccurrencesOfString:@"TIMESTAMP" withString:timestamp];

    return newHtmlContent;
}

#pragma mark - ibaction block
- (IBAction)actionBack:(id)sender {
    [super dismissViewControllerAnimated:YES completion:^{
        [self.browser stopLoading];
        [self.browser cleanForDealloc];
        self.browser.delegate = nil;
        self.browser = nil;
        [self.progressHUD hide:YES];
        self.progressHUD = nil;
        self.bridge = nil;
    }];
}
@end
