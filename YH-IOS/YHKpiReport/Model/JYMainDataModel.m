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

@implementation JYMainDataModel

- (NSArray *)dataList {
    return self.params[@"main_data"];
}

- (JYSubSheetModel *)subDataList {

    JYSubSheetModel *subSheetModel = [JYSubSheetModel modelWithParams:self.params[@"sub_data"]];
    
    return subSheetModel;
}

@end
