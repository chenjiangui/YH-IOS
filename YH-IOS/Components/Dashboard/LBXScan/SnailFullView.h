//
//  SnailFullView.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineTextFiled.h"

typedef void (^pushBlock)(NSString *);

@interface SnailFullView : UIView

@property(copy,nonatomic)pushBlock clickTapBlock;//块

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, copy) void (^didClickFullView)(SnailFullView *fullView);
@property (nonatomic, copy) void (^didClickItems)(SnailFullView *fullView, NSInteger index);

- (void)endAnimationsCompletion:(void (^)(SnailFullView *fullView))completion; // 动画结束后执行block
-(void)setupUI;
-(void)OpenLightBtn;
- (void)keyboardWillShow:(NSNotification *)aNotification;
-(void)questBtn;

- (UILabel *)OpenLabel;
- (UIButton *)OpenLightbtn;
- (UIView *)InputView;
- (LineTextFiled *)InputNum;
@end
