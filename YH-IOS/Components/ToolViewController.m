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

@interface ToolViewController () <UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UICollectionView* collection;

@property (nonatomic, strong) RefreshTool* reTool;

@property (nonatomic, strong) NSArray* dataList;

@end

@implementation ToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工具箱";
    [self setupUI];
    [self getData:true];
}

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
        }
    }];
}

#pragma mark - 点击事件
- (void)toolClickAction:(ToolModel*)model{
    YHScreenController* vc = [[YHScreenController alloc] init];
    [self pushViewController:vc animation:YES hideBottom:YES];
    return;
    [self jumpToSubjectView:model];
}

- (void)refreshToolBeginDownRefreshWithScrollView:(UIScrollView *)scrollView tool:(RefreshTool *)tool{
    [self getData:false];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OneImageAndLabCell* cell = [OneImageAndLabCell cellWithCollctionView:collectionView needXib:YES IndexPath:indexPath];
    ToolModel* model = _dataList[indexPath.row];
    [cell.imageV sd_setImageWithURL:model.icon_link.mj_url placeholderImage:DEFAULT_IMAGE];
    cell.contentLab.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ToolModel* model = _dataList[indexPath.row];
    [self toolClickAction:model];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}


#pragma mark - lazy and ui
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
        _collection.backgroundColor = self.view.backgroundColor;
        _collection.delegate = self;
        _collection.dataSource = self;
    }
    return _collection;
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
            vc.bannerTitle = item.name;
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
            superChaerCtrl.bannerTitle = item.name;
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @try {
                    [APIHelper actionLog:logParams];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }
            });
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


                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
                subjectView.bannerName = item.name;
                subjectView.link = targeturl;
                subjectView.commentObjectType = ObjectTypeApp;
               // subjectView.objectID = @(item.itemID);
                UINavigationController *subCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
                [self.navigationController presentViewController:subCtrl animated:YES completion:nil];
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
              //  subjectView.bannerName = item.listName;
                subjectView.link = targeturl;
                subjectView.commentObjectType = ObjectTypeApp;
             //   subjectView.objectID = @(item.itemID);

                
                [self.navigationController presentViewController:subjectView animated:YES completion:nil];
            }
        }
    }
}


@end
