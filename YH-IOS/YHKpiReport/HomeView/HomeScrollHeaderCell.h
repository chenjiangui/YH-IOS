//
//  HomeScrollHeaderCell.h
//  YH-IOS
//
//  Created by cjg on 2017/7/26.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScrollHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *yestodayLab;
@property (weak, nonatomic) IBOutlet UILabel *priceNumLab;
@property (weak, nonatomic) IBOutlet UILabel *priceDesLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;
@property (nonatomic, strong) CommonBack scanBlock;
@end
