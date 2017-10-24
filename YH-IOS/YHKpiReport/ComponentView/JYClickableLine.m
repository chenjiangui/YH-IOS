//
//  JYClickableLine.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYClickableLine.h"

@interface JYClickableLine () {
    
    
    __block CGFloat maxValue;
    __block CGFloat minValue;
    CGFloat margin;
}

@property (nonatomic, strong) NSArray <CAShapeLayer *> * linelayerList; // 折线列表
@property (nonatomic, strong) NSArray <UIColor *> *lineColorList; // 多条折线的颜色列表
@property (nonatomic, strong) NSArray <NSArray <NSNumber *> *> *dataSource; // 多条折线的关键点处理前列表
@property (nonatomic, strong) NSArray <NSArray <NSString *> *> *keyPointsList; // 关键点处理后列表
@property (nonatomic, strong) NSArray <UIView *> *flagPointList; // 圆圈⭕️列表
@property (nonatomic, assign) CGFloat zeroLineHeight;

@end

@implementation JYClickableLine

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.zeroLineHeight = self.bounds.size.height;
        [self addGesture];
    }
    return self;
}

- (void)addGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    [self addGestureRecognizer:pan];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self addLine];
}

//- (void)setDataList:(NSArray *)dataList {
//    if (![_dataList isEqual:dataList]) {
//        _dataList = dataList;
//        self.dataSource = dataList;
//    }
//}

- (void)setLineParms:(NSDictionary<NSString *,NSDictionary *> *)lineParms {
    if (![_lineParms isEqual:lineParms]) {
        
        NSMutableArray *lineColorListTemp = [NSMutableArray array];
        NSMutableArray *lineDataListTemp = [NSMutableArray array];
        for (NSDictionary *dic in [lineParms allValues]) {
            [lineColorListTemp addObject:dic[@"color"]];
            [lineDataListTemp addObject:dic[@"data"]];
        }
        self.lineColorList = [lineColorListTemp copy];
        self.dataSource = [lineDataListTemp copy];
    }
}

- (NSArray<UIView *> *)flagPointList {
    if (!_flagPointList) {
        NSMutableArray *flagTemp = [NSMutableArray array];
        for (UIColor *lineColor in self.lineColorList) {
            UIView *flagPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            flagPoint.layer.cornerRadius = 10;
            flagPoint.backgroundColor = [lineColor appendAlpha:0.15];
            flagPoint.hidden = YES;
            
            UIView *point = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 10, 10)];
            point.backgroundColor = [UIColor whiteColor];
            point.layer.cornerRadius = 5;
            point.layer.borderWidth = 2;
            point.layer.borderColor = lineColor.CGColor;
            [flagPoint addSubview:point];
            
            [self addSubview:flagPoint];
            [flagTemp addObject:flagPoint];
        }
        _flagPointList = [flagTemp copy];
    }
    return _flagPointList;
}

- (void)setDataSource:(NSArray<NSArray<NSNumber *> *> *)dataSource {
    if (![_dataSource isEqual:dataSource]) {
        _dataSource = dataSource;
        [self formatterPoints];
        
        [self setNeedsDisplay];
    }
}

- (void)setLineColorList:(NSArray<UIColor *> *)lineColorList {
    if (![_lineColorList isEqual:lineColorList]) {
        _lineColorList = lineColorList;
        
        for (int i = 0; i < self.linelayerList.count; i++) {
            CAShapeLayer *line = self.linelayerList[i];
            line.strokeColor = self.lineColorList[i].CGColor;
        }
    }
    [self setNeedsDisplay];
}


- (void)formatterPoints {
    
    NSInteger keyPointCountMax = 0;
    // 设置有多少个关键点
    for (NSArray *keyPoints in self.dataSource) {
        keyPointCountMax = keyPoints.count > keyPointCountMax ? keyPoints.count : keyPointCountMax;
    }
    // 获取间隔
    margin = CGRectGetWidth(self.frame) / (keyPointCountMax - 1);
    maxValue = 0.0;
    minValue = 0.0;
    
    // 获取y轴的最大值和最小值
    for (NSArray *lineData in self.dataSource) {
        for (NSNumber *number in lineData) {
            maxValue = maxValue > [number floatValue] ? maxValue : [number floatValue];
            minValue = minValue > [number floatValue] ? [number floatValue] : minValue;
        }
    }
    
    NSMutableArray *keyPointsListTemp = [NSMutableArray array];
    CGFloat allheight = maxValue - minValue;
    // 获取在该视图中的每一个数值点的高度
    CGFloat onePontWidth = CGRectGetHeight(self.frame)/allheight;
    // 遍历整个所有的线图
    for (NSArray *keyPoints in self.dataSource) {
        // 定义点的数组
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:keyPoints.count];
        //遍历数组中的每个元素
        for (int i = 0; i < keyPoints.count; i++) {
            // 获取每个元素在该视图中的点的位置
//            CGFloat y = CGRectGetHeight(self.frame) * (1 - [keyPoints[i] floatValue] / maxValue) + JYViewHeight * 0.1;
                CGFloat y =  CGRectGetHeight(self.frame) - (([keyPoints[i] floatValue] - minValue)*onePontWidth);
                CGFloat x = (margin * i + JYDefaultMargin * 2) * 0.9; // 按比率缩小x轴，避免标记点显示不全的问题
                CGPoint point = CGPointMake(x, y);
                [points addObject:NSStringFromCGPoint(point)];
            
        }
        // 把每个元素的位置对应的算出来
        [keyPointsListTemp addObject:[points copy]];
    }
    
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:2];
    CGPoint zeroPointOne = CGPointMake(-10,  maxValue*onePontWidth);
    self.zeroLineHeight = maxValue*onePontWidth;
    CGPoint zeroPointTwo = CGPointMake(CGRectGetWidth(self.frame), maxValue*onePontWidth);
    [points addObject:NSStringFromCGPoint(zeroPointOne)];
    [points addObject:NSStringFromCGPoint(zeroPointTwo)];
    [keyPointsListTemp addObject:[points copy]];
    
    self.keyPointsList = [keyPointsListTemp copy];
}

- (NSArray *)points {
    NSInteger keyPointCountMax = [self.dataSource firstObject].count, maxLineIndex = 0;
    for (int i = 0; i < self.dataSource.count; i++) {
        maxLineIndex = self.dataSource[i].count > keyPointCountMax ? i : maxLineIndex;
    }
    return [self.keyPointsList[maxLineIndex] copy];
}


- (void)addLine {
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (int i = 0; i < self.keyPointsList.count; i++) {
        NSArray *pointList = self.keyPointsList[i];
        UIBezierPath *layerPath = [UIBezierPath bezierPath];
        for (int i = 0; i < pointList.count; i++) {
            CGPoint point = CGPointFromString(pointList[i]);
            if (i == 0) {
                [layerPath moveToPoint:point];
            }
            [layerPath addLineToPoint:point];
        }
        layerPath.lineJoinStyle = kCGLineJoinRound;
        CAShapeLayer *linelayer = [CAShapeLayer layer];
        linelayer.lineWidth = 2;
        linelayer.strokeEnd = 0.0;
        linelayer.strokeEnd = 1.0;
        linelayer.path = layerPath.CGPath;
        linelayer.fillColor = [UIColor clearColor].CGColor;
        if(i<self.keyPointsList.count-1){
        linelayer.strokeColor = (self.lineColorList[i] ?: [UIColor whiteColor]).CGColor;
        }
        else{
            linelayer.strokeColor = [UIColor lightGrayColor].CGColor;
            linelayer.lineWidth = 1;
        }
        linelayer.lineCap = kCALineCapSquare;
        linelayer.lineJoin = kCALineJoinMiter;
        
        UIBezierPath *layerPath2 = [UIBezierPath bezierPath];
        for (int j = 0; j < pointList.count; j++) {
            CGPoint point = CGPointFromString(pointList[j]);
            [layerPath2 moveToPoint:CGPointMake(point.x-6*(i-1), point.y)];
            [layerPath2 addLineToPoint:CGPointMake(point.x-6*(i-1), _zeroLineHeight)];
        }
        layerPath2.lineJoinStyle = kCGLineJoinRound;
        CAShapeLayer *linelayer2 = [CAShapeLayer layer];
        linelayer2.lineWidth = 6;
//        linelayer2.strokeEnd = 0.0;
//        linelayer2.strokeEnd = 1.0;
        linelayer.backgroundColor = [UIColor clearColor].CGColor;
        linelayer2.path = layerPath2.CGPath;
        linelayer2.fillColor = [UIColor clearColor].CGColor;
        if(i<self.keyPointsList.count-1){
            linelayer2.strokeColor = (self.lineColorList[i] ?: [UIColor whiteColor]).CGColor;
        }
        else{
            linelayer2.strokeColor = [UIColor lightGrayColor].CGColor;
            linelayer2.lineWidth = 1;
        }
//        linelayer2.lineCap = kCALineCapSquare;
//        linelayer2.lineJoin = kCALineJoinMiter;
        [self.layer addSublayer:linelayer2];
         [self.layer addSublayer:linelayer];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @0.0;
        animation.toValue = @1.0;
        animation.duration = 0.5;
        [linelayer addAnimation:animation forKey:nil];
    }
    
    [self performSelector:@selector(showFlagPoint) withObject:nil afterDelay:0.6];
}

- (void)showFlagPoint {
    
//    NSInteger maxLength = 0, maxIndex = 0;
//    for (int i = 0; i < self.flagPointList.count; i++) {
//        maxIndex = self.dataSource[i].count > maxLength ? i : maxIndex;
//        self.flagPointList[i].center = CGPointFromString([self.keyPointsList[i] lastObject]);
//    }
//
//    self.flagPointList[maxIndex].hidden = NO;
}

- (void)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    
    [self findNearestKeyPointOfPoint:[gestureRecognizer locationInView:self]];
}

// 寻找最近的点
- (void)findNearestKeyPointOfPoint:(CGPoint)point {
    
    if (point.x < 0) { // 超出左边界不处理
        return;
    }
    
    CGPoint keyPoint = CGPointMake(NSIntegerMax, NSIntegerMax);
    // 遍历每一个元素点
    for (NSInteger i = 0; i < self.keyPointsList.count-1; i++) {
        self.flagPointList[i].hidden = NO;
        
        for (int j = 0; j < self.keyPointsList[i].count; j++) {
            NSString *pointStr = self.keyPointsList[i][j];
            // 使用获取的点来初始化 keyPoint
            keyPoint = CGPointFromString(pointStr);
            // 算出离那个点比较近
            if (fabs(keyPoint.x - point.x) < margin / 2) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(clickableLine:didSelected:data:)]) {
                    [self.delegate clickableLine:self didSelected:j data:self.dataSource[i][j]];
                }
                
                //NSLog(@"the nearest point is index at %zi", i + 1);
                [UIView animateWithDuration:0.25 animations:^{
                    self.flagPointList[i].center = keyPoint;
                }];
                break;
            }
        }
    }
    
    int index = 0;
    for (NSArray<NSString *> *points in self.keyPointsList) {
        CGPoint lastPoint = CGPointFromString([points lastObject]);
        if ((lastPoint.x < keyPoint.x)) {
            self.flagPointList[index].hidden = YES;
        }
        index++;
    }
}

@end
