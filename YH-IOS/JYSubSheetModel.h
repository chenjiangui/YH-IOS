//
//  JYSubSheetModel.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/8/30.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"
#import "JYMainDataModel.h"

@interface JYSubSheetModel : JYModuleTwoBaseModel

@property (nonatomic, strong, readonly) NSArray <NSString *> *headNames;
@property (nonatomic, strong) NSArray <JYMainDataModel *> *mainDataModelList;

- (void)sortMainDataListWithSection:(NSInteger)section ascending:(BOOL)ascending;


@end
