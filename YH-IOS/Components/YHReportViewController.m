//
//  YHReportViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/15.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHReportViewController.h"
#import "YHMutileveMenu.h"
#import "ListPage.h"
#import "SubjectViewController.h"
#import "User.h"
#import "HomeIndexVC.h"
#import "SuperChartVc.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"
#import "YHScanStoreViewController.h"
#import "SubjectOutterViewController.h"
#import "JYDemoViewController.h"
#import "RefreshTool.h"
#import "NewSubjectViewController.h"

@interface YHReportViewController () <RefreshToolDelegate>
{
    NSMutableArray * _list;
    User *user;
}

@property (nonatomic, strong)NSArray<ListPageList *> *listArray;
@property (nonatomic, strong)YHMutileveMenu *menuView ;
//@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) RefreshTool* reTool;

@end

@implementation YHReportViewController

- (RefreshTool *)reTool{
    if (!_reTool) {
        _reTool = [[RefreshTool alloc] initWithScrollView:self.menuView.rightCollection delegate:self down:true top:false];
    }
    return _reTool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.tabBarController.tabBar.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9f"];
    //self.navigationController.navigationBar.backgroundColor =[UIColor colorWithHexString:@"#f9f9f9f"];
    _list = [NSMutableArray new];
    
   // [self initCategoryMenu];
     self.view.backgroundColor = [UIColor colorWithHexString:@"#f7fef5"];
    self.automaticallyAdjustsScrollViewInsets = NO;
   // [self getdata];
    [self addMuneView];
     self.title = @"报表";
    [self getData:true];
    
    // Do any additional setup after loading the view.
}

- (void)refreshToolBeginDownRefreshWithScrollView:(UIScrollView *)scrollView tool:(RefreshTool *)tool{
    [self getData:false];
}

- (void)getData:(BOOL)loading{
    if (loading) {
        [HudToolView showLoadingInView:self.view];
    }
    [self getSomeThingNew];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Barcode-Scan-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(jumpToScanView)];
}

-(void)addMuneView {
     __weak typeof(*&self) weakSelf = self;
    _menuView  = [[YHMutileveMenu alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) WithData:_listArray withSelectIndex:^(NSInteger left, NSInteger right, ListItem* info) {
        // NSLog(@"%@",info);
        
        [weakSelf jumpToSubjectView:info];
    }];
    _menuView.needToScorllerIndex = 0;
    _menuView.leftSelectBgColor = [UIColor whiteColor];
    _menuView.isRecordLastScroll = NO;
    [weakSelf.view addSubview:_menuView];
    
//    _refreshControl = [[UIRefreshControl alloc] init];
//    
//    [_refreshControl addTarget:weakSelf
//     
//                        action:@selector(getSomeThingNewRefresh)
//     
//              forControlEvents:UIControlEventValueChanged];
//    
//    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] init]];
//    
//    [weakSelf.menuView.rightCollection addSubview:_refreshControl];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCategoryMenu {
    self.menuView.allData = _listArray;
//    [self.refreshControl endRefreshing];
    [self.menuView reloadData];
}


-(void)jumpToSubjectView:(ListItem *)item {
    __weak typeof(*&self) weakSelf = self;
    NSString *targeturl = item.linkPath;
       NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
  //  NSArray *urlArray = [targeturl componentsSeparatedByString:@"/"];
    if ([targeturl isEqualToString:@""] || targeturl == nil) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"该功能正在开发中"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }
    else{
        BOOL isInnerLink = !([targeturl hasPrefix:@"http://"] || [targeturl hasPrefix:@"https://"]);
        if ([targeturl rangeOfString:@"template/3/"].location != NSNotFound) {
            HomeIndexVC *vc = [[HomeIndexVC alloc] init];
            vc.bannerTitle = item.report_title;
            vc.dataLink = targeturl;
            vc.objectID =@(item.itemID);
            vc.commentObjectType = ObjectTypeAnalyse;
            UINavigationController *rootchatNav = [[UINavigationController alloc]initWithRootViewController:vc];
            logParams[kActionALCName]   = @"点击/报表/报表";
            logParams[kObjIDALCName]    = @(item.itemID);
            logParams[kObjTypeALCName]  = @(ObjectTypeAnalyse);
            logParams[kObjTitleALCName] =  item.listName;
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
            [weakSelf presentViewController:rootchatNav animated:YES completion:nil];
            
        }
        else if ([targeturl rangeOfString:@"template/5/"].location != NSNotFound) {
            SuperChartVc *superChaerCtrl = [[SuperChartVc alloc]init];
            superChaerCtrl.bannerTitle = item.report_title;
            superChaerCtrl.dataLink = targeturl;
            superChaerCtrl.objectID =@(item.itemID);
            superChaerCtrl.commentObjectType = ObjectTypeAnalyse;
            UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:superChaerCtrl];
            logParams[kActionALCName]   = @"点击/报表/报表";
            logParams[kObjIDALCName]    = @(item.itemID);
            logParams[kObjTypeALCName]  = @(ObjectTypeAnalyse);
            logParams[kObjTitleALCName] =  item.report_title;
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

            [weakSelf presentViewController:superChartNavCtrl animated:YES completion:nil];
        }
        /* else if ([data[@"link"] rangeOfString:@"template/"].location != NSNotFound){
         if ([data[@"link"] rangeOfString:@"template/5/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/1/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/2/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/3/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/4/"].location == NSNotFound) {
         SCLAlertView *alert = [[SCLAlertView alloc] init];
         [alert addButton:@"下一次" actionBlock:^(void) {}];
         [alert addButton:@"立刻升级" actionBlock:^(void) {
         NSURL *url = [NSURL URLWithString:[kPgyerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
         [[UIApplication sharedApplication] openURL:url];
         }];
         [alert showSuccess:self title:@"温馨提示" subTitle:@"您当前的版本暂不支持该模块，请升级之后查看" closeButtonTitle:nil duration:0.0f];
         }
         }*/
        else if ([targeturl rangeOfString:@"whatever/group/1/original/kpi"].location != NSNotFound){
          //  JYHomeViewController *jyHome = [[JYHomeViewController alloc]init];
            //jyHome.bannerTitle = title;
            //jyHome.dataLink = targeturl;
           // UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:jyHome];
           // [self presentViewController:superChartNavCtrl animated:YES completion:nil];
        }
        else if ([targeturl rangeOfString:@"template/1/"].location != NSNotFound) {
            JYDemoViewController *superChaerCtrl = [[JYDemoViewController alloc]init];
            superChaerCtrl.title = item.report_title;
            superChaerCtrl.urlLink = targeturl;
            // UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:superChaerCtrl];
            logParams[kActionALCName]   = @"点击/专题/报表";
            logParams[kObjIDALCName]    = @(item.itemID);
            logParams[kObjTypeALCName]  = @(ObjectTypeApp);
            logParams[kObjTitleALCName] =  item.report_title;
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
            [RootNavigationController pushViewController:superChaerCtrl animated:YES hideBottom:YES];
        }

        else{ //跳转事件
            
            
            if (YHAPPVERSION>=9.0) {                
                if (isInnerLink) {
                    logParams[kActionALCName]   = @"点击/报表/报表";
                    logParams[kObjIDALCName]    = @(item.itemID);
                    logParams[kObjTypeALCName]  = @(ObjectTypeAnalyse);
                    logParams[kObjTitleALCName] =  item.report_title;
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
                    NewSubjectViewController *subjectView =[[NewSubjectViewController alloc] init];
                    subjectView.bannerName = item.report_title;
                    subjectView.link = targeturl;
                    subjectView.commentObjectType = ObjectTypeAnalyse;
                    subjectView.objectID = @(item.itemID);
                    UINavigationController *subCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
                    [weakSelf.navigationController presentViewController:subCtrl animated:YES completion:nil];
                }
                else{
                    logParams[kActionALCName]   = @"点击/报表/链接";
                    logParams[kObjIDALCName]    = @(item.itemID);
                    logParams[kObjTypeALCName]  = @(ObjectTypeAnalyse);
                    logParams[kObjTitleALCName] =  item.report_title;
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
                    subjectView.bannerName = item.report_title;
                    subjectView.link = targeturl;
                    subjectView.commentObjectType = ObjectTypeAnalyse;
                    subjectView.objectID = @(item.itemID);
                    //UINavigationController *subCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
                    
                    [weakSelf.navigationController presentViewController:subjectView animated:YES completion:nil];
                }
            }
            else
            {
                if (isInnerLink) {
                    logParams[kActionALCName]   = @"点击/报表/报表";
                    logParams[kObjIDALCName]    = @(item.itemID);
                    logParams[kObjTypeALCName]  = @(ObjectTypeAnalyse);
                    logParams[kObjTitleALCName] =  item.report_title;
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
                    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
                    subjectView.bannerName = item.report_title;
                    subjectView.link = targeturl;
                    subjectView.commentObjectType = ObjectTypeAnalyse;
                    subjectView.objectID = @(item.itemID);
                    UINavigationController *subCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
                    [weakSelf.navigationController presentViewController:subCtrl animated:YES completion:nil];
                }
                else{
                    logParams[kActionALCName]   = @"点击/报表/链接";
                    logParams[kObjIDALCName]    = @(item.itemID);
                    logParams[kObjTypeALCName]  = @(ObjectTypeAnalyse);
                    logParams[kObjTitleALCName] =  item.report_title;
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
                    subjectView.bannerName = item.report_title;
                    subjectView.link = targeturl;
                    subjectView.commentObjectType = ObjectTypeAnalyse;
                    subjectView.objectID = @(item.itemID);
                    //UINavigationController *subCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
                    
                    [weakSelf.navigationController presentViewController:subjectView animated:YES completion:nil];
                }

            }
        }
    }
}

-(void)jumpToScanView {
   // [self jumpToStoreScan];
    [self actionBarCodeScanView:nil];
}

-(void)jumpToStoreScan{
    JYDemoViewController *scanStore = [[JYDemoViewController alloc]init];
    [self.navigationController pushViewController:scanStore animated:YES];
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
    [self presentViewController:[SubLBXScanViewController instance] animated:YES completion:nil];
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


-(void)getSomeThingNew {
    user = [[User alloc]init];
    NSString *kpiUrl =  [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_REPORT];
    NSDictionary *param = @{@"api_token":ApiToken(YHAPI_REPORT),@"group_id":SafeText(user.groupID),@"role_id":SafeText(user.roleID)};
    NSString *javascriptPath = [[FileUtils userspace] stringByAppendingPathComponent:@"HTML"];
    NSString*fileName =  @"home_report";
    
    javascriptPath = [javascriptPath stringByAppendingPathComponent:fileName];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kpiUrl
      parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
          [self.reTool endDownPullWithReload:false];
          [HudToolView hideLoadingInView:self.view];
        NSArray<ListPageList*> *array= [MTLJSONAdapter modelsOfClass:ListPageList.class fromJSONArray:responseObject[@"data"] error:nil];
          self.listArray = [array copy];
          [self initCategoryMenu];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [self.reTool endDownPullWithReload:false];
          [HudToolView hideLoadingInView:self.view];
          [HudToolView showTopWithText:@"请求失败" color:[NewAppColor yhapp_11color]];
      }];
}



@end
