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
        _infoLabel.font = [UIFont systemFontOfSize:14];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}

- (void)refreshSubViewData {
        NSMutableAttributedString * mutableAttributedString = [[NSMutableAttributedString alloc] initWithData:[self.infoModel.infoStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName : [UIFont systemFontOfSize:15] } documentAttributes:nil error:nil];
    self.infoLabel.attributedText = mutableAttributedString;
}

- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model {
    
    return 54;
}

@end
