//
//  HomeScrollHeaderCell.m
//  YH-IOS
//
//  Created by cjg on 2017/7/26.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "HomeScrollHeaderCell.h"
#import "SDCycleScrollView.h"
#import "YHKPIModel.h"

@interface HomeScrollHeaderCell () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView* cycleView;

@property (nonatomic, strong) YHKPIModel* kpiModel;

@property (nonatomic, assign) NSInteger index;

@end

@implementation HomeScrollHeaderCell

- (void)setIndex:(NSInteger)index{
    _index = index;
    YHKPIDetailModel* detail = _kpiModel.data[index];
    _yestodayLab.text = [NSString stringWithFormat:@"%@%@",detail.memo1,detail.hightLightData.compare];
    _priceNumLab.text = [NSString stringWithFormat:@"%@",detail.hightLightData.number];
    _unitLab.text = detail.unit;
    _priceDesLab.text = detail.memo2;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView insertSubview:self.cycleView atIndex:0];
    [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(self.mas_height);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setItem:(YHKPIModel*)item{
    _kpiModel = item;
    if (item.data.count) {
        NSMutableArray* images = [NSMutableArray array];
        for (int i = 0; i<item.data.count; i++) {
            [images addObject:item.data[i].title];
        }
        _cycleView.imageURLStringsGroup = images;
        if (self.index == 0) {
            self.index = 0;
        }
    }else{
        self.hidden = YES;
    }
    [self setupAutoHeightWithBottomView:self.cycleView bottomMargin:0];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.clickBlock) {
        self.clickBlock(@(index));
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
//    detail.hightLightData.number
    self.index = index;

}

- (SDCycleScrollView *)cycleView{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 194) delegate:self placeholderImage:@"banner".imageFromSelf];
        _cycleView.autoScrollTimeInterval = 3;
        _cycleView.pageDotColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleView.pageControlDotSize = CGSizeMake(5, 5);
        _cycleView.pageControlRightOffset = 13;
    }
    return _cycleView;
}

@end
