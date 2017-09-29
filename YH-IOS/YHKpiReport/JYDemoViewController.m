//
//  JYDemoViewController.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYDemoViewController.h"
#import "JYModuleTwoModel.h"
#import "JYModuleTwoView.h"
#import "User.h"
#import "YHPopMenuView.h"
#import "RefreshTool.h"
#import "CommentViewController.h"
#import "UMSocialControllerService.h"
#import "UMSocial.h"
#import "FileUtils.h"
//#import <SYPTemplateV2/JYModuleTwoView.h>
//#import <SYPTemplateV2/JYModuleTwoModel.h>
#import <SYPTemplateV2/testTemplateViewController.h>


@interface JYDemoViewController () <RefreshToolDelegate,UMSocialUIDelegate> {
    
    UITableView *_tableView;
    JYModuleTwoView *moduleTwoView;
    User *user;
}

@property (nonatomic, strong) JYModuleTwoModel *moduleTwoModel;
@property (nonatomic, strong) YHPopMenuView *popView;
@property (nonatomic, assign) BOOL rBtnSelected;
@property (nonatomic, strong) NSMutableArray *iconNameArray;
@property (nonatomic, strong) NSMutableArray *itemNameArray;
@property (nonatomic, strong) RefreshTool* reTool;

@end

@implementation JYDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [[User alloc]init];
    self.iconNameArray =[ @[@"pop_share",@"pop_talk",@"pop_flash"]  mutableCopy];
    self.itemNameArray =[ @[@"分享",@"评论",@"刷新"] mutableCopy];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeff1"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"btn_add"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onRightBtn:)];
    [self getData:true];
}


- (void)getData:(BOOL)loading{
    if (loading) {
        [HudToolView showLoadingInView:self.view];
    }
    [self getData];
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
    CGFloat itemH = 50;
    CGFloat w = 120;
    CGFloat h = self.iconNameArray.count*itemH;
    CGFloat x = SCREEN_WIDTH - 9-120;
    CGFloat y = 1;
    
    _popView = [[YHPopMenuView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    _popView.iconNameArray =self.iconNameArray;
    _popView.itemNameArray =self.itemNameArray;
    _popView.itemH     = itemH;
    _popView.fontSize  = 16.0f;
    _popView.fontColor = [UIColor whiteColor];
    _popView.canTouchTabbar = YES;
    [_popView show];
    
    WeakSelf;
    [_popView dismissHandler:^(BOOL isCanceled, NSInteger row) {
        if (!isCanceled) {
            
            NSLog(@"点击第%ld行",(long)row);
            if (row == 0) {
                [self actionWebviewScreenShot];
            }
            else if(row == 1){
                [self actionWriteComment];
            }
            else if(row == 2){
                [self refreshData];
            }
        }
        
        weakSelf.rBtnSelected = NO;
    }];
}

- (void)actionWebviewScreenShot{
    [_popView hideWithAnimation:NO];
    UIImage *image =  [self captureView:CurAppDelegate.window frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
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
}

- (UIImage*)captureView:(UIView *)theView frame:(CGRect)frame
{
    UIGraphicsBeginImageContext(self.navigationController.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *img;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        for(UIView *subview in theView.subviews)
        {
            [subview drawViewHierarchyInRect:subview.bounds afterScreenUpdates:YES];
        }
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    else
    {
        CGContextSaveGState(context);
        [theView.layer renderInContext:context];
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, self.navigationController.view.frame);
    UIImage *CGImg = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return CGImg;
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


- (void)hidePopMenuWithAnimation:(BOOL)animate{
    [_popView hideWithAnimation:animate];
}


//- (JYModuleTwoModel *)moduleTwoModel {
//    if (!_moduleTwoModel) {
//        // 数据准备
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"report_v24" ofType:@"json"];
//        NSData *data = [NSData dataWithContentsOfFile:path];
//        NSArray *arraySource = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//
//        _moduleTwoModel = [JYModuleTwoModel modelWithParams:arraySource[0]];
//    }
//    return _moduleTwoModel;
//}

-(void)getData{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"report_v24" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSArray *arraySource = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//    [HudToolView hideLoadingInView:self.view];
//    _moduleTwoModel = [JYModuleTwoModel modelWithParams:arraySource[0]];
//    [self moduleTwoList];
//    return;


    NSArray *templateArray = [self.urlLink componentsSeparatedByString:@"/"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *kpiUrl = [NSString stringWithFormat:@"%@/api/v1/group/%@/template/1/report/%@/json",kBaseUrl,SafeText(user.groupID),templateArray[8]];
    //
    NSString *fileNameString = [NSString stringWithFormat:@"/api/v1/group/%@/template/1/report/%@/json",SafeText(user.groupID),templateArray[8]];
    NSString *dataPath = [[FileUtils userspace] stringByAppendingPathComponent:@"HTML"];
    if (![FileUtils checkFileExist:dataPath isDir:YES]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = [HttpUtils urlTofilename:fileNameString suffix:@".json"][0];
    NSString *assetsPath =  [FileUtils dirPath:kHTMLDirName];
    NSString *cachedHeaderPath = [assetsPath stringByAppendingPathComponent:kCachedHeaderConfigFileName];
   __block NSMutableDictionary *cachedHeaderDict = [NSMutableDictionary dictionaryWithContentsOfFile:cachedHeaderPath];
    if (cachedHeaderDict == nil) {
        cachedHeaderDict = [[NSMutableDictionary alloc]init];
    }
    dataPath = [dataPath stringByAppendingPathComponent:fileName];
    NSString *urlCleanedString = [self urlCleaner:fileName];
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    if(cachedHeaderDict[urlCleanedString]) {
        if(cachedHeaderDict[urlCleanedString][@"Etag"]) {
            header[@"IF-None-Match"] = cachedHeaderDict[urlCleanedString][@"Etag"];
        }

        if(cachedHeaderDict[urlCleanedString][@"Last-Modified"]) {
            header[@"If-Modified-Since"] = cachedHeaderDict[urlCleanedString][@"Last-Modified"];
        }
    }

    [manager GET:kpiUrl parameters:header success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"用户信息 %@",responseObject);
        NSMutableDictionary *cachedHeaderDict = [NSMutableDictionary dictionaryWithContentsOfFile:cachedHeaderPath];
        if (cachedHeaderDict == nil) {
            cachedHeaderDict = [[NSMutableDictionary alloc]init];
        }
        NSLog(@"头信息%@",operation.response.allHeaderFields);
        NSDictionary *headDict = operation.response.allHeaderFields;
        cachedHeaderDict[urlCleanedString] = headDict;
        if (![FileUtils checkFileExist:cachedHeaderPath isDir:NO]) {
            [[NSFileManager defaultManager] createFileAtPath:cachedHeaderPath contents:nil attributes:nil];
        }
        [cachedHeaderDict writeToFile:cachedHeaderPath atomically:YES];
        NSArray *array = responseObject;
        [array writeToFile:dataPath atomically:YES];
//      _moduleTwoModel = [JYModuleTwoModel modelWithParams:array[0]];

        // 从应用内部读取数据
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectoir = nil;
        if ([paths count] != 0 ) {
            documentDirectoir = [paths objectAtIndex:0];
        }

        NSString *libName = @"SYPTemplateV2.framework";
        NSString *destLibPath = [documentDirectoir stringByAppendingPathComponent:libName];
        NSLog(@"there %@",destLibPath);

        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:destLibPath]) {
            NSLog(@"there isn't have a file");
//            testTemplateViewController *testView = [[testTemplateViewController alloc]initWithData:array];
//            [self.view addSubview:testView.view];
            _moduleTwoModel = [JYModuleTwoModel modelWithParams:array[0]];
            [self moduleTwoList];
            [HudToolView hideLoadingInView:self.view];
            return;
        }

        NSError *error = nil;
        NSBundle *frameworkBundle = [NSBundle bundleWithPath:destLibPath];
        [frameworkBundle load];
        if (frameworkBundle && [frameworkBundle load]) {
            NSLog(@"bundle load framwwork success.");
        }
        else{
            NSLog(@"bundle load framework err:%@",error);
//            testTemplateViewController *testView = [[testTemplateViewController alloc]initWithData:array];
//            [self.view addSubview:testView.view];
            _moduleTwoModel = [JYModuleTwoModel modelWithParams:array[0]];
            [self moduleTwoList];
            [HudToolView hideLoadingInView:self.view];
            return;
        }

        Class pacteraClass = NSClassFromString(@"testTemplateViewController");
        if (!pacteraClass) {
            NSLog(@"unable to get testDylib class");
//            testTemplateViewController *testView = [[testTemplateViewController alloc]initWithData:array];
//            [self.view addSubview:testView.view];
            _moduleTwoModel = [JYModuleTwoModel modelWithParams:array[0]];
            [self moduleTwoList];
        }
        else {
            UIViewController *pacteraObject = [[pacteraClass alloc]initWithData:array];
            [self.view addSubview:pacteraObject.view];
//            testTemplateViewController *testView = [[testTemplateViewController alloc]initWithData:array];
//                   [self.view addSubview:testView.view];
        }
//        [self moduleTwoList];
        [HudToolView hideLoadingInView:self.view];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR- %@",error);
       // NSString *path = [[NSBundle mainBundle] pathForResource:@"report_v24" ofType:@"json"];
        NSArray *array = [NSArray arrayWithContentsOfFile:dataPath];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
        NSArray *arraySource = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
        [HudToolView hideLoadingInView:self.view];
        _moduleTwoModel = [JYModuleTwoModel modelWithParams:arraySource[0]];
        [self moduleTwoList];
    }];
}

- (NSString *)urlCleaner:(NSString *)urlString {
    return [urlString componentsSeparatedByString:@"?"][0];
}

- (void)moduleTwoList {
    if (!moduleTwoView) {
          moduleTwoView = [[JYModuleTwoView alloc] initWithFrame:CGRectMake(0,0, JYVCWidth, SCREEN_HEIGHT-64)];
    }
    moduleTwoView.moduleModel = self.moduleTwoModel;
    [self.view addSubview:moduleTwoView];
    [moduleTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}


-(void)writeDataToLocation:(NSString *)jsonString {
    NSString *dataPath = [[FileUtils userspace] stringByAppendingPathComponent:@"HTML"];
    NSString *fileName = [HttpUtils urlTofilename:_urlLink suffix:@".json"][0];
    dataPath = [dataPath stringByAppendingPathComponent:fileName];
    [jsonString writeToFile:dataPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(void)refreshData{
    
    [HudToolView showLoadingInView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HudToolView hideLoadingInView:self.view];
    });
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"report_v24" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSArray *arraySource = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//    [HudToolView hideLoadingInView:self.view];
//    _moduleTwoModel = [JYModuleTwoModel modelWithParams:arraySource[0]];
//     moduleTwoView.moduleModel = self.moduleTwoModel;
//    return;
//    
//    [HudToolView showLoadingInView:self.view];
//        NSArray *templateArray = [self.urlLink componentsSeparatedByString:@"/"];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSString *kpiUrl = [NSString stringWithFormat:@"%@/api/v1/group/%@/template/1/report/%@/json",kBaseUrl,SafeText(user.groupID),templateArray[8]];
//        [manager GET:kpiUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"用户信息 %@",responseObject);
//            NSArray *array = responseObject;
//            _moduleTwoModel = [JYModuleTwoModel modelWithParams:array[0]];
//            [self moduleTwoList];
//            [HudToolView hideLoadingInView:self.view];
//    
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"ERROR- %@",error);
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"report_v24" ofType:@"json"];
//            NSData *data = [NSData dataWithContentsOfFile:path];
//            NSArray *arraySource = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//            [HudToolView hideLoadingInView:self.view];
//            _moduleTwoModel = [JYModuleTwoModel modelWithParams:arraySource[0]];
//            moduleTwoView.moduleModel = self.moduleTwoModel;
//        }];
    
//    NSArray *templateArray = [self.urlLink componentsSeparatedByString:@"/"];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString *kpiUrl = [NSString stringWithFormat:@"%@/api/v1/group/%@/template/1/report/%@/json",kBaseUrl,SafeText(user.groupID),templateArray[8]];
//    //
//    NSString *fileNameString = [NSString stringWithFormat:@"/api/v1/group/%@/template/1/report/%@/json",SafeText(user.groupID),templateArray[8]];
//    NSString *dataPath = [[FileUtils userspace] stringByAppendingPathComponent:@"HTML"];
//    if (![FileUtils checkFileExist:dataPath isDir:YES]) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    NSString *fileName = [HttpUtils urlTofilename:fileNameString suffix:@".json"][0];
//    NSString *assetsPath =  [FileUtils dirPath:kHTMLDirName];
//    NSString *cachedHeaderPath = [assetsPath stringByAppendingPathComponent:kCachedHeaderConfigFileName];
//    __block NSMutableDictionary *cachedHeaderDict = [NSMutableDictionary dictionaryWithContentsOfFile:cachedHeaderPath];
//    if (cachedHeaderDict == nil) {
//        cachedHeaderDict = [[NSMutableDictionary alloc]init];
//    }
//    dataPath = [dataPath stringByAppendingPathComponent:fileName];
//    NSString *urlCleanedString = [self urlCleaner:fileName];
//    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
//    if(cachedHeaderDict[urlCleanedString]) {
//        if(cachedHeaderDict[urlCleanedString][@"Etag"]) {
//            header[@"IF-None-Match"] = cachedHeaderDict[urlCleanedString][@"Etag"];
//        }
//
//        if(cachedHeaderDict[urlCleanedString][@"Last-Modified"]) {
//            header[@"If-Modified-Since"] = cachedHeaderDict[urlCleanedString][@"Last-Modified"];
//        }
//    }
//
//    [manager GET:kpiUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        NSLog(@"用户信息 %@",responseObject);
//        NSMutableDictionary *cachedHeaderDict = [NSMutableDictionary dictionaryWithContentsOfFile:cachedHeaderPath];
//        if (cachedHeaderDict == nil) {
//            cachedHeaderDict = [[NSMutableDictionary alloc]init];
//        }
//        NSLog(@"头信息%@",operation.response.allHeaderFields);
//        NSDictionary *headDict = operation.response.allHeaderFields;
//        cachedHeaderDict[urlCleanedString] = headDict;
//        if (![FileUtils checkFileExist:cachedHeaderPath isDir:NO]) {
//            [[NSFileManager defaultManager] createFileAtPath:cachedHeaderPath contents:nil attributes:nil];
//        }
//        [cachedHeaderDict writeToFile:cachedHeaderPath atomically:YES];
//        NSArray *array = responseObject;
//        //_moduleTwoModel = [JYModuleTwoModel modelWithParams:array[0]];
//        [array writeToFile:dataPath atomically:YES];
//        [self moduleTwoList];
//        [HudToolView hideLoadingInView:self.view];
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"ERROR- %@",error);
//        // NSString *path = [[NSBundle mainBundle] pathForResource:@"report_v24" ofType:@"json"];
//        NSArray *array = [NSArray arrayWithContentsOfFile:dataPath];
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
//        NSArray *arraySource = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
//        [HudToolView hideLoadingInView:self.view];
//       // _moduleTwoModel = [JYModuleTwoModel modelWithParams:arraySource[0]];
//        [self moduleTwoList];
//    }];

}



-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
//    [self.view removeAllSubviews];
}


@end
