//
//  JYMainDataModel.h
//  各种报表
//
//  Created by niko on 17/5/15.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"

@class JYSubDataModlel;
@class JYSubSheetModel;
@class JYMainDataSubData;

@interface JYMainDataModel : JYModuleTwoBaseModel

@property (nonatomic, strong, readonly) NSArray<JYMainDataSubData *> *dataList;
@property (nonatomic, strong) JYSubSheetModel *subDataList;


@end

@interface JYMainDataSubData : JYModuleTwoBaseModel

@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) UIColor *color;

@end
