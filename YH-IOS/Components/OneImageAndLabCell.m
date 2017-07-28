//
//  OneImageAndLabCell.m
//  YH-IOS
//
//  Created by cjg on 2017/7/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "OneImageAndLabCell.h"

@implementation OneImageAndLabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    [self sd_addSubviews:@[self.imageV,self.contentLab]];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerY.mas_equalTo(self).offset(-12);
    }];
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_imageV.mas_bottom).offset(12);
        make.left.mas_equalTo(self).offset(5);
        make.height.mas_equalTo(12);
    }];
    
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
    }
    return _imageV;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:12];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.textColor = [NewAppColor yhapp_3color];
    }
    return _contentLab;
}

@end
