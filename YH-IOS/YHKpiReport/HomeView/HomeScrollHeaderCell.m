//
//  HomeScrollHeaderCell.m
//  YH-IOS
//
//  Created by cjg on 2017/7/26.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "HomeScrollHeaderCell.h"
#import "SDCycleScrollView.h"

@interface HomeScrollHeaderCell ()

@property (nonatomic, strong) SDCycleScrollView* cycleView;

@end

@implementation HomeScrollHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (SDCycleScrollView *)cycleView{
//    if (!_cycleView) {
//        _cycleView = [SDCycleScrollView alloc] ini
//    }
//}

@end
