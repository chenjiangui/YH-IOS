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
    HudToolViewTypeEmpty
} HudToolViewType;

@interface HudToolView : UIView

@property (nonatomic, strong) UIView* contentView;

@property (nonatomic, assign) HudToolViewType viewType;

@property (nonatomic, strong) CommonBack touchBlock;

- (instancetype)initWithViewType:(HudToolViewType)viewType;


+ (void)removeInView:(UIView*)view viewType:(HudToolViewType)viewType;
// view nil为window
+ (void)showLoadingInView:(UIView*)view;
+ (void)hideLoadingInView:(UIView*)view;

+ (void)showTopWithText:(NSString*)text color:(UIColor*)color;
+ (void)showTopWithText:(NSString*)text correct:(BOOL)correct;

+ (instancetype)view:(UIView*)view showEmpty:(BOOL)show;

@end
