//
//  YHNetworkTool.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHNetworkTool.h"
#import "HttpResponse.h"
#import "HttpUtils.h"

@implementation YHNetworkTool

+(instancetype)shareNetWorkTool{
    static YHNetworkTool *_shareInstance  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[YHNetworkTool alloc]init];
    });
    return _shareInstance;
}




@end
