//
//  ToolViewController.m
//  YH-IOS
//
//  Created by cjg on 2017/7/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "ToolViewController.h"
#import "OneImageAndLabCell.h"
#import "YHHttpRequestAPI.h"
#import "RefreshTool.h"
#import "ToolModel.h"

@interface ToolViewController () <UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UICollectionView* collection;

@property (nonatomic, strong) RefreshTool* reTool;

@property (nonatomic, strong) NSArray* dataList;

@end

@implementation ToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工具箱";
    [self setupUI];
    [self getData:true];
}

- (void)getData:(BOOL)loading{
    if (loading) {
        [HudToolView showLoadingInView:self.view];
    }
    [YHHttpRequestAPI yh_getToolListFinish:^(BOOL success, ToolModel* model, NSString *jsonObjc) {
        [HudToolView hideLoadingInView:self.view];
        [self.reTool endDownPullWithReload:false];
        if ([BaseModel handleResult:model]) {
            self.dataList = model.data;
            [self.collection reloadData];
        }
    }];
}

#pragma mark - 点击事件
- (void)toolClickAction:(ToolModel*)model{
    
}

- (void)refreshToolBeginDownRefreshWithScrollView:(UIScrollView *)scrollView tool:(RefreshTool *)tool{
    [self getData:false];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OneImageAndLabCell* cell = [OneImageAndLabCell cellWithCollctionView:collectionView needXib:YES IndexPath:indexPath];
    ToolModel* model = _dataList[indexPath.row];
    [cell.imageV sd_setImageWithURL:model.icon_link.mj_url placeholderImage:DEFAULT_IMAGE];
    cell.contentLab.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ToolModel* model = _dataList[indexPath.row];
    [self toolClickAction:model];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}


#pragma mark - lazy and ui
- (void)setupUI{
    [self.view sd_addSubviews:@[self.collection]];
}

- (RefreshTool *)reTool{
    if (!_reTool) {
        _reTool = [[RefreshTool alloc] initWithScrollView:self.collection delegate:self down:YES top:NO];
    }
    return _reTool;
}

- (UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-1)/3.0, SCREEN_WIDTH/3.0);
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0.5;
        layout.minimumInteritemSpacing = 0.5;
        _collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collection.backgroundColor = self.view.backgroundColor;
        _collection.delegate = self;
        _collection.dataSource = self;
    }
    return _collection;
}

@end
