//
//  ManageWarningCell.m
//  YH-IOS
//
//  Created by cjg on 2017/7/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "ManageWarningCell.h"
#import "ManageWarningItemCell.h"
#import "YHKPIModel.h"

@interface ManageWarningCell () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray* dataList;

@end

@implementation ManageWarningCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _titleLab.font = [UIFont boldSystemFontOfSize:16];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.showsHorizontalScrollIndicator = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setItem:(YHKPIModel*)item{
    if (_dataList != item.data) {
        _dataList = item.data;
        [_collection reloadData];
    }
    [self setupAutoHeightWithBottomView:self.collection bottomMargin:20];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ManageWarningItemCell* cell = [ManageWarningItemCell cellWithCollctionView:collectionView needXib:YES IndexPath:indexPath];
    YHKPIDetailModel* model = [_dataList objectAtIndex:indexPath.row];
    [cell setItem:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickBlock) {
        self.clickBlock(self.dataList[indexPath.row]);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [ManageWarningItemCell sizeForSelf];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 12;
}

@end
