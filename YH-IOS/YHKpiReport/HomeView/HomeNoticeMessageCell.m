//
//  HomeNoticeMessageCell.m
//  YH-IOS
//
//  Created by cjg on 2017/7/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "HomeNoticeMessageCell.h"
#import "SDCycleScrollView.h"
#import "ToolModel.h"

@interface HomeNoticeMessageCell () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView* cycleScrollView;

@property (nonatomic, strong) UIImageView* imageV;

@property (nonatomic, strong) NSArray* dataList;

@property (nonatomic, strong) UILabel* tipLab;

@end

@implementation HomeNoticeMessageCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.clipsToBounds = YES;
    self.backgroundColor = [NewAppColor yhapp_6color];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self sd_addSubviews:@[self.imageV,self.tipLab,self.cycleScrollView]];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.left.mas_equalTo(self).offset(42);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(38);
    }];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.imageV.image.size);
        make.right.mas_equalTo(self.tipLab.mas_left).offset(-10);
        make.centerY.mas_equalTo(self);
    }];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipLab.mas_right);
        make.top.bottom.mas_equalTo(_tipLab);
        make.right.mas_equalTo(self).offset(-15);
    }];
    return self;
}

- (void)setItem:(ToolModel*)item{
    if (item) {
        if (self.dataList != item.data) {
            self.dataList = item.data;
            NSMutableArray* strs = [NSMutableArray array];
            for (ToolModel* model in item.data) {
                [strs addObject:SafeText(model.title)];
            }
            self.cycleScrollView.titlesGroup = strs;
        }
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.selectBlock) {
        self.selectBlock(self.dataList[index]);
    }
}

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(80, 13.5, SCREEN_WIDTH-95, 13) delegate:self placeholderImage:nil];
        _cycleScrollView.backgroundColor = [UIColor clearColor];
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cycleScrollView.onlyDisplayText = YES;
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        _cycleScrollView.titleLabelTextFont = [UIFont systemFontOfSize:13];
        _cycleScrollView.titleLabelTextAlignment = NSTextAlignmentLeft;
        [_cycleScrollView disableScrollGesture];
    }
    return _cycleScrollView;
}

- (UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.text = @"[推荐]";
        _tipLab.font = [UIFont systemFontOfSize:13];
        _tipLab.textColor = [NewAppColor yhapp_7color];
    }
    return _tipLab;
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithImage:@"icon_new".imageFromSelf];
    }
    return _imageV;
}

@end
