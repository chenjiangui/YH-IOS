//
//  JYCursor.h
//  JYScrollNavBar
//
//  Created by haha on 15/7/6.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYScrollNavBar.h"

@interface JYCursor : UIView

@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) NSArray        *titles;

@property (nonatomic, strong) UIColor        *titleNormalColor;
@property (nonatomic, strong) UIColor        *titleSelectedColor;
@property (nonatomic, strong) UIColor        *backgroudSelectedColor;
@property (nonatomic, strong) UIColor        *navLineColor;
@property (nonatomic, strong) JYScrollNavBar   *scrollNavBar;
@property (nonatomic, assign) NSInteger      minFontSize;
@property (nonatomic, assign) NSInteger      maxFontSize;
@property (nonatomic, assign) NSInteger      defFontSize;
@property (nonatomic, assign) CGFloat        rootScrollViewHeight;

- (id)initWithTitles:(NSArray *)titles AndPageViews:(NSArray *)pageViews;

@end
