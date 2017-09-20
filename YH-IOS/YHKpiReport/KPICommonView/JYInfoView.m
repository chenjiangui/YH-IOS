//
//  JYInfoView.m
//  各种报表
//
//  Created by niko on 17/5/14.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYInfoView.h"
#import "JYInfoModel.h"

@interface JYInfoView ()

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) JYInfoModel *infoModel;

@end

@implementation JYInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.infoLabel];
    }
    return self;
}

- (JYInfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = (JYInfoModel *)self.moduleModel;
    }
    return _infoModel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _infoLabel.font = [UIFont systemFontOfSize:15];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}

- (void)refreshSubViewData {
    if (self.infoModel.infoStr != nil && ![self.infoModel.infoStr isEqualToString:@""]) {
        NSMutableAttributedString * mutableAttributedString = [[NSMutableAttributedString alloc]initWithString:self.infoModel.infoStr];
        self.infoLabel.attributedText = mutableAttributedString;
    }
   // self.infoLabel.text =self.infoModel.infoStr;
}

- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model {
    
    return 54;
}

@end
