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
        if ([model.code isEqualToString:@"0"]) { //该单独处理请求成功
            if (downPull) {
                self.page = 1;
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:model.page.list];
            }else{
                self.page++;
                [self.dataList addObjectsFromArray:model.page.list];
            }
            [self.reTool endRefreshDownPullEnd:YES topPullEnd:YES reload:YES noMore:[model isNoMore]];
        }
    }];

}

- (void)collecArticle:(ArticlesModel *)articlesModel isFav:(BOOL)isFav{
    [HudToolView showLoadingInView:self.view];
    [YHHttpRequestAPI yh_collectArticleWithArticleId:articlesModel.acticleId isFav:isFav finish:^(BOOL success, ArticlesModel* model, NSString *jsonObjc) {
        [HudToolView hideLoadingInView:self.view];
        if ([model.code isEqualToString:@"201"]) {
            [self getData:YES isDownPull:YES];
        }
    }];
}

@end
