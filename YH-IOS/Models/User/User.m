//
//  User.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/9.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "User.h"
#import "FileUtils.h"

@implementation User


+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"userName":@"user_name",
             @"userNum":@"user_num",
             @"password":@"user_pass",
             @"gravatar":@"gravatar",
             @"userID":@"user_id",
             @"roleID":@"role_id",
             @"roleName":@"role_name",
             @"groupID":@"group_id",
             @"groupName":@"group_name",
             @"deviceID":@"user_device_id",
             @"kpiIDs":@"kpi_ids",
             @"analyseIDs":@"analyse_ids",
             @"appIDs":@"app_ids"
             };
}


- (instancetype)init{
    self = [super init];
    if (self) {
        NSString *configPath = [User configPath];
        if([FileUtils checkFileExist:configPath isDir:NO]) {
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:configPath];
            self = [self mj_setKeyValues:dict];
        }
    }
    return self;
}

+ (NSString *)configPath {
    return [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
}

/**
 *  消息推送，当前设备的标签
 *
 *  @return 标签组
 */
+ (NSArray *)APNsTags {
    NSString *configPath = [User configPath];
    NSArray *tags = @[];
    if([FileUtils checkFileExist:configPath isDir:NO]) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:configPath];
        
        tags = @[dict[@"role_name"], dict[@"group_name"]];
    }
    
    return tags;
}
/**
 *  消息推送，当前设备的别名
 *
 *  @return 别名组
 */
+ (NSString *)APNsAlias {
    NSString *configPath = [User configPath];
    NSString *alias = @"";
    if([FileUtils checkFileExist:configPath isDir:NO]) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:configPath];
        
        alias = [NSString stringWithFormat:@"%@@%@", dict[@"user_name"], dict[@"user_num"]];
    }
    
    return alias;
}

- (NSString *)groupID{
    if (!_groupID) {
        _groupID = [[NSString alloc] init];
    }
    return _groupID;
}

-(NSString *)groupName{
    if (!_groupName) {
        _groupName =[[NSString alloc]init];
    }
    return _groupName;
}

-(NSString*)roleID{
    if (!_roleID) {
        _roleID =[[NSString alloc]init];
    }
    return _roleID;
}

-(NSString*)roleName{
    if (!_roleName) {
        _roleName = [[NSString alloc]init];
    }
    return _roleName;
}

@end
