//
//  ReportSelectorViewController.m
//  YH-IOS
//
//  Created by lijunjie on 16/7/15.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "FileUtils+Report.h"
#import "ReportSelectorViewController.h"

@interface ReportSelectorViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *searchItems;
@property (strong, nonatomic) NSString *selectedItem;
@end

@implementation ReportSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self idColor];

    self.searchItems = [FileUtils reportSearchItems:self.user.groupID templateID:self.templateID reportID:self.reportID];
    
    /**
     *  - 如果用户已设置筛选项，则 banner 显示该信息
     *  - 未设置时，默认显示第一个
     */
    self.selectedItem = [FileUtils reportSelectedItem:self.user.groupID templateID:self.templateID reportID:self.reportID];
    if((self.selectedItem == NULL || [self.selectedItem length] == 0) && [self.searchItems count] > 0) {
        self.selectedItem = [self.searchItems firstObject];
    }
    
    /**
     *  筛选项列表按字母排序，以便于用户查找
     */
    self.searchItems = [self.searchItems sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    self.labelTheme.text = self.bannerName;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ibaction block
- (IBAction)actionBack:(id)sender {
    [super dismissViewControllerAnimated:YES completion:^{
        [self.progressHUD hide:YES];
        self.progressHUD = nil;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchItems.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIndentifier];
    }
    
    //[tableView setSeparatorColor:[UIColor blueColor]];
    NSString *currentItem = self.searchItems[indexPath.row];
    cell.textLabel.text = currentItem;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = (self.selectedItem && [self.selectedItem isEqualToString:currentItem])  ? [UIColor greenColor] : [UIColor whiteColor];
    cell.backgroundView = bgColorView;

//    
//    cell.separatorInset = UIEdgeInsetsZero;
//    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]){
//        cell.layoutMargins = UIEdgeInsetsZero;
//        cell.preservesSuperviewLayoutMargins = false;
//    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedItem = self.searchItems[indexPath.row];
    
    NSString *selectedItemPath = [NSString stringWithFormat:@"%@.selected_item", [FileUtils reportJavaScriptDataPath:self.user.groupID templateID:self.templateID reportID:self.reportID]];
    [selectedItem writeToFile:selectedItemPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [self actionBack:nil];
}

@end
