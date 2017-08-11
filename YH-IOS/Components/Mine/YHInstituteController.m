//
//  YHInstituteController.m
//  YH-IOS
//
//  Created by cjg on 2017/7/25.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHInstituteController.h"
#import "YHInstituteListCell.h"
#import "YHHttpRequestAPI.h"
#import "ArticlesModel.h"
#import "CommonSheetView.h"
#import "YHInstituteDetailViewController.h"
#import "User.h"

@interface YHInstituteController () 
{
    User *user;
}


@end

@implementation YHInstituteController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getData:YES isDownPull:YES];
    [self showBottomTip:YES title:@"不积小流，无以成江海" image:@"pic_3".imageFromSelf];

}


- (void)setupUI{
    [self.view sd_addSubviews:@[self.searchBar,self.tableView]];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(50);
    }];
}

- (void)getData:(BOOL)needLoding isDownPull:(BOOL)downPull{
    if (needLoding) {
        [HudToolView showLoadingInView:self.view];
    }
    NSInteger page = _page + 1;
    if (downPull) {
        page = 1;
    }
    [YHHttpRequestAPI yh_getArticleListWithKeyword:self.keyword page:page finish:^(BOOL success, ArticlesModel* model, NSString *jsonObjc) {
        [HudToolView hideLoadingInView:self.view];
        [self.reTool endRefreshDownPullEnd:true topPullEnd:true reload:false noMore:false];
        if ([model.code isEqualToString:@"0"]) { //该单独处理请求成功
            if (downPull) {
                _page = 1;
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:model.page.list];
            }else{
                _page++;
                [self.dataList addObjectsFromArray:model.page.list];
            }
            [_reTool endRefreshDownPullEnd:YES topPullEnd:YES reload:YES noMore:[model isNoMore]];
        }
    }];
}

- (void)collecArticle:(ArticlesModel*)articlesModel isFav:(BOOL)isFav{
    [HudToolView showLoadingInView:self.view];
    [YHHttpRequestAPI yh_collectArticleWithArticleId:articlesModel.identifier isFav:isFav finish:^(BOOL success, ArticlesModel* model, NSString *jsonObjc) {
        [HudToolView hideLoadingInView:self.view];
        if ([BaseModel handleResult:model]) {
            [self getData:YES isDownPull:YES];
            if (isFav) {
                [HudToolView showTopWithText:@"收藏成功" correct:true];
            }
        }
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.keyword = searchText;
    [self getData:YES isDownPull:YES];
}

- (void)refreshToolBeginDownRefreshWithScrollView:(UIScrollView *)scrollView tool:(RefreshTool *)tool{
    [self.view endEditing:YES];
    [self getData:NO isDownPull:YES];
}

- (void)refreshToolBeginUpRefreshWithScrollView:(UIScrollView *)scrollView tool:(RefreshTool *)tool{
     [self getData:NO isDownPull:NO];
}

#pragma mark - 列表代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHInstituteListCell *cell = [YHInstituteListCell cellWithTableView:tableView needXib:YES];
    ArticlesModel* model = _dataList[indexPath.row];
    [cell setWithArticle:model];
    MJWeakSelf;
    cell.favBack = ^(UIButton* item) {
        if (item.selected) {
            [weakSelf.favSheetView show];
            weakSelf.favSheetView.model = model;
        }else{
            [weakSelf collecArticle:model isFav:!item.selected];
        }
    };
    [cell setupAutoHeightWithBottomView:cell.iconImageV bottomMargin:15];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YHInstituteDetailViewController *instiDetail = [[YHInstituteDetailViewController alloc]init];
    ArticlesModel* model = _dataList[indexPath.row];
    user = [[User alloc]init];
    instiDetail.userId = [NSString stringWithFormat:@"%@",user.userID];
    instiDetail.dataId = model.identifier;
    [RootNavigationController pushViewController:instiDetail animated:YES hideBottom:YES];
}

#pragma mark - lazy init
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = [NewAppColor yhapp_clearcolor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (RefreshTool *)reTool{
    if (!_reTool) {
        _reTool = [[RefreshTool alloc] initWithScrollView:self.tableView delegate:self down:YES top:YES];
    }
    return _reTool;
}

- (CommonSheetView *)favSheetView{
    if (!_favSheetView) {
        _favSheetView = [[CommonSheetView alloc] initWithDataList:@[@"取消收藏"]];
        _favSheetView.lastString = @"继续收藏";
        _favSheetView.colors = @[[NewAppColor yhapp_17color]];
        MJWeakSelf;
        _favSheetView.selectBlock = ^(NSNumber* item) {
            [weakSelf.favSheetView hide];
            if (item.integerValue == 0) {
                ArticlesModel* model = weakSelf.favSheetView.model;
                [weakSelf collecArticle:model isFav:NO];
            }
        };
    }
    return _favSheetView;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _searchBar.backgroundColor = self.view.backgroundColor;
        _searchBar.showsCancelButton = NO;
        _searchBar.tintColor = [NewAppColor yhapp_1color];
        _searchBar.placeholder = @"搜索关键字";
        _searchBar.delegate = self;
        for (UIView *subView in _searchBar.subviews) {
            if ([subView isKindOfClass:[UIView  class]]) {
                [[subView.subviews objectAtIndex:0] removeFromSuperview];
                if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                    UITextField *textField = [subView.subviews objectAtIndex:0];
                    textField.backgroundColor = [UIColor whiteColor];
                    
                    //设置输入框边框的颜色
                    //                    textField.layer.borderColor = [UIColor blackColor].CGColor;
                    //                    textField.layer.borderWidth = 1;
                    
                    //设置输入字体颜色
                    //                    textField.textColor = [UIColor lightGrayColor];
                    
                    //设置默认文字颜色
                    UIColor *color = [UIColor grayColor];
                    [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"搜索关键字"
                                                                                        attributes:@{NSForegroundColorAttributeName:color}]];
                    //修改默认的放大镜图片
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
                    imageView.backgroundColor = [UIColor clearColor];
                    imageView.image = [UIImage imageNamed:@"icon_search-1"];
                    textField.leftView = imageView;
                    
                    
                }
            }
        }
    }
    return _searchBar;
}

@end
