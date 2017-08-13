//
//  APIUtils.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "APIHelper.h"
#import "Constant.h"
#import "HttpUtils.h"
#import "FileUtils.h"
#import "Version.h"
#import "OpenUDID.h"
#import <SSZipArchive/SSZipArchive.h>
@implementation APIHelper

+ (NSString *)reportDataUrlString:(NSString *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID  {
    return[NSString stringWithFormat:kReportDataAPIPath, kBaseUrl, groupID, templateID, reportID];
}

#pragma todo: pass assetsPath as parameter
+ (void)reportData:(NSString *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID {
    NSString *urlString = [self reportDataUrlString:groupID templateID:templateID reportID:reportID];
    
    NSString *assetsPath = [FileUtils dirPath:kHTMLDirName];
    NSString *javascriptPath = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
    
    NSDictionary *headerDict = @{
                                 kAPI_TOEKN:ApiToken(YHAPI_REPORT_DATADOWNLOAD),
                                 @"report_id":reportID,
                                 @"disposition":@"zip"
                                 };
    HttpResponse *httpResponse = [HttpUtils checkResponseHeader:urlString assetsPath:assetsPath withHeader:headerDict];
    if ([httpResponse.statusCode isEqualToNumber:@(200)]) {
        NSDictionary *httpHeader = [httpResponse.response allHeaderFields];
        NSString *disposition = httpHeader[@"Content-Disposition"];
        NSArray *array = [disposition componentsSeparatedByString:@"\""];
        NSString *cacheFilePath = array[1];
        NSString *reportFileName = [cacheFilePath stringByReplacingOccurrencesOfString:@".js.zip" withString:@".js"];
        NSString *cachePath = [FileUtils dirPath:kCachedDirName];
        NSString *fullFileCachePath = [cachePath stringByAppendingPathComponent:cacheFilePath];
        javascriptPath = [javascriptPath stringByAppendingPathComponent:reportFileName];
        [httpResponse.received writeToFile:fullFileCachePath atomically:YES];
        [SSZipArchive unzipFileAtPath:fullFileCachePath toDestination: cachePath];
        [FileUtils removeFile:fullFileCachePath];
        if ([FileUtils checkFileExist:javascriptPath isDir:NO]) {
            [FileUtils removeFile:javascriptPath];
        }
        [[NSFileManager defaultManager] copyItemAtPath:[cachePath stringByAppendingPathComponent:reportFileName] toPath:javascriptPath error:nil];
        [FileUtils removeFile:[cachePath stringByAppendingPathComponent:reportFileName]];
    }
}

//扫一扫获取数据
#pragma todo: pass assetsPath as parameter
+ (void)reportScodeData:(NSString *)storeID barcodeID:(NSString *)barcodeID {
    NSString *urlString = [NSString stringWithFormat:@"%@/mobile/v2/store/%@/barcode/%@/attachment",kBaseUrl,storeID,barcodeID];
    
    NSString *assetsPath = [FileUtils dirPath:kHTMLDirName];
    NSString *javascriptPath = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
    
    HttpResponse *httpResponse = [HttpUtils checkResponseHeader:urlString assetsPath:assetsPath];
    if ([httpResponse.statusCode isEqualToNumber:@(200)]) {
        NSDictionary *httpHeader = [httpResponse.response allHeaderFields];
        NSString *disposition = httpHeader[@"Content-Disposition"];
        NSArray *array = [disposition componentsSeparatedByString:@"\""];
        NSString *cacheFilePath = array[1];
        NSString *cachePath = [FileUtils dirPath:kCachedDirName];
        NSString *fullFileCachePath = [cachePath stringByAppendingPathComponent:cacheFilePath];
        javascriptPath = [javascriptPath stringByAppendingPathComponent:cacheFilePath];
        [httpResponse.received writeToFile:fullFileCachePath atomically:YES];
        if ([FileUtils checkFileExist:javascriptPath isDir:NO]) {
            [FileUtils removeFile:javascriptPath];
        }
        [[NSFileManager defaultManager] copyItemAtPath:fullFileCachePath toPath:javascriptPath error:nil];
        [FileUtils removeFile:[cachePath stringByAppendingPathComponent:fullFileCachePath]];
    }
}



+(NSString*)getJsonDataWithZip:(NSString *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID{
    
   NSString* jsonString = [NSString stringWithFormat:@"%@/api/v1/group/%@/template/%@/report/%@/jzip",kBaseUrl,groupID,templateID,reportID];
    
   // NSString *assetsPath = [FileUtils dirPath:kHTMLDirName];
    NSString *javascriptPath = [[FileUtils userspace] stringByAppendingPathComponent:@"HTML"];
    HttpResponse *httpResponse = [HttpUtils httpGet:jsonString];
    if ([httpResponse.statusCode isEqualToNumber:@(200)]) {
        NSDictionary *httpHeader = [httpResponse.response allHeaderFields];
        NSString *disposition = httpHeader[@"Content-Disposition"];
        NSArray *array = [disposition componentsSeparatedByString:@"\""];
        NSString *cacheFilePath = array[1];
        NSString *reportFileName = [cacheFilePath stringByReplacingOccurrencesOfString:@"json.zip" withString:@"json"];
        NSString *cachePath = [FileUtils dirPath:kCachedDirName];
        NSString *fullFileCachePath = [cachePath stringByAppendingPathComponent:cacheFilePath];
        javascriptPath = [javascriptPath stringByAppendingPathComponent:reportFileName];
        [httpResponse.received writeToFile:fullFileCachePath atomically:YES];
        [SSZipArchive unzipFileAtPath:fullFileCachePath toDestination: cachePath];
        [FileUtils removeFile:fullFileCachePath];
        if ([FileUtils checkFileExist:javascriptPath isDir:NO]) {
            [FileUtils removeFile:javascriptPath];
        }
        [[NSFileManager defaultManager] copyItemAtPath:[cachePath stringByAppendingPathComponent:reportFileName] toPath:javascriptPath error:nil];
        [FileUtils removeFile:[cachePath stringByAppendingPathComponent:reportFileName]];
    }
    else{
        NSString *htmlName = [HttpUtils urlTofilename:jsonString suffix:@".json"][0];
        htmlName = [htmlName stringByReplacingOccurrencesOfString:@"_jzip.json" withString:@".json"];
        htmlName = [htmlName stringByReplacingOccurrencesOfString:@"api_v1_group" withString:@"group"];
        javascriptPath = [[FileUtils dirPath:kHTMLDirName] stringByAppendingPathComponent:htmlName];
    }
    return javascriptPath;
}

+ (NSString *)userAuthentication:(NSString *)username password:(NSString *)password {
   return  [self userAuthentication:username password:password coordinate:nil];
}
/**
 *  登录验证
 *
 *  @param username <#username description#>
 *  @param password <#password description#>
 *
 *  @return error msg when authentication failed
 */
+ (NSString *)userAuthentication:(NSString *)usernum password:(NSString *)password coordinate:(NSString *)coordinate{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_USER_AUTHENTICATION];
    
    NSString *alertMsg = @"";
    
    NSDictionary *deviceDict = @{
                                 kAPI_TOEKN:ApiToken(YHAPI_USER_AUTHENTICATION),
                                 @"user_num":SafeText(usernum),
                                 @"password":SafeText(password),
                                 @"coordinate":coordinate
                                 };
    
   /* NSString *urlString = [NSString stringWithFormat:kUserAuthenticateAPIPath, kBaseUrl, @"IOS", usernum, password];
    NSString *alertMsg = @"";
    
    NSMutableDictionary *deviceDict = [NSMutableDictionary dictionary];
    deviceDict[@"device"] = @{
        @"name": [[UIDevice currentDevice] name],
        @"platform": @"ios",
        @"os": [Version machineHuman],
        @"os_version": [[UIDevice currentDevice] systemVersion],
        @"uuid": [OpenUDID value],
    };
    deviceDict[@"app_version"] = [NSString stringWithFormat:@"i%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
    deviceDict[@"coordinate"] = coordinate;*/
    
    HttpResponse *response = [HttpUtils httpPost:urlString Params:[deviceDict mutableCopy]];
    
    if(response.data[@"code"] && [response.data[@"code"] isEqualToNumber:@(200)]) {
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
        NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
        NSDictionary *dict = response.data[@"data"];
    
        userDict[kUserIDCUName]     = SafeText(dict[@"user_id"]);
        userDict[kUserNameCUName]   = SafeText(dict[@"user_name"]);
        userDict[kUserNumCUName]    = SafeText(dict[@"user_num"]);
        userDict[kGroupIDCUName]    = SafeText(dict[@"group_id"]);
        userDict[kGroupNameCUName]  = SafeText(dict[@"group_name"]);
        userDict[kRoleIDCUName]     = SafeText(dict[@"role_id"]);
        userDict[kRoleNameCUName]   = SafeText(dict[@"role_name"]);
        userDict[kGravatarCUName]   = SafeText(dict[@"gravatar"]);
        userDict[@"email"]          = SafeText(dict[@"email"]);
        userDict[@"mobile"]         = SafeText(dict[@"mobile"]);
        userDict[@"user_pass"]      = SafeText(dict[@"user_pass"]);
        userDict[@"is_login"]       = @(1);
        
        /**
         *  rewrite screen lock info into
         */
        [userDict writeToFile:userConfigPath atomically:YES];
        
        userDict[kIsUseGesturePasswordCUName] = @(NO);
        userDict[kGesturePasswordCUName]      = @"";
        NSString *settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kSettingConfigFileName];
        if([FileUtils checkFileExist:settingsConfigPath isDir:NO]) {
            NSMutableDictionary *settingsDict = [FileUtils readConfigFile: settingsConfigPath];
            
            userDict[kIsUseGesturePasswordCUName] = @(NO);
            if(settingsDict[kIsUseGesturePasswordCUName]) {
                userDict[kIsUseGesturePasswordCUName] = settingsDict[kIsUseGesturePasswordCUName];
            }
            
            userDict[kGesturePasswordCUName] = @"";
            if(settingsDict[kGesturePasswordCUName]) {
                userDict[kGesturePasswordCUName] = settingsDict[kGesturePasswordCUName];
            }
        }
        
        [userDict writeToFile:userConfigPath atomically:YES];
        [userDict writeToFile:settingsConfigPath atomically:YES];

        // 第三方消息推送，设备标识
        [APIHelper pushDeviceToken:userDict[kDeviceUUIDCUName]];

    }
    else if(response.data && response.data[@"message"]) {
        alertMsg = [NSString stringWithFormat:@"%@", response.data[@"message"]];
    }
    else if(response.errors.count) {
        alertMsg = [response.errors componentsJoinedByString:@"\n"];
    }
    else {
        alertMsg = [NSString stringWithFormat:@"未知错误: %@", response.statusCode];
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
    NSString *urlString = [NSString stringWithFormat:kCommentAPIPath, kBaseUrl, userID, objectID, objectType];
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:params];
    
    return [httpResponse.statusCode isEqual:@(201)];
}

+ (void)deleteUserDevice:(NSString *)platform withDeviceID:(NSString*)deviceid {
    NSString *deleteString = [NSString  stringWithFormat:@"%@/api/v1/%@/%@/logout",kBaseUrl,platform,deviceid];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:deleteString]];
    [request setHTTPMethod:@"POST"];
    NSError *error;
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

/**
 *  消息推送， 设备标识
 *
 *  @param deviceUUID  设备ID
 *
 *  @return 服务器是否更新成功
 */
+ (BOOL)pushDeviceToken:(NSString *)deviceUUID {
    NSString *pushConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kPushConfigFileName];
    NSMutableDictionary *pushDict = [FileUtils readConfigFile:pushConfigPath];
    
    if(pushDict[@"device_uuid"] && ![pushDict[@"device_uuid"] isEqualToString:deviceUUID]) {
        pushDict[@"push_valid"] = @(NO);
    }
    
    if([pushDict[@"push_valid"] boolValue] && pushDict[@"push_device_token"] && [pushDict[@"push_device_token"] length] == 64) {
        return YES;
    }
    if(!pushDict[@"push_device_token"] || [pushDict[@"push_device_token"] length] != 64) {
        return NO;
    }
    
    NSString *urlString = [NSString stringWithFormat:kPushDeviceTokenAPIPath, kBaseUrl, deviceUUID, pushDict[@"push_device_token"]];
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:[NSMutableDictionary dictionary]];

    pushDict[@"device_uuid"] = deviceUUID;
    pushDict[@"push_valid"] = @(httpResponse.data[@"valid"] && [httpResponse.data[@"valid"] boolValue]);
    [pushDict writeToFile:pushConfigPath atomically:YES];
    
    return [pushDict[@"push_valid"] boolValue];
}

/**
 *  用户锁屏数据
 *
 *  @param userDeviceID 设备ID
 *  @param passcode     锁屏信息
 *  @param state        是否锁屏
 */
+ (void)screenLock:(NSString *)userDeviceID passcode:(NSString *)passcode state:(BOOL)state {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_LOCK_SCREEN];
    NSString *settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kSettingConfigFileName];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"screen_lock_state"] = @(state);
    params[@"screen_lock_type"]  = @"4位数字";
    params[@"screen_lock"]       = passcode;
    params[kAPI_TOEKN] = ApiToken(YHAPI_LOCK_SCREEN);
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:params];
    NSLog(@"%@", httpResponse.statusCode);
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userdict = [FileUtils readConfigFile:userConfigPath];
    userdict[kIsUseGesturePasswordCUName] = @(1);
    [userdict writeToFile:userConfigPath atomically:YES];
    [userdict writeToFile:settingsConfigPath atomically:YES];
}

/**
 *  检测设备是否在服务器端被禁用
 *
 *
 *  @return 是否可用
 */
+ (DeviceState)deviceState {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    NSDictionary *dict = @{
                           kAPI_TOEKN:ApiToken(YHAPI_DEVICE_STATE),
                           kUserNumCUName:SafeText(userDict[kUserNumCUName]),
                           @"id":@"1"
                           };
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_DEVICE_STATE];
    HttpResponse *httpResponse = [HttpUtils httpGet:urlString header:dict timeoutInterval:10.0];
    
//    userDict[@"device_state"]  = httpResponse.data[@"device_state"];
//    [userDict writeToFile:userConfigPath atomically:YES];
//    
//    NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
//    [userDict writeToFile:settingsConfigPath atomically:YES];
    
    DeviceState deviceState = [httpResponse.statusCode integerValue];
    if(deviceState == StateOK) {
        deviceState = [httpResponse.data[@"device_state"] boolValue] ? StateOK : StateForbid;
    }
    
    return deviceState;
}

/**
 *  重置用户登陆密码
 *
 *  @param userID      用户ID
 *  @param newPassword 新密码
 *
 *  @return 服务器响应
 */
+ (HttpResponse *)resetPassword:(NSString *)userNum newPassword:(NSString *)newPassword {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_UPDATE_PASSWORD];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"password"] = newPassword;
    params[kAPI_TOEKN] = ApiToken(YHAPI_UPDATE_PASSWORD);
    params[kUserNumCUName] = userNum;
    
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:params];
    
    return httpResponse;
}

/**
 *  记录用户行为操作
 *
 *  @param params 用户行为操作
 */
+ (void)actionLog:(NSMutableDictionary *)param {
    // TODO: 避免服务器压力，过滤操作由服务器来处理
    NSString *action = param[kActionALCName];
    
    if(action == nil) { return; }

    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    NSString *userlocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERLOCATION"];
    param[kUserIDCUName]       = userDict[kUserIDCUName];
    param[kUserNameCUName]     = userDict[kUserNameCUName];
    if (userDict[kUserDeviceIDCUName]!=nil) {
         param[kUserDeviceIDCUName] = userDict[kUserDeviceIDCUName];
    }
    
    param[kUserNumCUName]      = SafeText(userDict[kUserNumCUName]);
    param[kUserLocationName] = userlocation;
    param[kAppVersionCUName]   = [NSString stringWithFormat:@"i%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kActionLogALCName] = param;
    
    NSMutableDictionary *userParams = [NSMutableDictionary dictionary];
    userParams[kUserNameALCName] = SafeText(userDict[kUserNameCUName]);
    userParams[kPasswordALCName] = SafeText(userDict[kPasswordCUName]);
    params[kUserALCName]         = userParams;
    NSString *urlString = [NSString stringWithFormat:kActionLogAPIPath, kBaseUrl];
    [HttpUtils httpPost:urlString Params:params];
}

/**
 *  二维码扫描
 *
 *  @param userNum    用户编号
 *  @param groupID    群组ID
 *  @param roleID     角色ID
 *  @param storeID    门店ID
 *  @param codeString 条形码信息
 *  @param codeType   条形码或二维码
 */
+ (BOOL)barCodeScan:(NSString *)userNum group:(NSString *)groupID  role:(NSString *)roleID store:(NSString *)storeID code:(NSString *)codeInfo type:(NSString *)codeType {
    NSString * urlstring = [NSString stringWithFormat:kBarCodeScanAPIPath, kBaseUrl, groupID, roleID, userNum, storeID, codeInfo, codeType];
    
    HttpResponse *response = [HttpUtils httpGet:urlstring];
    NSString *responseString = response.string;
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    BOOL isJsonRight;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err || (dic.count == 0)) {
        isJsonRight = NO;
    }
    else {
        [FileUtils barcodeScanResult:responseString];
        isJsonRight = YES;
    }
    return isJsonRight;
}

+ (HttpResponse *)findPassword:(NSString *)userNum withMobile:(NSString *)moblieNum {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kBaseUrl,YHAPI_RESET_PASSWORD];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_num"] = userNum;
    params[@"mobile"] = moblieNum;
    params[@"api_token"] = ApiToken(YHAPI_RESET_PASSWORD);
    HttpResponse *httpResponse = [HttpUtils httpPost:urlString Params:params];
    
    return httpResponse;
}

@end
