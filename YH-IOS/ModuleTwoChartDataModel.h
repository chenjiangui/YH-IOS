//
//  ModuleTwoChartDataModel.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/10/20.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModuleTwoChartDataModel : NSObject

@property (nonatomic,strong)NSArray *legend;
@property (nonatomic,strong)NSArray *series;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSArray *xAxis;
@property (nonatomic,strong)NSArray *yAxis;

@end
