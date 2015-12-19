//
//  APIUtils.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "APIHelper.h"
#import "const.h"
#import "HttpUtils.h"
#import "FileUtils.h"
#import "HttpResponse.h"
#import "Version.h"
#import "OpenUDID.h"

@implementation APIHelper

+ (NSString *)reportDataUrlString:(NSNumber *)groupID reportID:(NSString *)reportID  {
    NSString *urlPath = [NSString stringWithFormat:API_DATA_PATH, groupID, reportID];
    return [NSString stringWithFormat:@"%@%@", BASE_URL, urlPath];
}

+ (void)reportData:(NSNumber *)groupID reportID:(NSString *)reportID {
    NSString *urlString = [self reportDataUrlString:groupID reportID:reportID];
    
    NSString *userspacePath = [FileUtils userspace];
    NSString *assetsPath = [userspacePath stringByAppendingPathComponent:HTML_DIRNAME];
    
    NSString *reportDataFileName = [NSString stringWithFormat:REPORT_DATA_FILENAME, groupID, reportID];
    NSString *javascriptPath = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
    javascriptPath = [javascriptPath stringByAppendingPathComponent:reportDataFileName];
    
    if(![FileUtils checkFileExist:javascriptPath isDir:NO]) {
        [HttpUtils clearHttpResponeHeader:urlString assetsPath:assetsPath];
    }
    
    HttpResponse *httpResponse = [HttpUtils checkResponseHeader:urlString assetsPath:assetsPath];
    
    if([httpResponse.statusCode isEqualToNumber:@(200)]) {
       // || reponse body is empty when 304
       //([httpResponse.statusCode isEqualToNumber:@(304)] && ![FileUtils checkFileExist:reportDataFilePath isDir:NO])) {
        
        if(httpResponse.string) {
            NSError *error = nil;
            [httpResponse.string writeToFile:javascriptPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            
            if(error) {
                NSLog(@"%@ - %@", error.description, javascriptPath);
            }
        }
    }
}

/**
 *  登录验证
 *
 *  @param username <#username description#>
 *  @param password <#password description#>
 *
 *  @return error msg when authentication failed
 */

+ (NSString *)userAuthentication:(NSString *)username password:(NSString *)password {
    NSString *urlPath = [NSString stringWithFormat:API_USER_PATH, @"IOS", username, password];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, urlPath];
    
    NSString *alertMsg = @"";
    
    
    NSMutableDictionary *deviceDict = [NSMutableDictionary dictionary];
    deviceDict[@"platform"]    = @"ios";
    deviceDict[@"os"]          = [Version machineHuman];
    deviceDict[@"uuid"]        = [OpenUDID value];
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:deviceDict];
    if(httpResponse.statusCode && [httpResponse.statusCode isEqualToNumber:@(200)]) {
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
        NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];

        userDict[@"user_id"]     = httpResponse.data[@"user_id"];
        userDict[@"user_name"]   = httpResponse.data[@"user_name"];
        userDict[@"group_id"]    = httpResponse.data[@"group_id"];
        userDict[@"group_name"]  = httpResponse.data[@"group_name"];
        userDict[@"role_id"]     = httpResponse.data[@"role_id"];
        userDict[@"role_name"]   = httpResponse.data[@"role_name"];
        userDict[@"kpi_ids"]     = httpResponse.data[@"kpi_ids"];
        userDict[@"app_ids"]     = httpResponse.data[@"app_ids"];
        userDict[@"analyse_ids"] = httpResponse.data[@"analyse_ids"];
        userDict[@"is_login"]    = @(YES);
        userDict[@"device_uuid"]   = httpResponse.data[@"device_uuid"];
        userDict[@"device_state"]  = httpResponse.data[@"device_state"];
        [userDict writeToFile:userConfigPath atomically:YES];
        
        NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
        [userDict writeToFile:settingsConfigPath atomically:YES];
    }
    else {
        alertMsg = [NSString stringWithFormat:@"%@", httpResponse.data[@"info"]];
    }
    return alertMsg;
}

/**
 *  创建评论
 *
 *  @param userID     <#userID description#>
 *  @param objectType <#objectType description#>
 *  @param objectID   <#objectID description#>
 *  @param params     <#params description#>
 *
 *  @return 是否创建成功
 */
+ (BOOL)writeComment:(NSString *)userID objectType:(NSNumber *)objectType objectID:(NSNumber *)objectID params:(NSMutableDictionary *)params {
    NSString *urlPath = [NSString stringWithFormat:API_COMMENT_PATH, userID, objectID, objectType];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, urlPath];
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:params];
    
    return [httpResponse.statusCode isEqual:@(201)];
}
@end