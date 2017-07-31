//
//  HudToolView.m
//  YH-IOS
//
//  Created by cjg on 2017/7/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "HudToolView.h"

@interface HudToolView ()
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIImageView* loadingImageV;
@property (nonatomic, strong) UILabel* textLab;
@end

@implementation HudToolView

- (instancetype)initWithViewType:(HudToolViewType)viewType{
    self = [super init];
    self.backgroundColor = [UIColor clearColor];
    self.viewType = viewType;
    switch (viewType) {
        case HudToolViewTypeLoading:
            [self setLoadingType];
            break;
        case HudToolViewTypeTopText:
            [self setTopTextType];
            break;
        default:
            break;
    }
    return self;
}

+ (UIView*)getTrueView:(UIView*)view{
    if (view) {
        return view;
    }
    return [UIApplication sharedApplication].keyWindow;
}

+ (void)removeInView:(UIView*)view viewType:(HudToolViewType)viewType{
    view = [self getTrueView:view];
    for (HudToolView* hud in view.subviews) {
        if ([hud isKindOfClass:[HudToolView class]]) {
            if (hud.viewType == viewType) {
                [hud removeFromSuperview];
            }
        }
    }
    if (viewType == HudToolViewTypeTopText) {
        [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.viewType == HudToolViewTypeLoading) {
        CGRect windowRect = CGRectMake((SCREEN_WIDTH-32)/2, (SCREEN_HEIGHT-32)/2, 32, 32);
        CGRect viewRect = [[HudToolView getTrueView:nil] convertRect:windowRect toView:self];
        self.loadingImageV.frame = viewRect;
    }
}

#pragma mark - HudToolViewTypeTopText
- (void)setTopTextType{
    [self sd_addSubviews:@[self.contentView]];
    [self.contentView addSubview:self.textLab];
    self.contentView.frame = CGRectMake(0, -44, SCREEN_WIDTH, 44);
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.height.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView).offset(-30);
    }];
}

+ (void)showTopWithText:(NSString *)text color:(UIColor *)color{
    UIWindow* view = (UIWindow*)[self getTrueView:nil];
    [self removeInView:view viewType:HudToolViewTypeTopText];
    HudToolView* hud = [[HudToolView alloc] initWithViewType:HudToolViewTypeTopText];
    hud.frame = CGRectMake(0, 0, view.width, 44);
    view.windowLevel = UIWindowLevelAlert;
    hud.textLab.text = text;
    hud.contentView.backgroundColor = color;
    hud.alpha = 0.2;
    [view addSubview:hud];
    [UIView animateWithDuration:0.3 animations:^{
        hud.contentView.top = 0;
        hud.alpha = 1;
    } completion:^(BOOL finished) {
        if (hud.superview) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    hud.contentView.top = -44;
                    hud.alpha = 0.2;
                } completion:^(BOOL finished) {
                    if (hud.superview) {
                        [self removeInView:nil viewType:HudToolViewTypeTopText];
                    }
                }];
            });

        }
    }];
}

+ (void)showTopWithText:(NSString *)text correct:(BOOL)correct{
    [self showTopWithText:text color:correct ? [NewAppColor yhapp_1color]: [NewAppColor yhapp_11color]];
}

#pragma mark - loadingType
- (void)setLoadingType{
    [self sd_addSubviews:@[self.loadingImageV]];
}

+ (void)showLoadingInView:(UIView *)view{
    view = [self getTrueView:view];
    HudToolView* hud = [[HudToolView alloc] initWithViewType:HudToolViewTypeLoading];
    [view addSubview:hud];
    [hud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
}

+ (void)hideLoadingInView:(UIView *)view{
    [self removeInView:view viewType:HudToolViewTypeLoading];
}

#pragma mark - lazy

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _contentView;
}

- (UIImageView *)loadingImageV{
    if (!_loadingImageV) {
        NSMutableArray* images = [NSMutableArray array];
        for (int i=0; i<24; i++) {
            NSString* imageName = [@"loading_000" stringByAppendingString:@(i).stringValue];
            [images addObject:[UIImage imageNamed:imageName]];
        }
        _loadingImageV = [[UIImageView alloc] init];
        _loadingImageV.animationImages = images;
        _loadingImageV.animationDuration = 1;
        [_loadingImageV startAnimating];
    }
    return _loadingImageV;
}

- (UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc] init];
        _textLab.textAlignment = NSTextAlignmentCenter;
        _textLab.numberOfLines = 2;
        _textLab.textColor = [NewAppColor yhapp_10color];
        _textLab.font = [UIFont systemFontOfSize:16];
    }
    return _textLab;
}

@end
