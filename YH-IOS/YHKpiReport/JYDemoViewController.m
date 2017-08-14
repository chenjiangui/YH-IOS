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


@interface JYDemoViewController () <RefreshToolDelegate> {
    
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
    self.iconNameArray =[ @[@"Barcode-Scan",@"Barcode-Scan",@"Barcode-Scan"] mutableCopy];
    self.itemNameArray =[ @[@"分享",@"评论",@"刷新"] mutableCopy];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeff1"];
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
            if (!row) {
                
            }
            else if(row == 1){
            }
            else if(row == 2){
                
            }
            else if(row == 3){
                
            }
        }
        
        weakSelf.rBtnSelected = NO;
    }];
}

- (void)hidePopMenuWithAnimation:(BOOL)animate{
    [_popView hideWithAnimation:animate];
}


- (JYModuleTwoModel *)moduleTwoModel {
    if (!_moduleTwoModel) {
        // 数据准备
        NSString *path = [[NSBundle mainBundle] pathForResource:@"report_v24" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray *arraySource = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        _moduleTwoModel = [JYModuleTwoModel modelWithParams:arraySource[0]];
    }
    return _moduleTwoModel;
}

-(void)getData{
    
    NSArray *templateArray = [self.urlLink componentsSeparatedByString:@"/"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *kpiUrl = [NSString stringWithFormat:@"%@/api/v1/group/%@/template/1/report/%@/json",kBaseUrl,SafeText(user.groupID),templateArray[8]];
    [manager GET:kpiUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"用户信息 %@",responseObject);
        NSArray *array = responseObject;
        _moduleTwoModel = [JYModuleTwoModel modelWithParams:array[0]];
        [self moduleTwoList];
        [HudToolView hideLoadingInView:self.view];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR- %@",error);
        NSString *path = [[NSBundle mainBundle] pathForResource:@"report_v24" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray *arraySource = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        [HudToolView hideLoadingInView:self.view];
        _moduleTwoModel = [JYModuleTwoModel modelWithParams:arraySource[0]];
        [self moduleTwoList];
    }];
}

- (void)moduleTwoList {
    moduleTwoView = [[JYModuleTwoView alloc] initWithFrame:CGRectMake(0,0, JYVCWidth, SCREEN_HEIGHT-64)];
    moduleTwoView.moduleModel = self.moduleTwoModel;
    [self.view addSubview:moduleTwoView];
    [moduleTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
//    [self.view removeAllSubviews];
}


@end
