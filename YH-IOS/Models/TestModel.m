//
//  TestModel.m
//  YH-IOS
//
//  Created by cjg on 2017/8/4.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"sub_data":@"TestModel",
             @"main_data":@"NSString"
             };
}


- (NSMutableArray *)main_data{
    if (!_main_data) {
        _main_data = [NSMutableArray array];
    }
    return _main_data;
}

- (NSMutableArray *)sub_data{
    if (!_sub_data) {
        _sub_data = [NSMutableArray array];
    }
    return _sub_data;
}
@end
