//
//  CommonSheetView.h
//  YH-IOS
//
//  Created by cjg on 2017/7/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnailPopupController.h"

@interface CommonSheetView : UIView

@property (nonatomic, strong) CommonBack selectBlock;

@property (nonatomic, strong) NSArray<UIColor*>* colors;

@property (nonatomic, strong) NSString* lastString;

@property (nonatomic, strong) UIColor* lastStringColor;

@property (nonatomic, strong) id model;

- (instancetype)initWithDataList:(NSArray<NSString*>*)dataList;

- (void)show;
- (void)hide;

@end
