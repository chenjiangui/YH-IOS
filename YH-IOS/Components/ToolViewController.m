//
//  ToolViewController.m
//  YH-IOS
//
//  Created by cjg on 2017/7/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "ToolViewController.h"
#import "OneImageAndLabCell.h"
#import "YHHttpRequestAPI.h"
#import "RefreshTool.h"
#import "ToolModel.h"
#import "HomeIndexVC.h"
#import "SubjectViewController.h"
#import "SubjectOutterViewController.h"
#import "SuperChartVc.h"
#import "JYDemoViewController.h"
#import "YHScreenController.h"
#import "NewSubjectViewController.h"
#import "TemplateSixViewController.h"
#import "SubLBXScanViewController.h"
#import <LBXScan/LBXScanView.h>
#import <LBXScan/LBXScanResult.h>

@interface ToolViewController () <UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UICollectionView* collection;

@property (nonatomic, strong) RefreshTool* reTool;

@property (nonatomic, strong) NSArray* dataList;

@end

@implementation ToolViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工具箱";
    [self setupUI];
    [self getData:true];
    [self showBottomTip:YES title:@"年轻不留白" image:@"pic_4".imageFromSelf];
}

#pragma mark - RefreshToolDelegate

- (void)refreshToolBeginDownRefreshWithScrollView:(UIScrollView *)scrollView tool:(RefreshTool *)tool{
    [self getData:false];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OneImageAndLabCell* cell = [OneImageAndLabCell cellWithCollctionView:collectionView needXib:YES IndexPath:indexPath];
    ToolModel* model = _dataList[indexPath.row];
    [cell.imageV sd_setImageWithURL:model.icon_link.mj_url placeholderImage:DEFAULT_IMAGE];
    cell.contentLab.text = model.name;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ToolModel* model = _dataList[indexPath.row];
    [self toolClickAction:model];
}

#pragma mark - even response

// 获取数据
- (void)getData:(BOOL)loading{
    if (loading) {
        [HudToolView showLoadingInView:self.view];
    }
    [YHHttpRequestAPI yh_getToolListFinish:^(BOOL success, ToolModel* model, NSString *jsonObjc) {
        [HudToolView hideLoadingInView:self.view];
        [self.reTool endDownPullWithReload:false];
        if ([BaseModel handleResult:model]) {
            self.dataList = model.data;
            [self.collection reloadData];
        }else{

        }
        [HudToolView showNetworkBug:!([BaseModel handleResult:model]||self.dataList.count) view:self.view].touchBlock = ^(id item) {
            [self getData:YES];
        };
    }];
}

// 点击事件
- (void)toolClickAction:(ToolModel*)model{
   /* YHScreenController* vc = [[YHScreenController alloc] init];
    [self p8/ushViewController:vc animation:YES hideBottom:YES];
    return;*/
    [self jumpToDetailView:model];
}


#pragma mark - private event

-(void)jumpToDetailView:(ToolModel*)model{
    NSString *templateType = model.template_id;
    int templateId = [templateType intValue];
    switch (templateId) {
        case -1:
            NSLog(@"原生模版");
            [self jumptoOutterView:model];
            break;
        case 1:
            NSLog(@"模版一");
            [self jumpToTemplateOneView:model];
            break;
        case 2:
            NSLog(@"模版二");
            [self jumpToTemplateTwoView:model];
            break;
        case 3:
            NSLog(@"模版三");
            [self jumpToTemplateThreeView:model];
            break;
        case 4:
            NSLog(@"模版4");
            [self jumpToTemplateFourView:model];
            break;
        case 5:
            NSLog(@"模版5");
            [self jumpToTemplateFiveView:model];
            break;
        case 6:
            NSLog(@"模版6");
            [self jumpToTemplateSixView:model];
            break;
        case -2:
            NSLog(@"睿商的新增功能");
            [self jumpToScanView:model];
            break;
            
        default:
            NSLog(@"不再模版中");
            break;
    }
    
}

// 跳转到扫码页面
-(void)jumpToScanView:(ToolModel *)model{
    if ([model.name isEqualToString:@"帮助"]) {
        [self jumptoOutterView:model];
    }
    else if ([model.name isEqualToString:@"券核销"]) {
        [[NSUserDefaults standardUserDefaults] setObject:model.obj_link forKey:@"SCANTOOLMODEL"];
        [self jumpToScanView:model];
    }
}

- (void)actionBarCodeScanView:(ToolModel *)model {
    if(![self cameraPemission]) {
        [[[UIAlertView alloc] initWithTitle:kWarningTitleText message:kWarningNoCaremaText delegate:nil cancelButtonTitle:kSureBtnText otherButtonTitles:nil] show];
        return;
    }
    SubLBXScanViewController *SubLBXScanViewCtrl = [SubLBXScanViewController instance];
    SubLBXScanViewCtrl.model = model;
    [self presentViewController:SubLBXScanViewCtrl animated:YES completion:nil];
}

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


// 跳到外部链接原生模版
-(void)jumptoOutterView:(ToolModel *)model{
    
    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
    logParams[kActionALCName]   = @"点击/生意概况/链接";
    logParams[kObjIDALCName]    = SafeText(model.obj_id);
    logParams[kObjTypeALCName]  = @(ObjectTypeKpi);
    logParams[kObjTitleALCName] =  SafeText(model.obj_title);
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
    subjectView.bannerName = SafeText(model.obj_title);
    subjectView.link = SafeText(model.obj_link);
    subjectView.commentObjectType = ObjectTypeKpi;
    subjectView.objectID = SafeText(model.obj_id);
    [self.navigationController presentViewController:subjectView animated:YES completion:nil];
}


// 跳到模版一
-(void)jumpToTemplateOneView:(ToolModel *)model{
    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
    JYDemoViewController *superChaerCtrl = [[JYDemoViewController alloc]init];
    superChaerCtrl.title = SafeText(model.obj_title);
    superChaerCtrl.urlLink = SafeText(model.obj_link);
    logParams[kActionALCName]   = @"点击/专题/报表";
    logParams[kObjIDALCName]    = model.obj_id;
    logParams[kObjTypeALCName]  = @(ObjectTypeApp);
    logParams[kObjTitleALCName] =  model.obj_title;
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

// 跳到模版二
-(void)jumpToTemplateTwoView:(ToolModel *)model{
    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
    if (YHAPPVERSION >= 9.0) {
        NewSubjectViewController *subjectView =[[NewSubjectViewController alloc] init];
        subjectView.title = SafeText(model.obj_title);
        subjectView.bannerName = SafeText(model.obj_title);
        subjectView.link = SafeText(model.obj_link);
        subjectView.commentObjectType = ObjectTypeKpi;
        subjectView.objectID = SafeText(model.obj_id);
        UINavigationController *subCtrl = [[UINavigationController alloc] initWithRootViewController:subjectView];
        [RootTabbarViewConTroller presentViewController:subCtrl animated:YES completion:nil];
    }
    else{
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
        subjectView.bannerName =SafeText(model.obj_title);
        subjectView.link = SafeText(model.obj_link);
        subjectView.commentObjectType = ObjectTypeKpi;
        subjectView.objectID = SafeText(model.obj_id);
        UINavigationController *subCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
        [self.navigationController presentViewController:subCtrl animated:YES completion:nil];
    }
    logParams[kActionALCName]   = @"点击/生意概况/报表";
    logParams[kObjIDALCName]    = SafeText(model.obj_id);
    logParams[kObjTypeALCName]  = @(ObjectTypeKpi);
    logParams[kObjTitleALCName] =  SafeText(model.obj_title);
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
    
    
}

// 跳到模版三
-(void)jumpToTemplateThreeView:(ToolModel *)model{
    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
    HomeIndexVC *vc = [[HomeIndexVC alloc] init];
    vc.bannerTitle = model.obj_title;
    vc.dataLink = model.obj_link;
    vc.objectID = model.obj_id;
    vc.commentObjectType = ObjectTypeAnalyse;
    UINavigationController *rootchatNav = [[UINavigationController alloc]initWithRootViewController:vc];
    logParams[kActionALCName]   = @"点击/报表/报表";
    logParams[kObjIDALCName]    = model.obj_id;
    logParams[kObjTypeALCName]  = @(ObjectTypeAnalyse);
    logParams[kObjTitleALCName] =  model.obj_title;
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

//跳到模版四
-(void)jumpToTemplateFourView:(ToolModel*)model{
    [self jumpToTemplateTwoView:model];
}

//跳到模版五
-(void)jumpToTemplateFiveView:(ToolModel*)model{
    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
    SuperChartVc *superChaerCtrl = [[SuperChartVc alloc]init];
    superChaerCtrl.bannerTitle = SafeText(model.obj_title);
    superChaerCtrl.dataLink = SafeText(model.obj_link);
    superChaerCtrl.objectID = SafeText(model.obj_id);
    superChaerCtrl.commentObjectType = ObjectTypeAnalyse;
    UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:superChaerCtrl];
    logParams[kActionALCName]   = @"点击/报表/报表";
    logParams[kObjIDALCName]    = SafeText(model.obj_id);
    logParams[kObjTypeALCName]  = @(ObjectTypeAnalyse);
    logParams[kObjTitleALCName] =  SafeText(model.obj_title);
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


//跳到模版六
-(void)jumpToTemplateSixView:(ToolModel*)model{
    TemplateSixViewController *templateSix = [[TemplateSixViewController alloc]init];
    templateSix.bannerName = SafeText(model.obj_title);
    templateSix.link = SafeText(model.obj_link);
    templateSix.commentObjectType = ObjectTypeKpi;
    templateSix.objectID = SafeText(model.obj_id);
    [self.navigationController presentViewController:templateSix animated:YES completion:nil];
    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
    logParams[kActionALCName]   = @"点击/工具箱/链接";
    logParams[kObjIDALCName]    = SafeText(model.obj_id);
    logParams[kObjTypeALCName]  = @(ObjectTypeKpi);
    logParams[kObjTitleALCName] =  SafeText(model.obj_title);
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
    
    
}

#pragma mark - jump to reportView

-(void)jumpToSubjectView:(ToolModel *)item {
    NSString *targeturl = item.link_path;
    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
    // NSArray *urlArray = [targeturl componentsSeparatedByString:@"/"];
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
            vc.bannerTitle = item.report_title;
            vc.dataLink = targeturl;
            //vc.objectID =@(item.);
            vc.commentObjectType = ObjectTypeAnalyse;
            UINavigationController *rootchatNav = [[UINavigationController alloc]initWithRootViewController:vc];
            logParams[kActionALCName]   = @"点击/专题/报表";
            //logParams[kObjIDALCName]    = @(item.itemID);
            //logParams[kObjTypeALCName]  = @(ObjectTypeApp);
            // logParams[kObjTitleALCName] =  item.listName;
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
            superChaerCtrl.bannerTitle = item.report_title;
            superChaerCtrl.dataLink = targeturl;
            // superChaerCtrl.objectID =@(item.);
            superChaerCtrl.commentObjectType = ObjectTypeAnalyse;
            UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:superChaerCtrl];
            /* logParams[kActionALCName]   = @"点击/专题/报表";
             logParams[kObjIDALCName]    = @(item.itemID);
             logParams[kObjTypeALCName]  = @(ObjectTypeApp);
             logParams[kObjTitleALCName] =  item.listName;*/
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
        else if ([targeturl rangeOfString:@"template/1/"].location != NSNotFound) {
            JYDemoViewController *superChaerCtrl = [[JYDemoViewController alloc]init];
            superChaerCtrl.urlLink = targeturl;
            // UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:superChaerCtrl];
            logParams[kActionALCName]   = @"点击/专题/报表";
            //logParams[kObjIDALCName]    = @(item.itemID);
            logParams[kObjTypeALCName]  = @(ObjectTypeApp);
            //logParams[kObjTitleALCName] =  item.listName;
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
        else{ //跳转事件
            logParams[kActionALCName]   = @"点击/专题/报表";
            //logParams[kObjIDALCName]    = @(item.itemID);
            logParams[kObjTypeALCName]  = @(ObjectTypeApp);
            //logParams[kObjTitleALCName] =  item.listName;
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            
            [APIHelper actionLog:logParams];
            if (isInnerLink) {
                logParams[kActionALCName]   = @"点击/专题/报表";
                //logParams[kObjIDALCName]    = @(item.itemID);
                //logParams[kObjTypeALCName]  = @(ObjectTypeApp);
                // logParams[kObjTitleALCName] =  item.listName;
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
                    if (item.report_title != nil) {
                        subjectView.bannerName = item.report_title;
                    }
                    else{
                        subjectView.bannerName = item.name;
                    }
                    subjectView.link = targeturl;
                    subjectView.commentObjectType = ObjectTypeApp;
                    UINavigationController *subCtrl = [[UINavigationController alloc] initWithRootViewController:subjectView];
                    [RootTabbarViewConTroller presentViewController:subCtrl animated:YES completion:nil];
                }
                else {
                    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
                    if (item.report_title != nil) {
                        subjectView.bannerName = item.report_title;
                    }
                    else{
                        subjectView.bannerName = item.name;
                    }
                    subjectView.link = targeturl;
                    subjectView.commentObjectType = ObjectTypeApp;
                    // subjectView.objectID = @(item.itemID);
                    UINavigationController *subCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
                    [self.navigationController presentViewController:subCtrl animated:YES completion:nil];
                }
            }
            else{
                
                logParams[kActionALCName]   = @"点击/专题/链接";
                //logParams[kObjIDALCName]    = @(item.itemID);
                //logParams[kObjTypeALCName]  = @(ObjectTypeApp);
                // logParams[kObjTitleALCName] =  item.listName;
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
                subjectView.commentObjectType = ObjectTypeApp;
                //   subjectView.objectID = @(item.itemID);
                
                
                [self.navigationController presentViewController:subjectView animated:YES completion:nil];
            }
        }
    }
}

#pragma mark - getter & setter

- (void)setupUI{
    [self.view sd_addSubviews:@[self.collection]];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (RefreshTool *)reTool{
    if (!_reTool) {
        _reTool = [[RefreshTool alloc] initWithScrollView:self.collection delegate:self down:YES top:NO];
    }
    return _reTool;
}

- (UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-1)/3.0, SCREEN_WIDTH/3.0);
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0.5;
        layout.minimumInteritemSpacing = 0.5;
        _collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collection.backgroundColor =[NewAppColor yhapp_clearcolor];
        _collection.delegate = self;
        _collection.dataSource = self;
    }
    return _collection;
}




@end
