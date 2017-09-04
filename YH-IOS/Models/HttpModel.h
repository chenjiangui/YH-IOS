//
//  HttpModel.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/8/29.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface HttpModel : BaseModel

@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;

@end
