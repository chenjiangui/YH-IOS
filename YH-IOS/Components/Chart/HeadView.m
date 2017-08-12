//
//  HeadView.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/8/12.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.backgroundColor = [UIColor whiteColor];
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.font = [UIFont boldSystemFontOfSize:14];
    self.locationLabel.textColor = [UIColor redColor];
    self.locationLabel.text = @"电话和大家数据撒白菜价啊";
    [self addSubview:self.locationLabel];
    
    [self addSubview:self.centerLine];
    [self addSubview:self.filterButton];
    [_filterButton layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:18];
    
    [self layoutUI];
    
}


- (UIView *)centerLine{
    if (!_centerLine) {
        _centerLine = [[UIView alloc] init];
        _centerLine.backgroundColor = [NewAppColor yhapp_9color];
    }
    return _centerLine;
}


- (UIButton *)filterButton{
    if (!_filterButton) {
        _filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filterButton setTitle:@"筛选" forState:UIControlStateNormal];
        [_filterButton setTitleColor:[NewAppColor yhapp_6color] forState:UIControlStateNormal];
        [_filterButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_filterButton setImage:@"pop_screen1".imageFromSelf forState:UIControlStateNormal];
        MJWeakSelf;
        [_filterButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (weakSelf.screenBlock) {
                weakSelf.screenBlock(sender);
            }
        }];
    }
    return _filterButton;
}



-(void)layoutUI{
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.locationLabel);
        make.right.mas_equalTo(self).offset(-24);
    }];
    
    [_centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.mas_bottom);
    }];
}

-(void)uploadLocatiol:(NSString *)location{
    self.locationLabel.text = location;
}

@end
