//
//  JYRootScrollViewCell.m
//  JYRootScrollView
//
//  Created by haha on 15/7/23.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "JYRootScrollViewCell.h"
#import "JYRootScrollView.h"

@interface JYRootScrollViewCell()

@end

@implementation JYRootScrollViewCell

+ (id)cellWithRootScrollView:(JYRootScrollView *)rootScrollView{
    static NSString *cellID = @"CELL";
    JYRootScrollViewCell *cell = [rootScrollView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[JYRootScrollViewCell alloc] init];
        cell.identifier = cellID;
    }
    return cell;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


// 添加 pageView 了
- (void)setpageViewInCell:(UIView *)pageView{
    // 将视图上的所有视图全部清除。
    if (self.subviews.count) {
       [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self addSubview:pageView];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    UIView *pageView =  self.subviews[0];
    pageView.frame = self.bounds;
}
@end
