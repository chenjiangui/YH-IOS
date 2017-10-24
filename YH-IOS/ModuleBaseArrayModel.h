//
//  ModuleBaseArrayModel.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/10/20.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleTwoTypeArray.h"

@interface ModuleBaseArrayModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSArray<ModuleTwoTypeArray *> *viewpages;

@end
