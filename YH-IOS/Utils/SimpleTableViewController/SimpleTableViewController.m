//
//  SimpleTableViewController.m
//  YH-IOS
//
//  Created by cjg on 2017/8/3.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "SimpleTableViewController.h"

@interface SimpleTableViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, assign) BOOL xib;
@property (nonatomic, assign) CGFloat  cellHeight;

@end

@implementation SimpleTableViewController

- (instancetype)initWithCellClass:(Class)cellClass xib:(BOOL)xib{
    self = [super init];
    if (self) {
        self.cellClass = cellClass;
        self.xib = xib;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view sd_addSubviews:@[self.tableView,self.topLine]];
    _cellHeight = _cellHeight>0? :45;
    if (!_xib) {
        [_tableView registerClass:_cellClass forCellReuseIdentifier:NSStringFromClass(_cellClass)];
    }else{
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(_cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(_cellClass)];
    }
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_touchBlock) {
        _touchBlock(nil);
    }
}

- (void)updateDateList:(NSArray *)dataList{
    _dataList = [NSMutableArray arrayWithArray:dataList];
    [self.tableView reloadData];
}

- (void)reload{
    [self updateDateList:_dataList];
}
#pragma mark - 列表代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.cellClass) forIndexPath:indexPath];
    id model = [_dataList objectAtIndex:indexPath.row];
    if (self.cellBlock) {
        self.cellBlock(cell, model);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBlock) {
        self.selectBlock(indexPath, _dataList[indexPath.row]);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellHeightBlock) {
        id model = [_dataList objectAtIndex:indexPath.row];
        self.cellHeightBlock(indexPath,model);
    }
    return _cellHeight;
}

#pragma mark - lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];;
        _topLine.backgroundColor = [NewAppColor yhapp_9color];
    }
    return _topLine;
}

@end
