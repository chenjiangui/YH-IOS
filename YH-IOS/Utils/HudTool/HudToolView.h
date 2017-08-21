//
//  HudToolView.h
//  YH-IOS
//
//  Created by cjg on 2017/7/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HudToolViewTypeText,
    HudToolViewTypeLoading,
    HudToolViewTypeTopText,
    HudToolViewTypeEmpty,
    HudToolViewTypeNetworkBug
} HudToolViewType;

@interface HudToolView : UIView

@property (nonatomic, strong) UIView* contentView;

@property (nonatomic, assign) HudToolViewType viewType;

@property (nonatomic, strong) CommonBack touchBlock;

- (instancetype)initWithViewType:(HudToolViewType)viewType;


+ (void)removeInView:(UIView*)view viewType:(HudToolViewType)viewType;
#pragma mark - 显示或掩藏菊花图
+ (HudToolView*)showLoadingInView:(UIView*)view;

+ (void)hideLoadingInView:(UIView*)view;

#pragma mark - 显示上方tip
+ (void)showTopWithText:(NSString*)text
                  color:(UIColor*)color;

+ (void)showTopWithText:(NSString*)text
                correct:(BOOL)correct;

#pragma mark - 显示网络异常页
+ (instancetype)showNetworkBug:(BOOL)show view:(UIView*)view;

#pragma mark - 显示app提示文字
+ (instancetype)showText:(NSString*)text
                    time:(NSTimeInterval)time
              isAutoTime:(BOOL)isAuto;

+ (instancetype)showText:(NSString*)text;


@end
