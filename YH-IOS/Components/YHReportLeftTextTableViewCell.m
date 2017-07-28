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
        [self addSubViews];
    }
    return self;
}


-(void)addSubViews{
    self.backgroundColor = [NewAppColor yhapp_8color];
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.textColor = [NewAppColor yhapp_6color];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.contentLabel];
    
    self.rightView = [[UIView alloc]init];
    self.rightView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.rightView];
    
    [self layoutUI];
}


-(void)layoutUI{
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).mas_offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(0);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(4, 20));
    }];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
   // self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
   // self.bottomSepLine.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    //  self.selectedBackgroundView.backgroundColor = [UIColor clearColor];// 设置选中cell的背景view背景色
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   // self.rightView.backgroundColor = [NewAppColor yhapp_1color];
   // self.rightView.backgroundColor = [NewAppColor yhapp_1color];
   // self.bottomSepLine.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
   // self.bottomSepLine.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    // Configure the view for the selected state
}

@end
