//
//  ScreenHeaderView.m
//  YH-IOS
//
//  Created by cjg on 2017/8/3.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "ScreenHeaderView.h"
#import "OneButtonCollectionCell.h"

@interface ScreenHeaderView () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UIButton* topLeftBtn;
@property (nonatomic, strong) UIButton* topRightBtn;
@property (nonatomic, strong) UICollectionView* collection;
@property (nonatomic, strong) UIView* centerLine;
@property (nonatomic, strong) UIView* bottomLine;
@end

@implementation ScreenHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setAreaModel:(ScreenModel *)areaModel{
    [_topLeftBtn setTitle:areaModel.name forState:UIControlStateNormal];
    _topLeftBtn.selected = YES;
}

- (void)setData:(NSArray *)data{
    _dataList = data;
    [self.collection reloadData];
}

- (void)reload{
    [self.collection reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.locationBlock) {
        self.locationBlock(indexPath,_dataList[indexPath.row]);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OneButtonCollectionCell* cell = [OneButtonCollectionCell cellWithCollctionView:collectionView needXib:false IndexPath:indexPath];
    ScreenModel* model = [_dataList objectAtIndex:indexPath.row];
    [cell.button setImage:@"ic_arrow_down".imageFromSelf forState:UIControlStateNormal];
    [cell.button setImage:@"ic_arrow_up".imageFromSelf forState:UIControlStateSelected];
    [cell.button setTitleColor:[NewAppColor yhapp_1color] forState:UIControlStateSelected];
    [cell.button setTitle:model.category forState:UIControlStateNormal];
    cell.button.selected = model.isSelected;
    [cell.button layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:8];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataList.count;
}

- (void)setupUI{
    [self sd_addSubviews:@[self.topLeftBtn,self.topRightBtn,self.centerLine,self.collection,self.bottomLine]];
    [_topLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(40);
    }];
    [_topRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(_topLeftBtn);
        make.right.mas_equalTo(self).offset(-24);
    }];
    [_centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(_topLeftBtn.mas_bottom);
    }];
    [_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_centerLine.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(_collection.mas_bottom);
    }];
    [_topLeftBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:15];
    [_topRightBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:6];
}



#pragma mark - lazy
- (UIButton *)topLeftBtn{
    if (!_topLeftBtn) {
        _topLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topLeftBtn setTitle:@"获取当前位置" forState:UIControlStateNormal];
        [_topLeftBtn setTitleColor:[NewAppColor yhapp_4color] forState:UIControlStateNormal];
        [_topLeftBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [_topLeftBtn setImage:@"ic_location".imageFromSelf forState:UIControlStateNormal];
        [_topLeftBtn setTitleColor:[NewAppColor yhapp_15color] forState:UIControlStateSelected];
    }
    return _topLeftBtn;
}

- (UIButton *)topRightBtn{
    if (!_topRightBtn) {
        _topRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topRightBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [_topRightBtn setTitleColor:[NewAppColor yhapp_6color] forState:UIControlStateNormal];
        [_topRightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_topRightBtn setImage:@"pop_screen".imageFromSelf forState:UIControlStateNormal];
        MJWeakSelf;
        [_topRightBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (weakSelf.screenBlock) {
                weakSelf.screenBlock(sender);
            }
        }];
    }
    return _topRightBtn;
}

- (UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH/4.0, 40);
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.backgroundColor = self.backgroundColor;
        _collection.showsHorizontalScrollIndicator = NO;
    }
    return _collection;
}

- (UIView *)centerLine{
    if (!_centerLine) {
        _centerLine = [[UIView alloc] init];
        _centerLine.backgroundColor = [NewAppColor yhapp_9color];
    }
    return _centerLine;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [NewAppColor yhapp_9color];
    }
    return _bottomLine;
}

@end
