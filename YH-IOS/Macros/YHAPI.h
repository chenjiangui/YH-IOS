//
//  YHAPI.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/8/11.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef YH_IOS_YHAPI_h
#define UH_IOS_YHAPI_h

/** 用户验证 */
#define YHAPI_USER_AUTHENTICATION  @"/api/v1.1/user/authentication"

/** 上传设备 */
#define YHAPI_UPLOAD_DEVICEMESSAGE  @"/api/v1.1/app/device"

/** 门店列表 */
#define YHAPI_USER_STORELIST       @"/api/v1.1/user/stores"

/** 退出登录 */
#define YHAPI_USER_LOGOUT          @"/api/v1.1/user/logout"

/** 更新密码 */
#define YHAPI_UPDATE_PASSWORD      @"/api/v1.1/user/update_password"

/**  重置密码 */
#define YHAPI_RESET_PASSWORD       @"/api/v1.1/user/reset_password"

/** 报表内容 */
#define YHAPI_REPORT_DATADOWNLOAD  @"/api/v1.1/report/data"

/**  发表评论 */
#define YHAPI_COMMENT_PUBLISH      @"/api/v1.1/comment"

/** 上传锁屏*/
#define YHAPI_SCREEN_lOCK_PUBLISH   @"/api/v1.1/device/screen_lock"

/** 设备状态*/
#define YHAPI_DEVICE_STATE          @"/api/v1.1/device/state"

/** 设备列表*/
#define YHAPI_DEVICE_LAST           @"/api/v1.1/user/devices"

/**扫描商品码*/
#define YHAPI_SCAN_BAOCODE          @"/api/v1.1/scan/barcode"

/** 上传图像 */
#define YHAPI_UPLOAD_GRAVATAR       @"/api/v1.1/upload/gravatar"

/** 下载图像*/
#define YHAPI_DOWNLOAD_GRAVATAR     @"/api/v1.1/download/gravatar"

/** 静态资源校正*/
#define YHAPI_STATIC_ASSETS_CHECK   @"/api/v1.1/assets/md5"

/** 下载静态资源 */
#define YHAPI_DOWNLOAD_STATIC_ASSETS   @"/api/v1.1/download/assets"

/** 用户公告*/
#define YHAPI_USER_NOTICE_LIST          @"/api/v1.1/user/notifications"

/**生意概况*/
#define YHAPI_BUSINESS_GENRERAL         @"/api/v1.1/app/component/overview"

/**报表*/
#define YHAPI_REPORT                    @"/api/v1.1/app/component/reports"

/** 专题*/
#define YHAPI_TOPIC                     @"/api/v1.1/app/component/themes"

/** 工具箱*/
#define YHAPI_TOOLBOX                   @"/api/v1.1/app/component/toolbox"

/** 提交反馈*/
#define YHAPI_USER_UPLOAD_FEEDBACK            @"/api/v1.1/feedback"

/** 查看反馈*/
#define YHAPI_USER_CHEECK_FEEDBACK            @"/api/v1.1/feedback"

/** 个人统计 */
#define YHAPI_USER_COUNT_MESSAGE             @"/api/v1.1/my/statistics"

/** 公告列表*/
#define YHAPI_USER_WARN_LIST                  @"/api/v1.1/my/notices"

/** 查看公告*/
#define YHAPI_USER_WARN_DEATIL                 @"/api/v1.1/my/view/notic"

/** 问题列表*/
#define YHAPI_APP_BUG_LIST                    @"/api/v1.1/my/problems"

/** 问题列表明细*/
#define YHAPI_APP_BUG_DETAIL                   @"/api/v1.1/my/view/problem"

/** 文章列表 */
#define YHAPI_ARTICLE_LIST                      @"/api/v1.1/my/articles"

/** 问政明细 */
#define YHAPI_ARTICLE_DETAIL                    @"/api/v1.1/my/view/article"

/** 收藏列表*/
#define YHAPI_USER_COLLECTION_LIST            @"/api/v1.1/my/favourited/articles"

/** 收藏状态*/
#define YHAPI_USER_COLLECTION_STATE            @"/api/v1.1/my/article/favourite_status"

/** 筛选接口 */
#define YHAPI_REPORT_FILTER                  @"/api/v1.1/report/choice_menus"


#endif
