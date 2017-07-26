//
//  LogoutTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "LogoutTableViewCell.h"

@implementation LogoutTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutViews];
    }
    return self;
}


-(void)layoutViews {
    
    self.logoutButton = [[UIButton alloc]init];
    [self addSubview:self.logoutButton];
    self.logoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.logoutButton setTitleColor:[UIColor colorWithHexString:@"#f57658"] forState:UIControlStateNormal];
    [self.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    
    [self layoutUI];
}

- (void) layoutUI {
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
<<<<<<< HEAD
        make.size.mas_equalTo(self.size);
=======
        make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width, self.contentView.bounds.size.height));
>>>>>>> 984a26d9e41dd871f441813af354726205d75909
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
