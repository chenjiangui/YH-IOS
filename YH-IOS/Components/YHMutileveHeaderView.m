//
//  YHMutileveHeaderView.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/8/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHMutileveHeaderView.h"

@implementation YHMutileveHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.backgroundColor = [UIColor whiteColor];
    // 标题
    self.titleLable =[[UILabel alloc]init];
    [self addSubview:_titleLable];
    self.titleLable.textColor = [NewAppColor yhapp_6color];
    self.titleLable.font = [UIFont boldSystemFontOfSize:13];
    self.titleLable.baselineAdjustment = NSTextAlignmentLeft;
    
    //分割线
    self.sepertView = [[UIView alloc]init];
    self.sepertView.backgroundColor = [NewAppColor yhapp_9color];
    [self addSubview:self.sepertView];
    
    [self layoutUI];
}


// 设置布局
-(void)layoutUI{
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
        make.left.mas_equalTo(self.mas_left).mas_offset(15);
    }];
    
    [self.sepertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).mas_offset(15);
        make.height.mas_equalTo(@1);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
    }];
}

@end
