//
//  JYRootScrollView.m
//  JYRootScrollView
//
//  Created by haha on 15/7/23.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "JYRootScrollView.h"
#import "UIView+Extension.h"
#import "JYRootScrollViewManager.h"
#import "JYSheetView.h"

#define JYRootScrollViewDefaultMargin 0

@interface JYRootScrollView()

@property (nonatomic, strong) NSMutableArray *pageViewFrames;
@property (nonatomic, strong) NSMutableDictionary *displayingPageViews;
@property (nonatomic, strong) NSMutableSet *reusePageViews;
@property (nonatomic, strong) JYRootScrollViewManager *manager;
@end

@implementation JYRootScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [[JYRootScrollViewManager alloc]initWithRootScrollView:self];
        self.rootScrollViewDateSource = _manager;
        self.rootScrollViewDelegate = _manager;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self reloadPageViews];
}

// 清理数据
- (void)cleanDate{
    [self.displayingPageViews.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayingPageViews removeAllObjects];
    [self.pageViewFrames removeAllObjects];
    [self.reusePageViews removeAllObjects];
}

// 重新加载页面数据
- (void)reloadPageViews{
    [self cleanDate];
    // rootScrollView 中 pages 的个数
    NSUInteger numberOfCells = [self.rootScrollViewDateSource numberOfCellInRootScrollView:self];
    if (numberOfCells == 0 || self.width == 0 || self.height == 0) return;
    
    // 获取上下左右的 margin
    CGFloat topMargin = [self marginForType:JYRootScrollViewMarginTypeTop];
    CGFloat bottomMargin = [self marginForType:JYRootScrollViewMarginTypeBottom];
    CGFloat leftMargin = [self marginForType:JYRootScrollViewMarginTypeLeft];
    CGFloat rightMargin = [self marginForType:JYRootScrollViewMarginTypeRight];
    
    CGFloat cellWidth = self.width - leftMargin - rightMargin;
    CGFloat cellHeght = self.height - topMargin - bottomMargin;
    CGFloat cellY = bottomMargin;
    // 这是时候 视图组已经被传递进来了，这个时候用来给每个视图加 frame, 用来布局 
    for (int i = 0; i < numberOfCells; i++) {
        // 给每个 page 设定 frame
        CGFloat cellX = i * (self.width) + leftMargin;
        CGRect cellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeght);
        // 判断是不是 jysheet 类，如果是的话，需要重新做布局
        if ([self.pageViews[0] isKindOfClass:[JYSheetView class]]) {
            cellX = i * (self.width) + leftMargin + JYDefaultMargin * 2;
            cellFrame = CGRectMake(cellX, cellY, cellWidth - JYDefaultMargin * 2, cellHeght);
        }
        NSValue *cellFrameValue = [NSValue valueWithCGRect:cellFrame];
        // 将获取好的每一个 pages 的视图的 frame 保存到一个数组中
        [self.pageViewFrames addObject:cellFrameValue];
    }
    // 计算 scrollView 的 contengtSize.
    self.contentSize = CGSizeMake(self.width * numberOfCells, 0);
    NSLog(@"pageViewFrames ---> count %ld",self.pageViews.count);
}

// cell 复用机制
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    __block JYRootScrollViewCell *reusableCell = nil;
    [self.reusePageViews enumerateObjectsUsingBlock:^(JYRootScrollViewCell *cell, BOOL *stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    if (reusableCell) {
        [self.reusePageViews removeObject:reusableCell];
    }
    return reusableCell;
}

// 根据类型设置 margin
- (CGFloat)marginForType:(JYRootScrollViewMarginType)type
{
    if ([self.rootScrollViewDelegate respondsToSelector:@selector(rootScrollView: marginForType:)]) {
        return [self.rootScrollViewDelegate rootScrollView:self marginForType:type];
    } else {
        return JYRootScrollViewDefaultMargin;
    }
}

/**
 *  判断一个frame有无显示在屏幕上
 */
- (BOOL)isInScreen:(CGRect)frame
{
    return (CGRectGetMaxX(frame) > self.contentOffset.x) &&
    (CGRectGetMinX(frame) < self.contentOffset.x + self.bounds.size.width);
}

// 布局子视图
- (void)layoutSubviews{
    [super layoutSubviews];
    //
    NSUInteger numberOfCells = self.pageViewFrames.count;
    for (int i = 0; i < numberOfCells; i++) {
        CGRect cellFrame = [self.pageViewFrames[i] CGRectValue];
        JYRootScrollViewCell *cell = self.displayingPageViews[@(i)];
        if ([self isInScreen:cellFrame]) {
            if (cell == nil) {
                cell = [self.rootScrollViewDateSource rootScrollView:self AtIndex:i];
                cell.frame = cellFrame;
                cell.tag = -1000 + i;
                [self addSubview:cell];
                // 存放到字典中
                self.displayingPageViews[@(i)] = cell;
            }
        }else{
            if (cell) {
                // 存放进缓存池
                [self.reusePageViews addObject:cell];
                // 从scrollView和字典中移除
                [cell removeFromSuperview];
                [self.displayingPageViews removeObjectForKey:@(i)];
            }
        }
    }
}

#pragma 懒加载
- (NSMutableArray *)pageViewFrames{
    if (!_pageViewFrames) {
        _pageViewFrames = [NSMutableArray array];
    }
    return _pageViewFrames;
}

- (NSMutableDictionary *)displayingPageViews{
    if (!_displayingPageViews) {
        _displayingPageViews = [NSMutableDictionary dictionary];
    }
    return _displayingPageViews;
}

- (NSMutableSet *)reusePageViews{
    if (!_reusePageViews) {
        _reusePageViews = [NSMutableSet set];
    }
    return _reusePageViews;
}

- (void)setPageViews:(NSMutableArray *)pageViews{
    _pageViews = pageViews;
    self.manager.pageViews = pageViews;
}

- (void)setMargin:(CGFloat)margin{
    _margin = margin;
    self.manager.margin = margin;
}


@end
