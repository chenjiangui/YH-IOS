//
//  ModuleTwoDivideComponentModel.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/10/20.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ComponentType) {
    banner,
    info,
    chart,
    tables
};

@interface ModuleTwoDivideComponentModel : NSObject

@property (nonatomic,assign)ComponentType type;
@property (nonatomic,strong)id config;


@end
