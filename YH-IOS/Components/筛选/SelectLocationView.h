//
//  SelectLocationView.h
//  YH-IOS
//
//  Created by cjg on 2017/8/3.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectLocationView : UIView

@property (nonatomic, strong) CommonBack selectBlock;
/** 选中模型数组 */
@property (nonatomic, strong) NSMutableArray* selectItems;

- (instancetype)initWithDataList:(NSArray*)dataList;

- (void)reload:(NSArray*)dataList;

- (void)show;
- (void)hide;

@end
