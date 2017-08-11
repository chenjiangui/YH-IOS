//
//  MyFavArticleController.m
//  YH-IOS
//
//  Created by cjg on 2017/7/31.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MyFavArticleController.h"
#import "YHHttpRequestAPI.h"
#import "ArticlesModel.h"
#import "YHInstituteDetailViewController.h"
#import "User.h"

@interface MyFavArticleController ()

@end

@implementation MyFavArticleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文章收藏";
    self.searchBar.hidden = YES;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)getData:(BOOL)needLoding isDownPull:(BOOL)downPull{
    if (needLoding) {
        [HudToolView showLoadingInView:self.view];
    }
    NSInteger page = self.page + 1;
    if (downPull) {
        page = 1;
    }
    
    [YHHttpRequestAPI yh_getFavArticleListPage:page Finish:^(BOOL success, ArticlesModel* model, NSString *jsonObjc) {
        [HudToolView hideLoadingInView:self.view];
        [self.reTool endRefreshDownPullEnd:true topPullEnd:true reload:false noMore:false];
        if ([BaseModel handleResult:model]) {
            if (downPull) {
                self.page = 1;
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:model.data];
            }else{
                self.page++;
                [self.dataList addObjectsFromArray:model.data];
            }
            [self.reTool endRefreshDownPullEnd:YES topPullEnd:YES reload:YES noMore:[model isNoMore]];
        }
    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YHInstituteDetailViewController *instiDetail = [[YHInstituteDetailViewController alloc]init];
    ArticlesModel* model = self.dataList[indexPath.row];
    User* user = [[User alloc]init];
    instiDetail.userId = [NSString stringWithFormat:@"%@",user.userID];
    instiDetail.dataId = model.acticleId;
    [RootNavigationController pushViewController:instiDetail animated:YES hideBottom:YES];
}

- (void)collecArticle:(ArticlesModel *)articlesModel isFav:(BOOL)isFav{
    [HudToolView showLoadingInView:self.view];
    [YHHttpRequestAPI yh_collectArticleWithArticleId:articlesModel.acticleId isFav:isFav finish:^(BOOL success, ArticlesModel* model, NSString *jsonObjc) {
        [HudToolView hideLoadingInView:self.view];
        if ([BaseModel handleResult:model]) {
            [self getData:YES isDownPull:YES];
            if (isFav) {
                [HudToolView showTopWithText:@"收藏成功" correct:true];
            }
        }
    }];
}

@end
