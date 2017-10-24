//
//  ModuleTwoExcelDataModel.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/10/20.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleTwoExcelItemDataModel.h"
#import "ModuleTwoMainModel.h"

@class ModuleTwoMainModel;

@interface ModuleTwoExcelDataModel : NSObject

@property (nonatomic,strong)NSArray<ModuleTwoExcelItemDataModel *> *maindata;
@property (nonatomic,strong)ModuleTwoMainModel* subdata;

@end
