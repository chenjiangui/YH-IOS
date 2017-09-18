//
//  JYPieModel.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/9/15.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JYPieSubModel : NSObject

@property (nonatomic,strong)NSString *value;
@property (nonatomic,assign)int color;
@property (nonatomic,strong)NSString *name;

@end

@interface JYPieCongifModel : NSObject

@property (nonatomic,strong) NSArray <JYPieSubModel *> *data;

@end

@interface JYPieModel : NSObject

@property (nonatomic,strong)JYPieCongifModel *config;
@property (nonatomic,copy) NSString *title;

@end


