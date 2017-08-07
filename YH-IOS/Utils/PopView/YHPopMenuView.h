//
//  YHPopMenuView.h
//  PikeWay
//
//  Created by 钱宝峰 on 17/08/07.
//  弹出菜单

#import <UIKit/UIKit.h>

typedef void (^dismissBlock)(BOOL isCanceled, NSInteger row);

@interface YHPopMenuView : UIView

@property (nonatomic,assign) CGFloat iconW;             //图标宽(默认宽高相等)
@property (nonatomic,assign) CGFloat fontSize;          //字体大小
@property (nonatomic,strong) UIColor *fontColor;        //字体颜色
@property (nonatomic,strong) UIColor *itemBgColor;      //item背景颜色
@property (nonatomic,assign) CGFloat itemNameLeftSpace; //itemName左边距
@property (nonatomic,assign) CGFloat iconLeftSpace;     //icon左边距离
@property (nonatomic,assign) CGFloat itemH;             //item高度
@property (nonatomic,copy) NSMutableArray *iconNameArray;      //图标名字Array
@property (nonatomic,copy) NSMutableArray *itemNameArray;      //item名字Array

@property (nonatomic,assign) BOOL canTouchTabbar;//可以点击Tabbar;(默认是遮挡Tabbar)

- (void)dismissHandler:(dismissBlock)handler;
- (void)show;
- (void)hideWithAnimation:(BOOL)animate;
@end
