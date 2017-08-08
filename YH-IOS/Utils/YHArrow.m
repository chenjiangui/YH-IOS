//
//  YHArrow.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/8/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHArrow.h"

@implementation YHArrow

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, 12, 5);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 三角形
    CGContextMoveToPoint(ctx, 0, 5);
    CGContextAddLineToPoint(ctx, 6, 0);
    CGContextAddLineToPoint(ctx, 12, 5);
    [[NewAppColor yhapp_5color] set];
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

@end
