//
//  SDPhotoBrowserd.h
//  YTXEducation
//
//  Created by 薛林 on 17/4/4.
//  Copyright © 2017年 YunTianXia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDButton, SDPhotoBrowserd;

@protocol SDPhotoBrowserDelegate <NSObject>

@optional
- (UIImage *)photoBrowser:(SDPhotoBrowserd *)browser placeholderImageForIndex:(NSInteger)index;
- (UIImage *)photoBrowser:(SDPhotoBrowserd *)browser localImageForIndex:(NSInteger)index; //加载本地图片

//@required
- (NSURL *)photoBrowser:(SDPhotoBrowserd *)browser highQualityImageURLForIndex:(NSInteger)index;

@end

@interface SDPhotoBrowserd : UIView
@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, assign) BOOL isLocal;

@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;

- (void)show;
@end
