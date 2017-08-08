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

- (instancetype)initWithDataList:(NSArray*)dataList;

- (void)show;
- (void)hide;

@end
