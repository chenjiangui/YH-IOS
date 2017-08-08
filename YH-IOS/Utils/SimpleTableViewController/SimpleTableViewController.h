//
//  SimpleTableViewController.h
//  YH-IOS
//
//  Created by cjg on 2017/8/3.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHBaseViewController.h"

@interface SimpleTableViewController : YHBaseViewController

@property (nonatomic, strong) CommonTwoBack cellBlock;

@property (nonatomic, strong) CommonTwoBack cellHeightBlock;

@property (nonatomic, strong) CommonTwoBack selectBlock;

@property (nonatomic, strong) CommonBack touchBlock;

@property (nonatomic, strong) NSMutableArray* dataList;

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UIView* topLine;

- (instancetype)initWithCellClass:(Class)cellClass
                              xib:(BOOL)xib;

- (void)updateDateList:(NSArray*)dataList;

- (void)reload;

@end
