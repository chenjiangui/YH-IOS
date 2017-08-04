//
//  YHInstituteController.h
//  YH-IOS
//
//  Created by cjg on 2017/7/25.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHBaseViewController.h"
#import "RefreshTool.h"

@class CommonSheetView;
@class ArticlesModel;

@interface YHInstituteController : YHBaseViewController<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UISearchBar* searchBar;

@property (nonatomic, strong) RefreshTool* reTool;

@property (nonatomic, strong) NSMutableArray* dataList;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSString* keyword;

@property (nonatomic, strong) CommonSheetView* favSheetView;

- (void)getData:(BOOL)needLoding isDownPull:(BOOL)downPull;

- (void)collecArticle:(ArticlesModel*)articlesModel isFav:(BOOL)isFav;

@end
