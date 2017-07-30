//
//  CommonSheetView.m
//  YH-IOS
//
//  Created by cjg on 2017/7/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "CommonSheetView.h"
#import "CommonTableViewCell.h"

@interface CommonSheetView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray<NSString*>* dataList;

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation CommonSheetView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [NewAppColor yhapp_8color];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

- (instancetype)initWithDataList:(NSArray<NSString *> *)dataList{
    self = [self initWithFrame:CGRectZero];
    self.size = CGSizeMake(SCREEN_WIDTH, dataList.count*50 + 55);
    self.dataList = dataList;
    return self;
}

- (void)setDataList:(NSArray<NSString *> *)dataList{
    _dataList = dataList;
    [self.tableView reloadData];
}

- (void)setColors:(NSArray<UIColor *> *)colors{
    _colors = colors;
    [self.tableView reloadData];
}

- (void)setLastString:(NSString *)lastString{
    _lastString = lastString;
    [self.tableView reloadData];
}

- (void)setLastStringColor:(UIColor *)lastStringColor{
    _lastStringColor = lastStringColor;
    [self.tableView reloadData];
}

- (void)show{
    self.sl_popupController.layoutType = PopupLayoutTypeBottom;
    self.sl_popupController.transitStyle = PopupTransitStyleFromBottom;
    [self.sl_popupController presentContentView:self duration:0.3 elasticAnimated:NO];
}

- (void)hide{
    [self.sl_popupController dismiss];
}

#pragma mark - 列表代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonTableViewCell *cell = [CommonTableViewCell cellWithTableView:tableView needXib:NO];
    [cell setTitleStyle:YES];
    [cell.leftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(cell);
    }];
    cell.leftLab.textAlignment = NSTextAlignmentCenter;
    cell.leftLab.font = [UIFont systemFontOfSize:16];
    if (indexPath.row<self.colors.count) {
        cell.leftLab.textColor = self.colors[indexPath.row];
    }else{
        cell.leftLab.textColor = [NewAppColor yhapp_1color];
    }
    cell.leftLab.text = self.dataList[indexPath.row];
    if (indexPath.section == 1) {
        cell.leftLab.text = self.lastString? :@"取消";
        cell.leftLab.textColor = self.lastStringColor? : [NewAppColor yhapp_3color];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (self.selectBlock) {
            self.selectBlock(@(indexPath.row));
        }
    }else{
        [self hide];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataList.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataList.count ? 2:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return 0;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}
@end
