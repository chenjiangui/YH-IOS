//
//  ModuleBaseArrayModel.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/10/20.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "ModuleBaseArrayModel.h"

@implementation ModuleBaseArrayModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"viewpages":@"data",
             };
}

+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"viewpages":@"ModuleTwoTypeArray"
             };
}
@end
