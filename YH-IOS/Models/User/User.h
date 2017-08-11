//
//  User.h
//  YH-IOS
//
//  Created by lijunjie on 15/12/9.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "BaseModel.h"

@interface User : BaseModel
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userNum;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *gravatar;
@property (strong, nonatomic) NSString *groupID;
@property (strong, nonatomic) NSString *groupName;
@property (strong, nonatomic) NSString *roleID;
@property (strong, nonatomic) NSString *roleName;
@property (strong, nonatomic) NSArray *kpiIDs;
@property (strong, nonatomic) NSArray *analyseIDs;
@property (strong, nonatomic) NSArray *appIDs;
@property (strong, nonatomic) NSString *deviceID;

+ (NSString *)configPath;
/**
 *  消息推送，当前设备的标签
 *
 *  @return 标签组
 */
+ (NSArray *)APNsTags;
/**
 *  消息推送，当前设备的别名
 *
 *  @return 别名组
 */
+ (NSString *)APNsAlias;
@end
