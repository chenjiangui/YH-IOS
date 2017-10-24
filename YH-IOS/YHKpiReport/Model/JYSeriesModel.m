//
//  JYSeriesModel.m
//  各种报表
//
//  Created by niko on 17/5/13.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYSeriesModel.h"

@implementation JYSeriesModel

- (NSString *)mainSeriesTitle {
    return [((NSArray *)self.params)[0] objectForKey:@"name"];
}

- (NSString *)subSeriesTitle {
    return [((NSArray *)self.params)[1] objectForKey:@"name"];
}

-(NSString *)threeSeriesTitle {
    return [((NSArray *)self.params)[2] objectForKey:@"name"];
}

- (NSArray *)mainDataList {
    NSMutableArray *mainData = [NSMutableArray arrayWithArray:self.params[0][@"data"]];
    if ([mainData[0] isKindOfClass:[NSDictionary class]]) {
        [mainData removeAllObjects];
        for (NSDictionary *dic in self.params[0][@"data"]) {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSString *number = [numberFormatter stringFromNumber:@([dic[@"value"] floatValue])];
            [mainData addObject:number];
        }
        
    }
    else if ([mainData[0] isKindOfClass:[NSNumber class]]) {
        [mainData removeAllObjects];
        for (id obj in self.params[0][@"data"]) {
            NSNumber *temp = [obj isKindOfClass:[NSNumber class]] ? obj : @(0);
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSString *number = [numberFormatter stringFromNumber:temp];
            [mainData addObject:number];
        }
    }
    return [mainData copy];
}

- (NSArray *)subDataList {
    if (((NSArray *)self.params).count > 1) {
        NSMutableArray *mainDate = [NSMutableArray arrayWithCapacity:[self.params[1][@"data"] count]];
        
        for (NSString *value in self.params[1][@"data"]) {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSString *number = [numberFormatter stringFromNumber:@([value floatValue])];
            [mainDate addObject:number];
        }
        
        return [mainDate copy];
    }
    else{
        return [[NSArray alloc]init];
    }
}

- (NSArray *)threeList {
    if (((NSArray *)self.params).count > 2) {
        NSMutableArray *mainDate = [NSMutableArray arrayWithCapacity:[self.params[2][@"data"] count]];
        
        for (NSString *value in self.params[2][@"data"]) {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSString *number = [numberFormatter stringFromNumber:@([value floatValue])];
            [mainDate addObject:number];
        }
        
        return [mainDate copy];
    }
    else{
        return [[NSArray alloc]init];
    }
}


- (NSInteger)minLength {
       if (((NSArray *)self.params).count > 1) {
     _minLength = [self.params[1][@"data"] count] < [self.params[0][@"data"] count] ? [self.params[1][@"data"] count] : [self.params[0][@"data"] count];
       }
       else{
           _minLength =  [self.params[0][@"data"] count];
       }
    return _minLength;
}

- (NSInteger)maxLength {
    // 2个相等时长度都一样
    if (((NSArray *)self.params).count > 1) {
        _maxLength = [self.params[1][@"data"] count] > [self.params[0][@"data"] count] ? [self.params[1][@"data"] count] : [self.params[0][@"data"] count];
    }
    else{
        _maxLength = [self.params[0][@"data"] count];
    }
    return _maxLength;
}

- (NSComparisonResult)longerLineIndex {
     NSComparisonResult orderRst = NSOrderedSame;
     if (((NSArray *)self.params).count > 1) {
    if ([self.params[0][@"data"] count] > [self.params[1][@"data"] count]) {
        orderRst = NSOrderedAscending;
    }
    else if ([self.params[0][@"data"] count] < [self.params[1][@"data"] count]) {
        orderRst = NSOrderedDescending;
    }
     }
    return orderRst;
}

- (NSArray *)mainDataArrowList {
    NSMutableArray *mainArrow = [NSMutableArray arrayWithArray:self.params[0][@"data"]];
    if ([mainArrow[0] isKindOfClass:[NSDictionary class]]) {
        [mainArrow removeAllObjects];
        for (NSDictionary *dic in self.params[0][@"data"]) {
            [mainArrow addObject:dic[@"color"]];
        }
        if (mainArrow.count != self.maxLength) {
            NSInteger mainArrowCount = mainArrow.count;
            for (int i = 0; i < self.maxLength - mainArrowCount; i++) {
                [mainArrow addObject:@(TrendTypeArrowNoArrow)];
            }
        }
    }
    return [mainArrow copy];
}

- (NSArray<UIColor *> *)mainDataColorList {
    NSMutableArray *mainColor = [NSMutableArray arrayWithArray:self.params[0][@"data"]];
    if ([mainColor[0] isKindOfClass:[NSDictionary class]]) {
        [mainColor removeAllObjects];
        for (NSDictionary *dic in self.params[0][@"data"]) {
            [mainColor addObject:[[self class] arrowToColor:[dic[@"color"] integerValue]]];
        }
        if (mainColor.count != self.maxLength) {
            for (int i = 0; i < self.maxLength - mainColor.count; i++) {
                [mainColor addObject:JYColor_ArrowColor_Unkown];
            }
        }
    }
    return [mainColor copy];
}


- (NSString *)floatRatioAtIndex:(NSInteger)idx {
    if (idx >= self.minLength) {
        return @"";
    }
    CGFloat mainData = [[self.mainDataList[idx] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
    CGFloat subData = 0;
    if (self.subDataList.count > 0) {
       subData = [[self.subDataList[idx] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
    }
    
    CGFloat ratio = (mainData - subData) / subData;
    
    NSString *ratioStr = [NSString stringWithFormat:@"%@%.2lf", (ratio >= 0 ? @"+" : @""), ratio];
    return ratioStr;
}

- (TrendTypeArrow)arrowAtIndex:(NSInteger)idx {
    if (idx >= self.maxLength) {
        return TrendTypeArrowNoArrow;
    }
    return [self.mainDataArrowList[idx] integerValue];
}

// 在主值序列和对比值序列中查找最大值
- (CGFloat)maxValue {
    __block CGFloat max = 0;
    [self.mainDataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = 0.0;
        if ([obj isKindOfClass:[NSNumber class]]) {
            value = [obj floatValue];
        }
        else {
            value = [[obj stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
        }
        max = value > max ? value : max;
    }];
    
    [self.subDataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = 0.0;
        if ([obj isKindOfClass:[NSNumber class]]) {
            value = [obj floatValue];
        }
        else {
            value = [[obj stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
        }
        max = value > max ? value : max;
    }];
    return max;
}

// 在主值序列和对比值序列中查找最大值
- (CGFloat)minValue {
    __block CGFloat min = NSIntegerMax;
    [self.mainDataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = 0.0;
        if ([obj isKindOfClass:[NSNumber class]]) {
            value = [obj floatValue];
        }
        else {
            value = [[obj stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
        }
        min = value < min ? value : min;
    }];
    
    [self.subDataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = 0.0;
        if ([obj isKindOfClass:[NSNumber class]]) {
            value = [obj floatValue];
        }
        else {
            value = [[obj stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
        }
        min = value < min ? value : min;
    }];
    return min;
}

- (NSArray *)yAxisDataList {
    NSInteger max = [self maxValue];
    NSInteger min = [self minValue];
    while (max % 4 != 0) {
        max++;
    }
    
    NSInteger per = (max-min) / 6;
    NSMutableArray *yAxisArr = [NSMutableArray arrayWithCapacity:6];
    for (int i = 0; i < 6; i++) {
         [yAxisArr addObject:[NSString stringWithFormat:@"%zi", per * (4 - i)]];
//        [yAxisArr addObject:[NSString stringWithFormat:@"%zi", m]];
    }
//    [yAxisArr removeLastObject];
//    [yAxisArr addObject:[NSString stringWithFormat:@"%zi", [self minValue]]];
    
    return [yAxisArr copy];
}

@end
