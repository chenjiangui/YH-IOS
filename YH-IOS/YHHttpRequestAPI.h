//
//  YHHttpRequestAPI.h
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

typedef void(^YHHttpRequestBlock)( BOOL success, id model, NSString* jsonObjc);

#define defaultLimit @"15"

@interface YHHttpRequestAPI : NSObject
/**
 获取消息警告列表接口

 @param types @[1,2,3,4]自由组合
 @param page page description
 @param finish finish description
 */
+ (void)yh_getNoticeWarningListWithTypes:(NSArray<NSString*>*)types
                                    page:(NSInteger)page
                                   finish:(YHHttpRequestBlock)finish;

/**
 获取公告预警详情

 @param notice_id identifier
 @param finish finish description
 */
+ (void)yh_getNoticeWarningDetailWithNotice_id:(NSString*)notice_id
                                        finish:(YHHttpRequestBlock)finish;

/**
 获取数据学院文章列表

 @param keyword keyword description
 @param finish finish description
 */
+ (void)yh_getArticleListWithKeyword:(NSString*)keyword
                                page:(NSInteger)page
                              finish:(YHHttpRequestBlock)finish;

/**
 取消或收藏文章

 @param identifier 文章id
 @param isFav 是否收藏
 @param finish finish description
 */
+ (void)yh_collectArticleWithArticleId:(NSString*)identifier
                                 isFav:(BOOL)isFav
                              finish:(YHHttpRequestBlock)finish;

/**
 获取首页数组

 @param finish finish description
 */
+ (void)yh_getHomeDashboardFinish:(YHHttpRequestBlock)finish;

/**
 获取工具箱列表
 
 @param finish finish description
 */
+ (void)yh_getToolListFinish:(YHHttpRequestBlock)finish;

/**
 获取首页消息公告列表

 @param finish finish description
 */
+ (void)yh_getHomeNoticeListFinish:(YHHttpRequestBlock)finish;

/**
 获取收藏文章列表

 @param page page description
 @param finish finish description
 */
+ (void)yh_getFavArticleListPage:(NSInteger)page
                          Finish:(YHHttpRequestBlock)finish;

/**
 获取筛选界面主数据和地址数据

 @param finish finish description
 */
+ (void)yh_getScreenMainAndAddressListDataFinish:(YHHttpRequestBlock)finish;

/**
 获取筛选数据
 */

+(void)yh_getReportFilter:(NSString *)param Finish:(YHHttpRequestBlock)finish;

/**
 上传用户信息
 @param dict 上传的用户信息
 */
+(void)yh_postUserMessageWithDict:(NSDictionary *)dict Finish:(YHHttpRequestBlock)finish;


/**
 获取 HTML 数据
 @param dict 参数
 @param urls 需要上传的
 */
+(void)yh_getReportJsonData:(NSString *)url withDict:(NSDictionary *)dict Finish:(YHHttpRequestBlock)finish;

/**
 发表评论
 @param dict 参数;
 */

+(void)yh_postCommentWithDict:(NSDictionary *)dict Finish:(YHHttpRequestBlock)finish;


/**
 上传数据
 @param dict 参数
 @param url api 链接
 */

+(void)yh_postDict:(NSDictionary *)dict to:(NSString *)url Finish:(YHHttpRequestBlock)finish;


/**
 获取数据
 @param dict 参数
 @param url api 链接
 */

+(void)yh_getDataFrom:(NSString*)url with:(NSDictionary *)dict Finish:(YHHttpRequestBlock)finish;


/**
 获取数据
 */
+(void)yh_getWithUrl:(NSString *)url Finish:(YHHttpRequestBlock)finish;


/**
 获取经纬度数据
 */
+(void)yh_getLocationWithLocation:(NSString *)location Finish:(YHHttpRequestBlock)finish;


/**
 获取用户当前位置
 */
+(void)yh_getAddressWithLocation:(NSString *)location Finish:(YHHttpRequestBlock)finish;


@end
