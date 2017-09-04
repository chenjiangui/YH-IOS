//
//  YHHttpRequestAPI.m
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHHttpRequestAPI.h"
#import "User.h"
#import "NoticeWarningModel.h"
#import "ArticlesModel.h"
#import "YHKPIModel.h"
#import "ToolModel.h"
#import "ScreenModel.h"
#import "YHAPI.h"
#import "FileUtils.h"

#define CurAfnManager [BaseRequest afnManager]

@implementation YHHttpRequestAPI

+ (User*)user{
    return [[User alloc] init];
}

+(NSString *)user_num{
    return SafeText(self.user.userNum);
}

+(NSString *)user_device_id{
    return SafeText(self.user.deviceID);
}

+(NSString *)app_version{
    return  [NSString stringWithFormat:@"i%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
}

+(NSString *)coordinate{
    NSString *userlocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERLOCATION"];
    return SafeText(userlocation);
}

+ (void)yh_getNoticeWarningListWithTypes:(NSArray<NSString *> *)types page:(NSInteger)page finish:(YHHttpRequestBlock)finish{
    NSString *typeStr = [[NSString alloc] init];
    for (NSString* str in types) {
        typeStr = [typeStr stringByAppendingString:str];
        if (types.count && [types lastObject] != str) {
            typeStr = [typeStr stringByAppendingString:@","];
        }
    }
    NSDictionary* dic = @{
                          @"page":@(page),
                          @"type":typeStr,
                          @"limit":defaultLimit,
                          @"api_token":ApiToken(YHAPI_USER_WARN_LIST),
                          @"user_num":SafeText(self.user.userNum),
                          @"_user_num":[self user_num],
                          @"_user_device_id":[self user_device_id],
                          @"_app_version":[self app_version],
                          @"_coordinate":[self coordinate],
                          };
    
    NSString* url = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_USER_WARN_LIST];
    [BaseRequest getRequestWithUrl:url Params:dic needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        NoticeWarningModel* model = [NoticeWarningModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+ (void)yh_getNoticeWarningDetailWithNotice_id:(NSString *)notice_id finish:(YHHttpRequestBlock)finish{
    NSString* url = [NSString stringWithFormat:@"%@/api/v1/user/%@/notice/%@",kBaseUrl,[self user].userID,notice_id];
    NSDictionary *dict = @{
                           @"_user_num":[self user_num],
                           @"_user_device_id":[self user_device_id],
                           @"_app_version":[self app_version],
                           @"_coordinate":[self coordinate],
                           };
    [BaseRequest getRequestWithUrl:url Params:dict needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        NoticeWarningDetailModel* model = [NoticeWarningDetailModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+ (void)yh_getArticleListWithKeyword:(NSString *)keyword page:(NSInteger)page finish:(YHHttpRequestBlock)finish{
    NSString* url = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_ARTICLE_LIST];
    NSDictionary* dic = @{
                          @"keyword":SafeText(keyword),
                          @"api_token":ApiToken(YHAPI_ARTICLE_LIST),
                          @"page":@(page),
                          @"limit":defaultLimit,
                          @"user_num":SafeText(self.user.userNum),
                          @"_user_num":[self user_num],
                          @"_user_device_id":[self user_device_id],
                          @"_app_version":[self app_version],
                          @"_coordinate":[self coordinate],
                          };
    [BaseRequest getRequestWithUrl:url Params:dic needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        ArticlesModel* model = [ArticlesModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+ (void)yh_collectArticleWithArticleId:(NSString *)identifier isFav:(BOOL)isFav finish:(YHHttpRequestBlock)finish{
    NSString* url = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_USER_COLLECTION_STATE];
    NSDictionary* dic = @{
                          @"favourite_status":isFav ? @"1":@"2",
                          @"api_token":ApiToken(YHAPI_USER_COLLECTION_STATE),
                          @"user_num":SafeText(self.user.userNum) ,
                          @"article_id":SafeText(identifier),
                          @"_user_num":[self user_num],
                          @"_user_device_id":[self user_device_id],
                          @"_app_version":[self app_version],
                          @"_coordinate":[self coordinate]
                          };
    [BaseRequest postRequestWithUrl:url Params:dic needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        ArticlesModel* model = [ArticlesModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+ (void)yh_getHomeDashboardFinish:(YHHttpRequestBlock)finish{
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_BUSINESS_GENRERAL];
    NSDictionary* dic = @{
                          @"api_token":ApiToken(YHAPI_BUSINESS_GENRERAL),
                          @"group_id":SafeText(self.user.groupID),
                          @"role_id":SafeText(self.user.roleID),
                          @"_user_num":[self user_num],
                          @"_user_device_id":[self user_device_id],
                          @"_app_version":[self app_version],
                          @"_coordinate":[self coordinate]
                          };
    [BaseRequest getRequestWithUrl:url Params:dic needHandle:YES requestBack:^(BOOL requestSuccess, NSData* response, NSString *responseJson) {
        NSDictionary* dic = [response mj_JSONObject];
        NSArray<YHKPIModel *> *demolArray = [MTLJSONAdapter modelsOfClass:YHKPIModel.class fromJSONArray:dic[@"data"] error:nil];
        finish(requestSuccess,demolArray,responseJson);
    }];
}

+ (void)yh_getToolListFinish:(YHHttpRequestBlock)finish{
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_TOOLBOX];
    NSDictionary* dic = @{
                          @"api_token":ApiToken(YHAPI_TOOLBOX),
                          @"group_id":SafeText(self.user.groupID),
                          @"role_id":SafeText(self.user.roleID),
                          @"_user_num":[self user_num],
                          @"_user_device_id":[self user_device_id],
                          @"_app_version":[self app_version],
                          @"_coordinate":[self coordinate]
                          };
    [BaseRequest getRequestWithUrl:url Params:dic needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        ToolModel* model = [ToolModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+ (void)yh_getHomeNoticeListFinish:(YHHttpRequestBlock)finish{
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_USER_NOTICE_LIST];
    NSDictionary* dic = @{
                          @"api_token":ApiToken(YHAPI_USER_NOTICE_LIST),

                          @"group_id":SafeText(self.user.groupID),

                          @"role_id":SafeText(self.user.roleID),
                          @"_user_num":[self user_num],
                          @"_user_device_id":[self user_device_id],
                          @"_app_version":[self app_version],
                          @"_coordinate":[self coordinate]
                          };
    [BaseRequest getRequestWithUrl:url Params:dic needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        ToolModel* model = [ToolModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+ (void)yh_getFavArticleListPage:(NSInteger)page Finish:(YHHttpRequestBlock)finish{
    NSString* url = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_USER_COLLECTION_LIST];
    NSDictionary* dic = @{
                          @"api_token":ApiToken(YHAPI_USER_COLLECTION_LIST),
                          @"user_num":SafeText(self.user.userNum),
                          @"page":@(page),
                          @"limit":defaultLimit,
                          @"_user_num":[self user_num],
                          @"_user_device_id":[self user_device_id],
                          @"_app_version":[self app_version],
                          @"_coordinate":[self coordinate]
                          };
    [BaseRequest getRequestWithUrl:url Params:dic needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        ArticlesModel* model = [ArticlesModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+ (void)yh_getScreenMainAndAddressListDataFinish:(YHHttpRequestBlock)finish{
    NSString* url = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_REPORT_FILTER];
    NSDictionary *dic = @{
                          kAPI_TOEKN:ApiToken(YHAPI_REPORT_FILTER),
                          @"_user_num":[self user_num],
                          @"_user_device_id":[self user_device_id],
                          @"_app_version":[self app_version],
                          @"_coordinate":[self coordinate]
                          };
    [BaseRequest getRequestWithUrl:url Params:dic needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        ScreenModel* model = [ScreenModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+(void)yh_postUserMessageWithDict:(NSDictionary *)dict Finish:(YHHttpRequestBlock)finish{
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_UPLOAD_DEVICEMESSAGE];
    
    [BaseRequest postRequestWithUrl:url Params:dict needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        finish(requestSuccess,response,responseJson);
      }];

}

+(void)yh_getReportFilter:(NSString *)param Finish:(YHHttpRequestBlock)finish{
    NSString* url = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_REPORT_FILTER];
    NSDictionary *dic = @{
                          kAPI_TOEKN:ApiToken(YHAPI_REPORT_FILTER),
                          @"params":param,
                          @"_user_num":[self user_num],
                          @"_user_device_id":[self user_device_id],
                          @"_app_version":[self app_version],
                          @"_coordinate":[self coordinate]
                          };
    
    [BaseRequest getRequestWithUrl:url Params:dic needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        ScreenModel* model = [ScreenModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+(void)yh_postCommentWithDict:(NSDictionary *)dict Finish:(YHHttpRequestBlock)finish{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_COMMENT_PUBLISH];
    
    [BaseRequest postRequestWithUrl:url Params:dict needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        finish(requestSuccess,response,responseJson);
    }];
}

+(void)yh_postDict:(NSDictionary *)dict to:(NSString *)url Finish:(YHHttpRequestBlock)finish{
    NSString *apiURL = [NSString stringWithFormat:@"%@%@",kBaseUrl,url];
    [BaseRequest postRequestWithUrl:apiURL Params:dict needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        finish(requestSuccess,response,responseJson);
    }];
}


+(void)yh_getWithUrl:(NSString *)url Finish:(YHHttpRequestBlock)finish{
    [BaseRequest getRequestWithUrl:url Params:nil needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        finish(requestSuccess,response,responseJson);
    }];
}

+(void)yh_getDataFrom:(NSString *)url with:(NSDictionary *)dict Finish:(YHHttpRequestBlock)finish{
    NSString *apiurl = [NSString stringWithFormat:@"%@%@",kBaseUrl,url];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    mutableDict[@"_user_num"] = [self user_num];
    mutableDict[@"_user_device_id"] = [self user_device_id];
    mutableDict[@"_app_version"] = [self app_version];
    mutableDict[@"_coordinate"] = [self coordinate];
    [BaseRequest getRequestWithUrl:apiurl Params:mutableDict needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        finish(requestSuccess,response,responseJson);
    }];
}



+(void)yh_getReportJsonData:(NSString *)url withDict:(NSDictionary *)dict Finish:(YHHttpRequestBlock)finish {
    [CurAfnManager GET:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *jsonStr = nil;
        if (responseObject) {
            jsonStr = ((NSDictionary*)responseObject).mj_JSONString;
        }
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        DLog(@"\n请求结果******************************************\n%@",jsonStr);
        finish(YES, allHeaders, jsonStr);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DLog(@"\n请求失败************************************************\n%@",errorStr);
        finish(NO, nil, nil);
    }];

}

@end
