//
//  OneButtonCollectionCell.m
//  YH-IOS
//
//  Created by cjg on 2017/8/3.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "OneButtonCollectionCell.h"

@implementation OneButtonCollectionCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self sd_addSubviews:@[self.button]];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:[NewAppColor yhapp_3color] forState:UIControlStateNormal];
        _button.userInteractionEnabled = false;
    }
    return _button;
}

@end
