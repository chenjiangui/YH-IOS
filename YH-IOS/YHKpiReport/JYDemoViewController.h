//
//  JYDemoViewController.h
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYDemoViewController : YHBaseViewController

@property (nonatomic, copy) NSString *urlLink;
@property (strong, nonatomic) NSString *bannerName;
@property (strong, nonatomic) NSString *link;
@property (assign, nonatomic) CommentObjectType commentObjectType;
@property (strong, nonatomic) NSString *objectID;

@end
