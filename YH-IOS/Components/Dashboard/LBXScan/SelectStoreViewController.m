//
//  SelectStoreViewController.m
//  YH-IOS
//
//  Created by li hao on 16/8/10.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "SelectStoreViewController.h"
#import "User.h"
#import "FileUtils.h"
#import "ScanResultViewController.h"

@interface SelectStoreViewController ()<UINavigationBarDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSString *barCodePath;
@property (strong, nonatomic) NSDictionary *currentStore;

@end

@implementation SelectStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataList = [NSMutableArray array];
    
    NSString *cachedPath = [FileUtils dirPath:@"Cached"];
    self.barCodePath = [cachedPath stringByAppendingPathComponent:@"barcode.json"];
    NSMutableDictionary *cachedDict = [FileUtils readConfigFile:self.barCodePath];
    self.currentStore = cachedDict[@"store"];
    
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if(userDict[@"store_ids"] && [userDict[@"store_ids"] count] > 0) {
        self.dataList =userDict[@"store_ids"];
    }
    
    /**
     *  筛选项列表按字母排序，以便于用户查找
     */
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.dataList = [self.dataList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    topView.backgroundColor=[UIColor colorWithHexString:YH_COLOR];
    [self.view addSubview:topView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 70, 40)];
    UIImage *imageback = [UIImage imageNamed:@"Banner-Back"];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 15, 25)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addSubview:bakImage];
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 50, 25)];
    backLabel.text = @"返回";
    backLabel.textColor = [UIColor whiteColor];
    [backBtn addSubview:backLabel];
    [topView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(jumpBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)jumpBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    NSString *storeName = self.dataList[indexPath.row][@"name"];
    cell.textLabel.text = storeName;
    
    if ([storeName isEqualToString:self.currentStore[@"name"]]) {
        cell.backgroundColor = [UIColor greenColor];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *cachedDict = [FileUtils readConfigFile:self.barCodePath];
    NSDictionary *currentStore = self.dataList[indexPath.row];

    cachedDict[@"store"] = @{ @"id": currentStore[@"id"], @"name": currentStore[@"name"]};
    [FileUtils writeJSON:cachedDict Into:self.barCodePath];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end