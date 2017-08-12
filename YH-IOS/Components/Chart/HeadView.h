//
//  HeadView.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/8/12.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommonBack)(id item);

@interface HeadView : UIView

@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) CommonBack screenBlock;
@property (nonatomic, strong) UIView *centerLine;

-(void)uploadLocatiol:(NSString *)location;
@end
