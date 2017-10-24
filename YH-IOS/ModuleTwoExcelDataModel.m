//
//  ModuleTwoExcelDataModel.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/10/20.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "ModuleTwoExcelDataModel.h"

@implementation ModuleTwoExcelDataModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"maindata":@"main_data",
             @"subdata":@"sub_data"
             };
}


+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"maindata":@"ModuleTwoExcelItemDataModel"
             };
}
@end
