//
//  TestModel.h
//  YH-IOS
//
//  Created by cjg on 2017/8/4.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "BaseModel.h"

@interface TestModel : BaseModel

@property (nonatomic, strong) NSString* fatherId;
@property (nonatomic, strong) NSMutableArray* main_data;
@property (nonatomic, strong) NSMutableArray* sub_data;
@end
