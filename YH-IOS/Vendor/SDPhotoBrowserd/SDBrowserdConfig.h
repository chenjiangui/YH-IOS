//
//  SDBrowserdConfig.h
//  YTXEducation
//
//  Created by 薛林 on 17/4/4.
//  Copyright © 2017年 YunTianXia. All rights reserved.
//

#ifndef SDBrowserdConfig_h
#define SDBrowserdConfig_h

typedef enum {
    SDWaitingViewModeLoopDiagram, // 环形
    SDWaitingViewModePieDiagram // 饼型
} SDWaitingViewMode;

// 图片保存成功提示文字
#define SDPhotoBrowserSaveImageSuccessText (@" 保存成功 ")

// 图片保存失败提示文字
#define SDPhotoBrowserSaveImageFailText (@" 保存失败 ")

// browser背景颜色
#define SDPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

// browser中图片间的margin
#define SDPhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define SDPhotoBrowserShowImageAnimationDuration 0.4f

// browser中显示图片动画时长
#define SDPhotoBrowserHideImageAnimationDuration 0.4f

// 图片下载进度指示进度显示样式（SDWaitingViewModeLoopDiagram 环形，SDWaitingViewModePieDiagram 饼型）
#define SDWaitingViewProgressMode SDWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define SDWaitingViewBackgroundColor [UIColor colorWithRed:34 green:34 blue:34 alpha:1]

// 图片下载进度指示器内部控件间的间距
#define SDWaitingViewItemMargin 10


#endif /* SDBrowserdConfig_h */