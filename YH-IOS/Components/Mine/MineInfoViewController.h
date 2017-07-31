//
//  MineInfoViewController.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBaseViewController.h"

#define RootNavigationController [YHBaseViewController getRootNavController]

@interface MineInfoViewController : UIViewController

@property (nonatomic, strong) RACCommand *requestCommane;

@end
