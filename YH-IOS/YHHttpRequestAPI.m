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

@implementation YHHttpRequestAPI

+ (User*)user{
    return [[User alloc] init];
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
                          @"user_num":SafeText(self.user.userNum)
                          };
    
    NSString* url = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_USER_WARN_LIST];
    [BaseRequest getRequestWithUrl:url Params:dic needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        NoticeWarningModel* model = [NoticeWarningModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+ (void)yh_getNoticeWarningDetailWithNotice_id:(NSString *)notice_id finish:(YHHttpRequestBlock)finish{
    NSString* url = [NSString stringWithFormat:@"%@/api/v1/user/%@/notice/%@",kBaseUrl,[self user].userID,notice_id];
    [BaseRequest getRequestWithUrl:url Params:nil needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
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
                          @"user_num":self.user.userID
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
                          @"user_num":self.user.userID,
                          @"article_id":SafeText(identifier)
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
                          @"group_id":self.user.groupID,
                          @"role_id":self.user.roleID
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
                          @"group_id":self.user.groupID,
                          @"role_id":self.user.roleID
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
                          @"group_id":self.user.groupID,
                          @"role_id":self.user.roleID
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
                          @"user_num":self.user.userNum,
                          @"page":@(page),
                          @"limit":defaultLimit,
                          };
    [BaseRequest getRequestWithUrl:url Params:dic needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        ArticlesModel* model = [ArticlesModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+ (void)yh_getScreenMainAndAddressListDataFinish:(YHHttpRequestBlock)finish{
    NSString* url = @"http://yonghui-test.idata.mobi/api/v1/report/menus";
    [BaseRequest getRequestWithUrl:url Params:nil needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        ScreenModel* model = [ScreenModel mj_objectWithKeyValues:response];
        finish(requestSuccess,model,responseJson);
    }];
}

+(void)yh_postUserMessageWithDict:(NSDictionary *)dict Finish:(YHHttpRequestBlock)finish{
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_UPLOAD_DEVICEMESSAGE];
    [BaseRequest postRequestWithUrl:url Params:dict needHandle:YES requestBack:^(BOOL requestSuccess, id response, NSString *responseJson) {
        
      }];
     }

@end
