//
//  JYCursor.m
//  JYScrollNavBar
//
//  Created by haha on 15/7/6.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "JYCursor.h"
#import "UIView+Extension.h"
#import "JYSortItemView.h"
#import "JYSortButton.h"
#import "UIColor+RGBA.h"
#import "JYItemManager.h"
#import "JYRootScrollView.h"
#import "JYAnimationTool.h"

#define navLineHeight                   6
#define defBackgroundColor              JYColor_BackgroudColor_SubWhite

@interface JYCursor()<UIScrollViewDelegate>

@property (nonatomic, strong) JYRootScrollView *rootScrollView;
@property (nonatomic, assign) BOOL             isLayout;
@property (nonatomic, assign) CGFloat          navBarH;

@end

@implementation JYCursor

#pragma mark - 初始化

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithTitles:(NSArray *)titles AndPageViews:(NSMutableArray *)pageViews{
    self = [super init];
    if (self) {
        self.titles = titles;
        self.pageViews = pageViews;
        [self setup];
    }
    return self;
}

// 将 rootScrollView 和 scrollNavBar 添加到当前视图中
- (void)setup{
    [self addSubview:self.rootScrollView];
    [self addSubview:self.scrollNavBar];
    self.userInteractionEnabled = YES;
    if (!self.backgroundColor) {
        self.backgroundColor        = defBackgroundColor;
    }
}

// 布局视图
- (void)layoutSubviews{
    [super layoutSubviews];
    
     // 设置 rootScrollView 的位置
    CGFloat rootScrollViewX = 0;
    CGFloat rootScrollViewY = self.navBarH+5;
    CGFloat rootScrollViewW = self.width;
    CGFloat rootScrollViewH = self.rootScrollViewHeight;
    self.rootScrollView.frame = CGRectMake(rootScrollViewX, rootScrollViewY, rootScrollViewW, rootScrollViewH);

    
    // 设置 顶部页签的 frame
    CGFloat scrollX         = 0;
    CGFloat scrollY         = 0;
    CGFloat scrollH         = 45;
    self.navBarH            = scrollH;
    CGFloat scrollW         = self.width;
    self.scrollNavBar.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
    
//    if (!self.isLayout) {
        [self.rootScrollView reloadPageViews];
//        self.isLayout = YES;
//    }
}

// 设置 rootScrollView 将要显示的视图组
- (void)setPageViews:(NSMutableArray *)pageViews{
    _pageViews = pageViews;
    
    self.scrollNavBar.pageViews = pageViews;
    _scrollNavBar.rootScrollView = self.rootScrollView;
}

// 设置scrollViewHight 的高度
- (void)setRootScrollViewHeight:(CGFloat)rootScrollViewHeight{
    _rootScrollViewHeight = rootScrollViewHeight;
    CGRect rect = self.frame;
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    if (self.navBarH == 0 ) {
        self.navBarH = h;
        h = h + self.rootScrollViewHeight;
    }
    CGRect frameChanged = CGRectMake(x, y, w, h);
    [self setFrame:frameChanged];
}

// 设置背景颜色
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:[UIColor clearColor]];
    self.scrollNavBar.backgroundColor = backgroundColor;
}


- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    [[JYItemManager shareitemManager] setScrollNavBar:self.scrollNavBar];
    // 通过 titles 来设置页签,这个里面主要包含了 页签按钮的初始化
    [[JYItemManager shareitemManager] setItemTitles:(NSMutableArray *)titles];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor{
    _titleNormalColor = titleNormalColor;
    self.scrollNavBar.titleNormalColor = titleNormalColor;
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor{
    _titleSelectedColor = titleSelectedColor;
    self.scrollNavBar.titleSelectedColor = titleSelectedColor;
}

- (void)setBackgroudSelectedColor:(UIColor *)backgroudSelectedColor {
    _backgroudSelectedColor = backgroudSelectedColor;
    self.scrollNavBar.backgroundSelectedColor = backgroudSelectedColor;
}


- (void)setMinFontSize:(NSInteger)minFontSize{
    _minFontSize = minFontSize;
    self.scrollNavBar.minFontSize = minFontSize;
}

- (void)setMaxFontSize:(NSInteger)maxFontSize{
    _maxFontSize = maxFontSize;
    self.scrollNavBar.maxFontSize = maxFontSize;
}

- (JYRootScrollView *)rootScrollView{
    if (!_rootScrollView) {
        _rootScrollView = [[JYRootScrollView alloc]init];
        _rootScrollView.pagingEnabled = YES;
    }
    return _rootScrollView;
}

- (JYScrollNavBar *)scrollNavBar{
    if (!_scrollNavBar) {
        _scrollNavBar = [[JYScrollNavBar alloc]init];
        _scrollNavBar.backgroundColor = [UIColor redColor];
    }
    return _scrollNavBar;
}

@end

