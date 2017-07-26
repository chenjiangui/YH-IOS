//
//  HomeNavBarView.m
//  YH-IOS
//
//  Created by cjg on 2017/7/26.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "HomeNavBarView.h"

@interface HomeNavBarView ()

@property (nonatomic, strong) UILabel* titleLab;

@property (nonatomic, strong) UIButton* scanBtn;

@end


@implementation HomeNavBarView

- (instancetype)init{
    self = [super init];
    if (self) {
       [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.backColorAlpha = 0;
    [self sd_addSubviews:@[self.titleLab,self.scanBtn]];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(20);
        make.bottom.centerX.mas_equalTo(self);
    }];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.bottom.mas_equalTo(self);
    }];
}

- (void)setBackColorAlpha:(CGFloat)backColorAlpha{
    _backColorAlpha = backColorAlpha;
     self.backgroundColor = [UIColorHex(32414b) appendAlpha:backColorAlpha];
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"生意概况";
        _titleLab.font = [UIFont boldSystemFontOfSize:17];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanBtn setImage:@"nav_scan".imageFromSelf forState:UIControlStateNormal];
        MJWeakSelf;
        [_scanBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (weakSelf.scanBlock) {
                weakSelf.scanBlock(sender);
            }
        }];
    }
    return _scanBtn;
}

@end
