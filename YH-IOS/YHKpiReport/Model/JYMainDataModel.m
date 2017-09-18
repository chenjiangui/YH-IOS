//
//  JYMainDataModel.m
//  各种报表
//
//  Created by niko on 17/5/15.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYMainDataModel.h"
#import "JYSubDataModlel.h"
#import "JYSheetModel.h"
#import "JYSubSheetModel.h"

@implementation JYMainDataSubData

-(NSString *)value{
    NSString *string = [NSString stringWithFormat:@"%@",self.params[@"value"]];
    return  string;
}

-(UIColor *)color {
    UIColor *color = [[self class] arrowToColor:[self.params[@"color"] integerValue]];
    return color;
}

@end

@interface JYMainDataModel()

@property (nonatomic, strong) NSArray <JYMainDataSubData *> *originMainDataList;

@end

@implementation JYMainDataModel

- (NSArray<JYMainDataSubData *> *)dataList {
    if (!_originMainDataList) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:[self.params[@"main_data"] count]];
        for (int i = 0; i < [self.params[@"main_data"] count]; i++) {
            NSDictionary *dict = self.params[@"main_data"][i];
            JYMainDataSubData *mainData = [JYMainDataSubData modelWithParams:dict];
            [temp addObject:mainData];
        }
        _originMainDataList = [temp copy];
    }
    return _originMainDataList;
}

- (JYSubSheetModel *)subDataList {

    JYSubSheetModel *subSheetModel = [JYSubSheetModel modelWithParams:self.params[@"sub_data"]];
    
    return subSheetModel;
}

@end

