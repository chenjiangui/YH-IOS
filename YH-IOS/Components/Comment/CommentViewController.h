//
//  CommentViewController.h
//  YH-IOS
//
//  Created by lijunjie on 15/12/11.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentViewController : BaseViewController
@property (strong, nonatomic) NSString *bannerName;
@property (assign, nonatomic) CommentObjectType commentObjectType;
@property (strong, nonatomic) NSNumber *objectID;
@end