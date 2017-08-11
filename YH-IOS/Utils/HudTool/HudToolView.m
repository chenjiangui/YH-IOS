//
//  HudToolView.m
//  YH-IOS
//
//  Created by cjg on 2017/7/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "HudToolView.h"

@interface HudToolView ()

@property (nonatomic, strong) UIImageView* loadingImageV;
@property (nonatomic, strong) UILabel* textLab;
@property (nonatomic, strong) NSMutableArray* images;
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
        case HudToolViewTypeNetworkBug:
            [self setNetworkBugType];
            break;
        case HudToolViewTypeText:
            [self setTextType];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchBlock) {
        self.touchBlock(self);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.viewType == HudToolViewTypeLoading) {
        CGRect windowRect = CGRectMake((SCREEN_WIDTH-32)/2, (SCREEN_HEIGHT-32)/2, 32, 32);
        CGRect viewRect = [[HudToolView getTrueView:nil] convertRect:windowRect toView:self];
        self.loadingImageV.frame = viewRect;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGRect rect = [self.loadingImageV.superview convertRect:self.loadingImageV.frame toView:[HudToolView getTrueView:nil]];
            if (!CGRectEqualToRect(rect, windowRect)) {
                [self layoutSubviews];
            }
        });
    }
    if (self.viewType == HudToolViewTypeNetworkBug) {
        CGFloat width = SCREEN_WIDTH;
        CGFloat height = _loadingImageV.image.size.height + 14 + 12;
        CGRect windowRect = CGRectMake((SCREEN_WIDTH-width)/2, (SCREEN_HEIGHT-height)/2, width, height);
        CGRect viewRect = [[HudToolView getTrueView:nil] convertRect:windowRect toView:self];
        self.contentView.frame = viewRect;
    }
}

#pragma mark - HudToolViewTypeText
+ (instancetype)showText:(NSString*)text time:(NSTimeInterval)time isAutoTime:(BOOL)isAuto{
    if (time<=0) {
        time = 0.8;
    }
    if (isAuto) {
        if (text.length<20) {
            time = 1.2;
        }else if (text.length>40){
            time = 1.8;
        }else{
            time = 1.6;
        }
    }
    [self removeInView:nil viewType:HudToolViewTypeText];
    HudToolView* hud = [[HudToolView alloc] initWithViewType:HudToolViewTypeText];
    hud.textLab.text = text;
    UIView* window = [self getTrueView:nil];
    [window addSubview:hud];
    [hud.textLab sizeToFit];
    hud.sd_layout.bottomSpaceToView(window, 85).centerXEqualToView(window);
    [hud setupAutoWidthWithRightView:hud.textLab rightMargin:20];
    [hud setupAutoHeightWithBottomView:hud.textLab bottomMargin:10];
    hud.alpha = 0;
    hud.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.2 animations:^{
        hud.alpha = 1;
        hud.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                hud.alpha = 0;
                hud.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                if (hud && hud.superview) {
                    [hud removeFromSuperview];
                }
            }];
        });
    }];
    return hud;
}

+ (instancetype)showText:(NSString*)text{
    return [self showText:text time:0 isAutoTime:YES];
}

- (void)setTextType{
    self.backgroundColor = [UIColorHex(222222) colorWithAlphaComponent:0.85];
    [self cornerRadius:5];
    [self sd_addSubviews:@[self.textLab]];
    [_textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self).offset(10);
        make.width.mas_lessThanOrEqualTo(190);
        make.height.mas_lessThanOrEqualTo(30);
    }];
}


#pragma mark - HudToolViewTypeNetworkBug
+ (instancetype)showNetworkBug:(BOOL)show view:(UIView *)view{
    [self removeInView:view viewType:HudToolViewTypeNetworkBug];
    if (show) {
        HudToolView* hud = [[HudToolView alloc] initWithViewType:HudToolViewTypeNetworkBug];
        [view addSubview:hud];
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(view);
        }];
        return hud;
    }
    return nil;
}

- (void)setNetworkBugType{
    [self sd_addSubviews:@[self.contentView]];
    [self.contentView sd_addSubviews:@[self.textLab,self.loadingImageV]];
    self.backgroundColor = [NewAppColor yhapp_8color];
    self.textLab.text = @"网络异常,点击屏幕重试";
    self.textLab.font = [UIFont systemFontOfSize:14];
    self.textLab.textColor = [NewAppColor yhapp_4color];
    self.loadingImageV.image = @"icon_netbug".imageFromSelf;
    [_textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(_contentView);
        make.height.mas_equalTo(14);
    }];
    [_loadingImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_contentView);
        make.top.mas_equalTo(_textLab.mas_bottom).offset(12);
        make.size.mas_equalTo(_loadingImageV.image.size);
    }];
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
    NSMutableArray* images = [NSMutableArray array];
    for (int i=0; i<24; i++) {
        NSString* imageName = [@"loading_000" stringByAppendingString:@(i).stringValue];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    _loadingImageV.animationImages = images;
    _loadingImageV.animationDuration = 1;
    [_loadingImageV startAnimating];
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
        _loadingImageV = [[UIImageView alloc] init];
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
