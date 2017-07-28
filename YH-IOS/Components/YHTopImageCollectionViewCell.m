//
//  YHTopImageCollectionViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/15.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHTopImageCollectionViewCell.h"

@implementation YHTopImageCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    return self;
}


-(void)addViews{
    UIImageView *imageView = [[UIImageView alloc]init];
    self.imageView = imageView;
    [self addSubview:self.imageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.font = [UIFont systemFontOfSize:10];
    titleLable.textColor = [NewAppColor yhapp_3color];
    titleLable.numberOfLines = 2;
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLable;
    [self addSubview:self.titleLabel];
    
    
    [self layoutUI];
}

-(void)layoutUI{
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX).mas_offset(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(8);
        make.bottom.mas_equalTo(self.mas_bottom).mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX).mas_offset(0);
        make.width.mas_equalTo(@(65));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#666"];
    // Initialization code
}

@end
