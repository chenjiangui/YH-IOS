//
//  SelectLocationView.m
//  YH-IOS
//
//  Created by cjg on 2017/8/3.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "SelectLocationView.h"
#import "ScrollControllersVc.h"
#import "SimpleTableViewController.h"
#import "OneButtonTableViewCell.h"
#import "SnailPopupController.h"
#import "ScreenModel.h"

@interface SelectLocationView ()
@property (nonatomic, strong) ScrollControllersVc* scrollVc;
@property (nonatomic, strong) SimpleTableViewController* oneVc;
@property (nonatomic, strong) UILabel* titleLab;
@property (nonatomic, strong) UIButton* closeBtn;
@property (nonatomic, strong) NSArray* dataList;
@property (nonatomic, assign) NSInteger index;
@end

@implementation SelectLocationView

- (void)show{
    self.sl_popupController.layoutType = PopupLayoutTypeBottom;
    self.sl_popupController.transitStyle = PopupTransitStyleFromBottom;
    [self.sl_popupController presentContentView:self duration:0.3 elasticAnimated:NO];
}

- (void)hide{
    [self.sl_popupController dismiss];
}

- (void)reload:(NSArray *)dataList{
    self.dataList = dataList;
    [self.scrollVc updateControllers:@[self.oneVc] titles:@[@"请选择"]];
    [self.scrollVc scrollWithIndex:0];
    [self.oneVc updateDateList:dataList];
}

- (instancetype)initWithDataList:(NSArray *)dataList{
    self = [self initWithFrame:CGRectZero];
    self.size = CGSizeMake(SCREEN_WIDTH, 400);
    self.dataList = dataList;
    [self.scrollVc updateControllers:@[self.oneVc] titles:@[@"请选择"]];
    [self.scrollVc scrollWithIndex:0];
    [self.oneVc updateDateList:dataList];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self sd_addSubviews:@[self.titleLab,self.scrollVc.view,self.closeBtn]];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.mas_equalTo(self);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(48);
        }];
        [_scrollVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.top.mas_equalTo(_titleLab.mas_bottom);
        }];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(48, 48));
        }];
    }
    return self;
}

- (ScrollControllersVc *)scrollVc{
    if (!_scrollVc) {
        MJWeakSelf;
        _scrollVc = [[ScrollControllersVc alloc] initWithControllers:@[] titles:@[]];
        _scrollVc.selectBack = ^(NSNumber* item) {
            weakSelf.index = item.integerValue;
        };
        _scrollVc.lableW = 75;
        _scrollVc.lableH = 36;
    }
    return _scrollVc;
}

- (SimpleTableViewController *)oneVc{
    if (!_oneVc) {
        MJWeakSelf;
        _oneVc = [[SimpleTableViewController alloc] initWithCellClass:[OneButtonTableViewCell class] xib:false];
        _oneVc.cellBlock = ^(OneButtonTableViewCell* cell, ScreenModel* item2) {
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
        _oneVc.selectBlock = ^(NSIndexPath* item1, ScreenModel* item2) {
            [NSArray setValue:@(YES) keyPath:@"isSelected" deafaultValue:@(NO) index:item1.row inArray:((SimpleTableViewController*)weakSelf.scrollVc.controllers[weakSelf.index]).dataList];
            for (SimpleTableViewController* simpleVc in weakSelf.scrollVc.controllers) {
                [simpleVc reload];
            }
            if (weakSelf.scrollVc.controllers.count) {
                weakSelf.selectItems = [weakSelf.selectItems subarrayWithRange:NSMakeRange(0, weakSelf.index)].mutableCopy;
                [weakSelf.selectItems addObject:item2];
                NSMutableArray* controllers = [weakSelf.scrollVc.controllers subarrayWithRange:NSMakeRange(0, weakSelf.index+1)].mutableCopy;
                NSMutableArray* titles = [weakSelf.scrollVc.titles subarrayWithRange:NSMakeRange(0, weakSelf.index)].mutableCopy;
                if (item2.data.count) {
                    SimpleTableViewController* nextVc = [[SimpleTableViewController alloc] initWithCellClass:[OneButtonTableViewCell class] xib:false];
                    nextVc.selectBlock = weakSelf.oneVc.selectBlock;
                    nextVc.cellBlock = weakSelf.oneVc.cellBlock;
                    [nextVc updateDateList:item2.data];
                    [controllers addObject:nextVc];
                    [titles appendObjects:@[SafeText(item2.name),@"请选择"]];
                    NSInteger index = weakSelf.index + 1;
                    [weakSelf.scrollVc updateControllers:controllers titles:titles];
                    [weakSelf.scrollVc scrollWithIndex:index];
                }else{
                    [titles appendObjects:@[SafeText(item2.name)]];
                    [weakSelf.scrollVc updateTitles:titles];
                    if (weakSelf.selectBlock) {
                        [weakSelf hide];
                        weakSelf.selectBlock(item2);
                    }
                }
            }
        };
    }
    return _oneVc;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [NewAppColor yhapp_4color];
        _titleLab.text = @"所在地区";
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:@"btn_empty".imageFromSelf forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (NSMutableArray *)selectItems{
    if (!_selectItems) {
        _selectItems = [NSMutableArray array];
    }
    return _selectItems;
}

@end
