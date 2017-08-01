//
//  YHReportLeftTextTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/19.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHReportLeftTextTableViewCell.h"

@implementation YHReportLeftTextTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubViews];
    }
    return self;
}


-(void)addSubViews{
    self.backgroundColor = [NewAppColor yhapp_8color];
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.textColor = [NewAppColor yhapp_6color];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.contentLabel];
    
    self.rightView = [[UIView alloc]init];
    self.rightView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.rightView];
    
    self.leftView = [[UILabel alloc] init];
    self.leftView.text = @" ";
    self.leftView.backgroundColor = [NewAppColor yhapp_1color];
    [self.contentView addSubview:self.leftView];
    
    [self layoutUI];
}


-(void)layoutUI{
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(4, 20));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self).offset(-10);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(4, 20));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor = selected? [UIColor whiteColor]:[NewAppColor yhapp_8color];
    _contentLabel.textColor = selected? [NewAppColor yhapp_1color]:[NewAppColor yhapp_6color];
    _leftView.hidden = !selected;
}

@end
