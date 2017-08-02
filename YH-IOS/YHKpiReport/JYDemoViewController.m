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


@interface JYDemoViewController ()  {
    
    UITableView *_tableView;
    JYModuleTwoView *moduleTwoView;
    User *user;
    
}

@property (nonatomic, strong) JYModuleTwoModel *moduleTwoModel;

@end

@implementation JYDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [[User alloc]init];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeff1"];
    [self getData];
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"report_v24" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *arraySource = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
    _moduleTwoModel = [JYModuleTwoModel modelWithParams:arraySource[0]];
    [self moduleTwoList];
    return;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *kpiUrl = [NSString stringWithFormat:@"%@/api/v1/group/%@/template/1/report/1/json",kBaseUrl,user.groupID];
    [manager GET:kpiUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"用户信息 %@",responseObject);
        NSArray *array = responseObject;
        _moduleTwoModel = [JYModuleTwoModel modelWithParams:array[0]];
        [self moduleTwoList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR- %@",error);
        NSString *path = [[NSBundle mainBundle] pathForResource:@"report_v24" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray *arraySource = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        _moduleTwoModel = [JYModuleTwoModel modelWithParams:arraySource[0]];
        [self moduleTwoList];
    }];

}

- (void)moduleTwoList {
    moduleTwoView = [[JYModuleTwoView alloc] initWithFrame:CGRectMake(0,0, JYVCWidth, SCREEN_HEIGHT-64)];
    moduleTwoView.moduleModel = self.moduleTwoModel;
    [self.view addSubview:moduleTwoView];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
//    [self.view removeAllSubviews];
}


@end
