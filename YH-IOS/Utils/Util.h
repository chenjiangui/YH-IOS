//
//  Util.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/8/12.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Util : NSObject


typedef void(^CapSuccessBlock)(UIImage *image,UIImage * thumbImage);
typedef void(^CapFailureBlock)(NSError *error);

+(instancetype)shareUtil;



/**
 截屏
 
 @param url 截屏的url
 @param successBlock 截屏成功的回调
 @param failureBlock 截屏失败的回调
 */
-(void)capturePicShareWitchUrl:(NSString*)url
                       success:(CapSuccessBlock) successBlock
                       failure:(CapFailureBlock) failureBlock;

@end
