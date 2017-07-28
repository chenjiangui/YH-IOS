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
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.viewType == HudToolViewTypeLoading) {
        CGRect windowRect = CGRectMake((SCREEN_WIDTH-32)/2, (SCREEN_HEIGHT-32)/2, 32, 32);
        CGRect viewRect = [[HudToolView getTrueView:nil] convertRect:windowRect toView:self];
        self.loadingImageV.frame = viewRect;
    }
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
    }
    return _textLab;
}

@end
