//
//  ScreenHeaderView.h
//  YH-IOS
//
//  Created by cjg on 2017/8/3.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenModel.h"

@interface ScreenHeaderView : UIView

@property (nonatomic, strong) CommonTwoBack locationBlock;

@property (nonatomic, strong) CommonBack screenBlock;

@property (nonatomic, strong) NSArray* dataList;


- (void)setAreaModel:(ScreenModel*)areaModel;

- (void)setData:(NSArray*)data;

- (void)reload;

@end
