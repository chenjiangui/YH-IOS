//
//  JYHomeViewController.m
//  各种报表
//
//  Created by niko on 17/4/28.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYHomeViewController.h"
#import <PgyUpdate/PgyUpdateManager.h>

#import "JYDashboardModel.h"

#import "JYPagedFlowView.h"
#import "JYNotifyView.h"
#import "JYTopSinglePage.h"
#import "JYFallsView.h"
#import "SubjectViewController.h"
#import "HomeIndexVC.h"
#import "SuperChartVc.h"
#import "ViewUtils.h"
#import "HttpResponse.h"
#import "HttpUtils.h"
#import "ResetPasswordViewController.h"
#import "User.h"
#import "SDCycleScrollView.h"
#import "YHKPIModel.h"
#import "SubjectOutterViewController.h"

#import "YHHttpRequestAPI.h"
#import "RefreshTool.h"
#import "HomeScrollHeaderCell.h"
#import "HomeNavBarView.h"
#import "ManageWarningCell.h"
#import "CommonTableViewCell.h"
#import "BusinessGeneralCell.h"
#import "PermissionManager.h"
#import "SubLBXScanViewController.h"
#import "HomeNoticeMessageCell.h"
#import "ToolModel.h"
#import "Version.h"
#import "FileUtils+Assets.h"
#import <Reachability/Reachability.h>
#import "TestModel.h"
#import "NewSubjectViewController.h"


#define kJYNotifyHeight 40

@interface JYHomeViewController () <UITableViewDelegate, UITableViewDataSource, PagedFlowViewDelegate, PagedFlowViewDataSource, JYNotifyDelegate, JYFallsViewDelegate,SDCycleScrollViewDelegate,RefreshToolDelegate> {
    
}

@property (nonatomic, strong) UITableView *rootTBView;

@property (nonatomic, strong) User* user;

@property (nonatomic, strong) RefreshTool* reTool;

@property (nonatomic, strong) NSArray* dataList;

@property (nonatomic, strong) HomeNavBarView* navBarView;

@property (nonatomic, strong) ToolModel* noticeMessageModel;

@property (strong, nonatomic) NSString *localNotificationPath;

@property (nonatomic, strong) HudToolView* netBugView;

@property (strong, nonatomic) NSMutableDictionary *remoteDict;

@end

@implementation JYHomeViewController

- (RefreshTool *)reTool{
    if (!_reTool) {
        _reTool = [[RefreshTool alloc] initWithScrollView:self.rootTBView delegate:self down:YES top:NO];
    }
    return _reTool;
}

- (HomeNavBarView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[HomeNavBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _navBarView.hidden = YES;
        MJWeakSelf;
        _navBarView.scanBlock = ^(id item) {
            [weakSelf scanAction];
        };
    }
    return _navBarView;
}

- (HudToolView *)netBugView{
    if (!_netBugView) {
        _netBugView = [HudToolView showNetworkBug:YES view:self.view];
        _netBugView.hidden = YES;
        MJWeakSelf;
        _netBugView.touchBlock = ^(id item) {
            weakSelf.netBugView.contentView.hidden = YES;
            [weakSelf getData:YES];
        };
    }
    [self.view bringSubviewToFront:_netBugView];
    return _netBugView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.localNotificationPath = [FileUtils dirPath:kConfigDirName FileName:kLocalNotificationConfigFileName];
    self.fd_prefersNavigationBarHidden = YES;
    [self.view sd_addSubviews:@[self.rootTBView,self.navBarView]];
    [self.rootTBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    _user = [[User alloc]init];
    [self checkFromViewController];
    [self getData:YES];
    [self actionCheckAssets];
    [self showBottomTip:YES title:@"海量数据, 运筹帷幄" image:@"pic_1".imageFromSelf];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSString *pushConfigPath = [[FileUtils userspace] stringByAppendingPathComponent:@"receiveRemote"];
    if ([FileUtils checkFileExist:pushConfigPath isDir:NO]) {
        self.remoteDict = [[FileUtils readConfigFile:pushConfigPath] copy];
        NSLog(@"%@",_remoteDict);
        [self DealRemote];
        [FileUtils removeFile:pushConfigPath];
    }
}


-(void)DealRemote{
    NSString *remoteType = _remoteDict[@"type"];
    NSString *remoteState=_remoteDict[@"readState"];
    if ([remoteState isEqualToString:@"true"]) {
        if ([remoteType isEqualToString:@"kpi"]) {
            return;
        }
        else if ([remoteType isEqualToString:@"report"] && SafeText(_remoteDict[@"url"]).length > 0){
            [self jumpToDetailView:_remoteDict[@"url"] viewTitle:_remoteDict[@"title"]];
        }
        else if ([remoteType isEqualToString:@"message"]){
            self.tabBarController.selectedIndex = 3;
        }
        else if ([remoteType isEqualToString:@"analyse"]){
            self.tabBarController.selectedIndex = 1;
        }
        else if ([remoteType isEqualToString:@"app"]){
            self.tabBarController.selectedIndex = 2;
        }
        else{
            return;
        }
    }
    
}

- (UIInterfaceOrientationMask )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


-(void)jumpToDetailViewWithDict:(NSDictionary*)dict{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
    subjectView.bannerName =dict[@"title"];
    subjectView.link = dict[@"url"];
    subjectView.commentObjectType = [dict[@"obj_type"] intValue];
    subjectView.objectID = dict[@"obj_id"];
    
    UINavigationController *subjectCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
    [self presentViewController:subjectCtrl animated:YES completion:nil];
}


- (void)test{ //对项目无用 一个测试 cjg
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString* arrayStr = [data valueForKey:@"array"];
    arrayStr = [arrayStr removeString:@"["];
    NSArray* firstArray = [arrayStr componentsSeparatedByString:@"],"];
    NSMutableArray* strs = [NSMutableArray array];
    for (NSString* str in firstArray) {
        [strs addObject:[str removeString:@"]"]];
    }
    NSMutableArray* models = [NSMutableArray array];
    for (NSString* str in strs) {
        NSArray<NSString*>* values = [str componentsSeparatedByString:@","];
        TestModel* model = [[TestModel alloc] init];
        if (values.count>=3) {
            model.identifier = [[values[0] removeSpace] removeString:@"\"\""];
            model.fatherId = [[values[1] removeSpace] removeString:@"\"\""];
            for (int i = 2; i<values.count; i++) {
                [model.main_data addObject:values[i]];
            }
        }
        [models addObject:model];
    }
    NSMutableArray* copyModels = [NSMutableArray arrayWithArray:models];
    for (TestModel* copy in copyModels) {
        for (TestModel* trueModel in models) {
            if ([copy.fatherId isEqualToString:trueModel.identifier] && !IsEmptyText(copy.fatherId)) {
                [trueModel.sub_data addObject:copy];
                break;
            }
        }
    }
    NSMutableArray* sortArray = [NSMutableArray array];
    for (TestModel* model in models) {
        if (IsEmptyText(model.fatherId)) {
            [sortArray addObject:model];
        }
    }
    NSString* json = [TestModel mj_keyValuesArrayWithObjectArray:sortArray].mj_JSONString;
    json = [json removeSpace];
    DLog(@"结束");
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)refreshToolBeginDownRefreshWithScrollView:(UIScrollView *)scrollView tool:(RefreshTool *)tool{
    [self getData:false];
}


#pragma mark - 首页点击事件
//轮播图点击事件
- (void)scrollImageAction:(YHKPIDetailModel*)model{
    NSString *targetUrl = [NSString stringWithFormat:@"%@",model.targeturl];
    [self jumpToDetailView:targetUrl viewTitle:model.title];
}

//经营预警事件
- (void)manageWarningAction:(YHKPIDetailModel*)model{
    NSString *targetUrl = [NSString stringWithFormat:@"%@",model.targeturl];
    [self jumpToDetailView:targetUrl viewTitle:model.report_title];
}

//生意概况点击事件
- (void)businessAction:(YHKPIDetailModel*)model{
    NSString *targetUrl = [NSString stringWithFormat:@"%@",model.targeturl];
    [self jumpToDetailView:targetUrl viewTitle:model.title];
}

//消息公告点击事件
- (void)messageAction:(ToolModel*)model{
    self.tabBarController.selectedIndex = 3;
}


//扫描事件
- (void)scanAction{
    [[PermissionManager shareInstance] verifyCanPhoto:^(BOOL canPhoto) {
        [self presentViewController:[SubLBXScanViewController instance] animated:YES completion:nil];
    }];
}


/** 清理缓存*/
- (void)actionCheckAssets {
    NSDictionary *dict = @{
                           kAPI_TOEKN:ApiToken(YHAPI_STATIC_ASSETS_CHECK)
                           };
    [YHHttpRequestAPI yh_getDataFrom:YHAPI_STATIC_ASSETS_CHECK with:dict Finish:^(BOOL success, id model, NSString *jsonObjc) {
        if (success) {
            [self saveAseetsMD5:jsonObjc];
        }
    }];
}

-(void)saveAseetsMD5:(NSString*)jsonString {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    NSDictionary *dict = [self dictionaryWithJsonString:jsonString][@"data"];
    
    userDict[@"assets_md5"]        = SafeText(dict[@"assets_md5"]);
    userDict[@"loading_md5"]       = SafeText(dict[@"loading_md5"]);
    userDict[@"icons_md5"]         = SafeText(dict[@"icons_md5"]);
    userDict[@"images_md5"]        = SafeText(dict[@"images_md5"]);
    userDict[@"javascripts_md5"]   = SafeText(dict[@"javascripts_md5"]);
    userDict[@"stylesheets_md5"]   = SafeText(dict[@"stylesheets_md5"]);
    userDict[@"advertisement_md5"] = SafeText(dict[@"advertisement_md5"]);
    userDict[@"fonts_md5"]         = SafeText(dict[@"fonts_md5"]);
    
    NSString *settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kSettingConfigFileName];
    [userDict writeToFile:userConfigPath atomically:YES];
    [userDict writeToFile:settingsConfigPath atomically:YES];
    [self checkAssetsUpdate];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
   // op = [self checkAssetUpdate:kBarCodeScanAssetsName info:kBarCodeScanPopupText isInAssets: NO];
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
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseUrl, YHAPI_DOWNLOAD_STATIC_ASSETS]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kDownloadAssetsAPIPath, kBaseUrl, assetName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:ApiToken(YHAPI_DOWNLOAD_STATIC_ASSETS) forHTTPHeaderField:kAPI_TOEKN];
    [request addValue:[NSString stringWithFormat:@"%@%@",assetName,@".zip"] forHTTPHeaderField:@"filename"];
    // 保存路径
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
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


- (void)getNoticeData{
    [YHHttpRequestAPI yh_getHomeNoticeListFinish:^(BOOL success, ToolModel* model, NSString *jsonObjc) {
        if ([BaseModel handleResult:model]) {
            self.noticeMessageModel = model;
            dispatch_async_on_main_queue(^{
                if (self.rootTBView.numberOfSections > 0) {
                    [self.rootTBView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
                }
                
            });
        }
    }];
}

- (void)getData:(BOOL)loading{
    if (loading) {
        [HudToolView showLoadingInView:self.view];
    }
    [self getNoticeData];
    [YHHttpRequestAPI yh_getHomeDashboardFinish:^(BOOL success, NSArray<YHKPIModel *>* demolArray, NSString *jsonObjc) {
        self.netBugView.hidden = success;
        [self.reTool endDownPullWithReload:NO];
        [HudToolView hideLoadingInView:self.view];
        if (success && demolArray && jsonObjc) {
            self.dataList = demolArray;
            [self.rootTBView reloadData];
            self.navBarView.hidden = NO;
        }else{
            self.navBarView.hidden = YES;
        }
    }];
}

#pragma mark - < UITableViewDataSource>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat mj_offsetY = self.rootTBView.mj_offsetY;
    if (mj_offsetY<=0) {
        self.navBarView.top = -mj_offsetY;
        self.navBarView.backColorAlpha = 0;
    }else{
        self.navBarView.top = 0;
        if (mj_offsetY<=30) {
            self.navBarView.backColorAlpha = mj_offsetY/30.0;
        }else{
            self.navBarView.backColorAlpha = 1;
        }
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        YHKPIModel* model = [NSArray getObjectInArray:self.dataList keyPath:@"group_name" equalValue:@"生意概况"];
        return model.data.count ? model.data.count+1:0;
    }
    if (section == 0) {
        return self.noticeMessageModel.data.count ? 2:1;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 55;
        }
        return [BusinessGeneralCell heightForSelf];
    }
    if (indexPath.section==0 && indexPath.row == 1) {
        return 40;
    }
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:tableView];
}


#pragma mark - <UITableViewDelegate>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJWeakSelf;
    if (indexPath.section == 0) { // top 轮播
        if (indexPath.row == 0) {
            HomeScrollHeaderCell* cell = [HomeScrollHeaderCell cellWithTableView:tableView needXib:YES];
            YHKPIModel* model = [NSArray getObjectInArray:self.dataList keyPath:@"group_name" equalValue:@"top_data"];
            [cell setItem:model];
            cell.clickBlock = ^(NSNumber* item) {
                [weakSelf scrollImageAction:model.data[item.integerValue]];
            };
            return cell;
        }else{
            HomeNoticeMessageCell* cell = [HomeNoticeMessageCell cellWithTableView:tableView needXib:NO];
            [cell setItem:self.noticeMessageModel];
            cell.selectBlock = ^(id item) {
                [weakSelf messageAction:item];
            };
            return cell;
        }
    }
    if (indexPath.section == 1) {
        ManageWarningCell* cell = [ManageWarningCell cellWithTableView:tableView needXib:YES];
        YHKPIModel* model = [NSArray getObjectInArray:self.dataList keyPath:@"group_name" equalValue:@"经营预警"];
        [cell setItem:model];
        cell.clickBlock = ^(YHKPIDetailModel* item) {
            [weakSelf manageWarningAction:item];
        };
        return cell;
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            CommonTableViewCell* cell = [CommonTableViewCell cellWithTableView:tableView needXib:NO];
            [cell setTitleStyle:YES];
            cell.leftLab.font = [UIFont boldSystemFontOfSize:16];
            cell.leftLab.text = @"生意概况";
            return cell;
        }else{
            BusinessGeneralCell* cell = [BusinessGeneralCell cellWithTableView:tableView needXib:YES];
            YHKPIModel* model = [NSArray getObjectInArray:self.dataList keyPath:@"group_name" equalValue:@"生意概况"];
            YHKPIDetailModel* detail = model.data[indexPath.row-1];
            [cell setItem:detail];
            return cell;
        }
    }
    return [UITableViewCell new];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (indexPath.row != 0) {
            YHKPIModel* model = [NSArray getObjectInArray:self.dataList keyPath:@"group_name" equalValue:@"生意概况"];
            YHKPIDetailModel* detail = model.data[indexPath.row-1];
            [self businessAction:detail];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == tableView.numberOfSections-1 && tableView.numberOfSections) {
        return 80;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
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
    if (self.navigationController && self.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (UIScrollView *)rootTBView {
    
    if (!_rootTBView) {
        //给通知视图预留40height
        _rootTBView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, JYVCWidth, self.view.frame.size.height) style:UITableViewStylePlain];
        _rootTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rootTBView.showsVerticalScrollIndicator = NO;
        _rootTBView.dataSource = self;
        _rootTBView.delegate = self;
        _rootTBView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _rootTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rootTBView.backgroundColor = [UIColor clearColor];
    }
    return _rootTBView;
}


/*
 * 解屏进入主页面，需检测版本更新
 */
- (void)checkFromViewController {
    // 检测版本更新
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyerAppId];
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(appToUpgradeMethod:)];
    
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
             *  若难失败，则在下次解屏检测时进入登录界面
             */
            NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
            NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
            if(!userDict[kUserNumCUName]) {
                return;
            }
            NSString *userlocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERLOCATION"];
           /* NSString *msg = [APIHelper userAuthentication:userDict[kUserNumCUName] password:userDict[kPasswordCUName] coordinate:userlocation];
            if(msg.length != 0) {
                userDict[kIsLoginCUName] = @(NO);
                [userDict writeToFile:userConfigPath atomically:YES];
            }*/
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}

# pragma mark - assitant methods
/**
 *  内容检测版本升级，判断版本号是否为偶数。以便内测
 *
 *  @param response <#response description#>
 */
- (void)appToUpgradeMethod:(NSDictionary *)response {
    if(!response || !response[kDownloadURLCPCName] || !response[kVersionCodeCPCName] || !response[kVersionNameCPCName]) {
        return;
    }
    NSString *pgyerVersionPath = [[FileUtils basePath] stringByAppendingPathComponent:kPgyerVersionConfigFileName];
    [FileUtils writeJSON:[NSMutableDictionary dictionaryWithDictionary:response] Into:pgyerVersionPath];
    
    Version *version = [[Version alloc] init];
    NSInteger currentVersionCode = [version.build integerValue];
    NSInteger responseVersionCode = [response[kVersionCodeCPCName] integerValue];
    
    // 对比 build 值，只准正向安装提示
    if(responseVersionCode <= currentVersionCode) {
        return;
    }
    
    NSMutableDictionary *localNotificationDict = [FileUtils readConfigFile:self.localNotificationPath];
    localNotificationDict[kSettingPgyerLNName] = @(1);
    [FileUtils writeJSON:localNotificationDict Into:self.localNotificationPath];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if(responseVersionCode % 2 == 0) {
        if (responseVersionCode % 10 == 8 && [reach isReachableViaWiFi]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"重大改动，请升级" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:[kPgyerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                [[UIApplication sharedApplication] openURL:url];
                [self exitApplication];
            }];
            
            [alertVC addAction:action1];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert addButton:kUpgradeBtnText actionBlock:^(void) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[kDownloadURLCPCName]]];
                [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
            }];
            
            NSString *subTitle = [NSString stringWithFormat:kUpgradeWarnText, response[kVersionNameCPCName], response[kVersionCodeCPCName]];
            [alert showSuccess:self title:kUpgradeTitleText subTitle:subTitle closeButtonTitle:kCancelBtnText duration:0.0f];
        }
    }
}


- (void)exitApplication {
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];    
}


-(void)noteToChangePwd{
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    if ([userDict[@"password_md5"] isEqualToString:@"123456".md5]) {
        [alert addButton:@"稍后修改" actionBlock:^(void) {
        }];
        [alert addButton:@"立即修改" actionBlock:^(void) {
            [self ResetPassword];
        }];
        [alert showSuccess:self title:@"温馨提示" subTitle:@"安全起见，请在【个人信息】-【基本信息】-【修改登录密码】页面修改初始密码" closeButtonTitle:nil duration:0.0f];
    }
}

// 修改密码
- (void)ResetPassword {
    ResetPasswordViewController *resertPwdViewController = [[ResetPasswordViewController alloc]init];
    resertPwdViewController.title = @"修改密码";

    
    UINavigationController *reserPwdCtrl = [[UINavigationController alloc]initWithRootViewController:resertPwdViewController];
    [self.navigationController presentViewController:reserPwdCtrl animated:YES completion:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"点击/设置页面/修改密码";
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
}

-(void)jumpToDetailView:(NSString*)targeturl viewTitle:(NSString*)title{
    NSArray *urlArray = [targeturl componentsSeparatedByString:@"/"];
    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
    if ([targeturl isEqualToString:@""] || targeturl == nil) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"该功能正在开发中"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        BOOL isInnerLink = !([targeturl hasPrefix:@"http://"] || [targeturl hasPrefix:@"https://"]);
       if ([targeturl rangeOfString:@"template/3/"].location != NSNotFound) {
          HomeIndexVC *vc = [[HomeIndexVC alloc] init];
          vc.bannerTitle = title;
          vc.dataLink = targeturl;
           vc.objectID =[urlArray lastObject];
          vc.commentObjectType = ObjectTypeAnalyse;
          UINavigationController *rootchatNav = [[UINavigationController alloc]initWithRootViewController:vc];
           logParams[kActionALCName]   = @"点击/生意概况/报表";
           logParams[kObjIDALCName]    = [NSString stringWithFormat:@"%@",[urlArray lastObject]];
           logParams[kObjTypeALCName]  = @(ObjectTypeKpi);
           logParams[kObjTitleALCName] =  title;
           /*
            * 用户行为记录, 单独异常处理，不可影响用户体验
            */
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               @try {
                   [APIHelper actionLog:logParams];
               }
               @catch (NSException *exception) {
                   NSLog(@"%@", exception);
               }
           });

          [self presentViewController:rootchatNav animated:YES completion:nil];
        
     }
     else if ([targeturl rangeOfString:@"template/5/"].location != NSNotFound) {
         SuperChartVc *superChaerCtrl = [[SuperChartVc alloc]init];
         superChaerCtrl.bannerTitle = title;
         superChaerCtrl.dataLink = targeturl;
         superChaerCtrl.objectID =[urlArray lastObject];
         superChaerCtrl.commentObjectType = ObjectTypeKpi;
         UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:superChaerCtrl];
         logParams[kActionALCName]   = @"点击/生意概况/报表";
         logParams[kObjIDALCName]    = [NSString stringWithFormat:@"%@",[urlArray lastObject]];
         logParams[kObjTypeALCName]  = @(ObjectTypeKpi);
         logParams[kObjTitleALCName] =  title;
         /*
          * 用户行为记录, 单独异常处理，不可影响用户体验
          */
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             @try {
                 [APIHelper actionLog:logParams];
             }
             @catch (NSException *exception) {
                 NSLog(@"%@", exception);
             }
         });

         [self presentViewController:superChartNavCtrl animated:YES completion:nil];
     }
       else if ([targeturl rangeOfString:@"whatever/group/1/original/kpi"].location != NSNotFound){
          JYHomeViewController *jyHome = [[JYHomeViewController alloc]init];
          jyHome.bannerTitle = title;
          jyHome.dataLink = targeturl;
          UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:jyHome];
           
          [self presentViewController:superChartNavCtrl animated:YES completion:nil];
      }
      else{ //跳转事件
          if (isInnerLink) {
              logParams[kActionALCName]   = @"点击/生意概况/报表";
              logParams[kObjIDALCName]    = [NSString stringWithFormat:@"%@",[urlArray lastObject]];
              logParams[kObjTypeALCName]  = @(ObjectTypeKpi);
              logParams[kObjTitleALCName] =  title;
              /*
               * 用户行为记录, 单独异常处理，不可影响用户体验
               */
              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  @try {
                      [APIHelper actionLog:logParams];
                  }
                  @catch (NSException *exception) {
                      NSLog(@"%@", exception);
                  }
              });
              if (YHAPPVERSION >= 9.0) {
                  NewSubjectViewController *subjectView =[[NewSubjectViewController alloc] init];
                  subjectView.title =title;
                  subjectView.bannerName = title;
                  subjectView.link = targeturl;
                  subjectView.commentObjectType = ObjectTypeKpi;
                  subjectView.objectID = [urlArray lastObject];
                  UINavigationController *subCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
                  [self.navigationController presentViewController:subCtrl animated:YES completion:nil];
              }
              else{
              UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
              
              SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
              subjectView.bannerName =title;
              subjectView.link = targeturl;
              subjectView.commentObjectType = ObjectTypeKpi;
              subjectView.objectID = [urlArray lastObject];
              UINavigationController *subCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
              [self.navigationController presentViewController:subCtrl animated:YES completion:nil];
              }
          }
          else{
              logParams[kActionALCName]   = @"点击/生意概况/链接";
              logParams[kObjIDALCName]    = [NSString stringWithFormat:@"%@",[urlArray lastObject]];
              logParams[kObjTypeALCName]  = @(ObjectTypeKpi);
              logParams[kObjTitleALCName] =  title;
              /*
               * 用户行为记录, 单独异常处理，不可影响用户体验
               */
              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  @try {
                      [APIHelper actionLog:logParams];
                  }
                  @catch (NSException *exception) {
                      NSLog(@"%@", exception);
                  }
              });

              SubjectOutterViewController *subjectView = [[SubjectOutterViewController alloc]init];
              subjectView.bannerName = title;
              subjectView.link = targeturl;
              subjectView.commentObjectType = ObjectTypeKpi;
              subjectView.objectID = [urlArray lastObject];
              [self.navigationController presentViewController:subjectView animated:YES completion:nil];
          }
      }
    }
}

@end




