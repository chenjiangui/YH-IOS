//
//  ScanResultViewController.h
//  YH-IOS
//
//  Created by lijunjie on 16/06/07.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "BaseWebViewController.h"
#import "ToolModel.h"

@interface ScanResultViewController: BaseWebViewController
@property (strong, nonatomic) NSString *codeInfo;
@property (strong, nonatomic) NSString *codeType;
@property (strong, nonatomic) ToolModel *toolModel;
@end
