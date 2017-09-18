//
//  JYSubSheetView.h
//  各种报表
//
//  Created by niko on 17/5/18.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYSheetModel.h"
#import "JYSubSheetModel.h"


@interface JYSubSheetView : UIView

@property (nonatomic, strong) JYSubSheetModel *sheetModel;

@property (nonatomic, strong)NSString *title;

- (void)showSubSheetView;

@end
