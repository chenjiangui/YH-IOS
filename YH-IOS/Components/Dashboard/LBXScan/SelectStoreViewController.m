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
#import "SearchTableViewCell.h"

@interface SelectStoreViewController ()<UINavigationBarDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    
    NSString *searchingText;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSDictionary *currentStore;
@property (assign, nonatomic) BOOL isSearch;
@property (strong, nonatomic) NSArray *searchItems;
@property (strong, nonatomic) NSString *selectedItem;
@property (strong, nonatomic) NSArray *searchArray;

@end

@implementation SelectStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchItems = [NSMutableArray array];
    
    NSString *barCodePath = [FileUtils dirPath:kCachedDirName FileName:kBarCodeResultFileName];
    NSMutableDictionary *cachedDict = [FileUtils readConfigFile:barCodePath];
    self.currentStore = cachedDict[@"store"];
    
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if(userDict[kStoreIDsCUName] && [userDict[kStoreIDsCUName] count] > 0) {
        self.searchItems =userDict[kStoreIDsCUName];
    }
    
    /**
     *  筛选项列表按字母排序，以便于用户查找
     */
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.searchItems = [self.searchItems sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    if((self.selectedItem == NULL || [self.selectedItem length] == 0) && [self.searchItems count] > 0) {
        self.selectedItem = [self.searchItems firstObject][@"name"];
    }
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    topView.backgroundColor = [UIColor colorWithHexString:kBannerBgColor];
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
    [backBtn addTarget:self action:@selector(actionBannerBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)actionBannerBack {
    if (_isSearch) {
        _isSearch = NO;
        [self.tableView reloadData];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
        self.tableView.dataSource = nil;
        self.tableView.delegate = nil;
        self.tableView = nil;
        self.searchItems = nil;
        }];
    }
}

/**
 *  监听输入框内容变化
 *
 *  @param notifice notifice
 */
- (void)SearchValueChanged:(NSString *)notifice {
    // UITextField *field = [notifice object];
    NSString *searchText = notifice;
    
    if([searchText length] > 0) {
        NSString *predicateStr = [NSString stringWithFormat:@"(SELF['name'] CONTAINS \"%@\")", searchText];
        NSPredicate *sPredicate = [NSPredicate predicateWithFormat:predicateStr];
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.searchItems];
        [array filterUsingPredicate:sPredicate];
        self.searchArray = [NSArray arrayWithArray:array];
    }
    else {
        self.searchArray = [self.searchItems copy];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isSearch) {
        return (section == 1)? _searchArray.count : 1;
    }
    else {
        return (section == 2) ? _searchItems.count : 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (_isSearch) ? 2 : 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    if (_isSearch) {
        if (indexPath.section == 0) {
            SearchTableViewCell *cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search"];
            cell.searchBar.text = searchingText;
            cell.searchBar.delegate = self;
            return cell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIndentifier];
            }
            cell.textLabel.text = self.searchArray[indexPath.row][@"name"];
            return cell;
        }
    }
    else {
        if (indexPath.section == 0) {
            SearchTableViewCell *cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search"];
            cell.searchBar.delegate = self;
            return cell;
        }
        if (indexPath.section == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"selected"];
            cell.textLabel.text = self.selectedItem;
            return cell;
        }
        else {
            static NSString *CellIndentifier = @"CellIndentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIndentifier];
            }
            NSString *currentItem = self.searchItems[indexPath.row][@"name"];
            cell.textLabel.text = currentItem;
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 0.001:30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *array = (_isSearch)? @[@"",@"列表"]:@[@"",@"已选门店",@"所有门店"];
    return array[section];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? 50 : 30 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *barCodePath = [FileUtils dirPath:kCachedDirName FileName:kBarCodeScanFileName];
    NSMutableDictionary *cachedDict = [FileUtils readConfigFile:barCodePath];
    NSDictionary *currentStore;
    if (indexPath.section == 1) {
        currentStore =(_isSearch) ? self.searchArray[indexPath.row] :self.currentStore;
    }
    if (indexPath.section == 2) {
    currentStore = self.searchItems[indexPath.row];
    }
    
    cachedDict[@"store"] = @{ @"id": currentStore[@"id"], @"name": currentStore[@"name"]};
    [FileUtils writeJSON:cachedDict Into:barCodePath];
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.tableView.dataSource = nil;
        self.tableView.delegate = nil;
        self.tableView = nil;
        self.searchItems = nil;
    }];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        _isSearch = NO;
        [self.tableView reloadData];
    }
}
- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchingText =searchBar.text;
    self.isSearch = YES;
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self SearchValueChanged:searchBar.text];
    searchingText = searchBar.text;
    [searchBar resignFirstResponder];
}

@end
