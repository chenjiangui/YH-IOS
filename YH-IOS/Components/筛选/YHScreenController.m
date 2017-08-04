//
//  YHScreenController.m
//  YH-IOS
//
//  Created by cjg on 2017/8/3.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHScreenController.h"
#import "ScreenHeaderView.h"
#import "SelectLocationView.h"
#import "YHHttpRequestAPI.h"
#import "ScreenModel.h"
#import "SimpleTableViewController.h"
#import "OneButtonTableViewCell.h"

@interface YHScreenController ()
@property (nonatomic, strong) ScreenHeaderView* headerView;
@property (nonatomic, strong) SelectLocationView* selectLocationView;
@property (nonatomic, strong) ScreenModel* typesModel;
@property (nonatomic, strong) ScreenModel* areasModel;
@property (nonatomic, strong) ScreenModel* selectAreaModel;
@property (nonatomic, strong) SimpleTableViewController* simpleVc;
@property (nonatomic, strong) ScreenModel* selectTypeModel;
@end

@implementation YHScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getMainData];
}

- (void)getMainData{
     MJWeakSelf;
    [HudToolView showLoadingInView:self.view];
    [YHHttpRequestAPI yh_getScreenMainAndAddressListDataFinish:^(BOOL success, ScreenModel* model, NSString *jsonObjc) {
        [HudToolView hideLoadingInView:self.view];
        if ([BaseModel handleResult:model]) {
            self.areasModel = [NSArray getObjectInArray:model.data keyPath:@"type" equalValue:@"location"];
            self.typesModel = [NSArray getObjectInArray:model.data keyPath:@"type" equalValue:@"faster_select"];
            self.selectLocationView = [[SelectLocationView alloc] initWithDataList:self.areasModel.data];
            self.selectLocationView.selectBlock = ^(ScreenModel* item) {
                weakSelf.selectAreaModel = item;
                [weakSelf.headerView setAreaModel:item];
            };
            [self.headerView setData:self.typesModel.data];
        }
    }];
}

- (void)getListData:(BOOL)loading pullDown:(BOOL)pullDown{
    if (loading) {
        [HudToolView showLoadingInView:self.view];
    }
}


#pragma mark - lazy and ui
- (void)setupUI{
    [self.view sd_addSubviews:@[self.headerView,self.simpleVc.view]];
    [self.simpleVc.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.simpleVc.view);
        make.height.mas_equalTo(244);
    }];
    self.simpleVc.view.backgroundColor = [UIColor clearColor];
    
}

- (ScreenHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ScreenHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 81)];
        MJWeakSelf;
        _headerView.screenBlock = ^(id item) {
            if (weakSelf.selectLocationView) {
                [weakSelf.selectLocationView show];
            }
        };
        _headerView.locationBlock = ^(NSIndexPath* indexPath,ScreenModel* item) {
            weakSelf.selectTypeModel = item;
            if (weakSelf.simpleVc.view.hidden) {
                
            }else{
                
            }
        };
    }
    return _headerView;
}

- (SimpleTableViewController *)simpleVc{
    if (!_simpleVc) {
        MJWeakSelf;
        _simpleVc = [[SimpleTableViewController alloc] initWithCellClass:[OneButtonTableViewCell class] xib:false];
        _simpleVc.cellBlock = ^(OneButtonTableViewCell* cell, ScreenModel* item2) {
            [cell.actionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(cell);
                make.left.mas_equalTo(cell).offset(18);
            }];
            cell.actionBtn.userInteractionEnabled = false;
            [cell.actionBtn setImage:@"ic_right".imageFromSelf forState:UIControlStateSelected];
            [cell.actionBtn setImage:[UIImage imageWithColor:[UIColor clearColor] size:@"ic_right".imageFromSelf.size] forState:UIControlStateNormal];
            cell.actionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [cell.actionBtn setTitleColor:[NewAppColor yhapp_6color] forState:UIControlStateNormal];
            [cell.actionBtn setTitleColor:[NewAppColor yhapp_1color] forState:UIControlStateSelected];
            [cell.actionBtn setTitle:item2.name forState:UIControlStateNormal];
            cell.actionBtn.selected = item2.isSelected;
            [cell.actionBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:12];
        };
        _simpleVc.selectBlock = ^(NSIndexPath* item1, ScreenModel* item2) {
            
        };
        _simpleVc.touchBlock = ^(id item) {
            weakSelf.simpleVc.view.hidden = YES;
        };
        _simpleVc.view.hidden = YES;
    }
    return _simpleVc;
}

@end
