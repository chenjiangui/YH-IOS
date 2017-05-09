//
//  HomeIndexVC.m
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "HomeIndexVC.h"
#import "HomeIndexCollectionVC.h"
#import "HomeIndexDetailListVC.h"
#import "YH_ScrollTitleLineAndBarVC.h"
#import "UIBarButtonItem+Category.h"
#import "ChartHudView.h"
#import "DALabeledCircularProgressView.h"
#import "ViewUtils.h"

#define CollectionHeight (640.0*SCREEN_WIDTH/750.0)

@interface HomeIndexVC () <HomeIndexCollectionVCDelegate,HomeIndexDetailListVCDelegate>
{
    UIView* shadowView;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *topTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *topShowBtn;
@property (nonatomic, strong) HomeIndexCollectionVC* collectionVc;
@property (nonatomic, strong) HomeIndexDetailListVC* tableViewVc;
@property (nonatomic, strong) YH_ScrollTitleLineAndBarVC* chartVc;
@property (nonatomic, strong) HomeIndexModel* data;
@property (nonatomic, strong) NSArray* dataArray;
@property (nonatomic, assign) NSInteger curIndex; // 外层product选中下标
@property (nonatomic, assign) NSInteger curItemIndex; // items数组选中下标
@property (nonatomic, assign) CGFloat collectionOffset; // tableView和collection的偏移量
@property (nonatomic, strong) DACircularProgressView *progressView;
@property (strong, nonatomic) NSTimer *timer;


@end

@implementation HomeIndexVC

- (instancetype)init{
    self = [super init];
    if (self) {
        _curIndex = -1;
        _curItemIndex = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.view addSubview:self.collectionVc.view];
    [self.view addSubview:self.tableViewVc.view];
    [self.view addSubview: self.chartVc.view];
    [self.collectionVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(640.0*SCREEN_WIDTH/750.0);
    }];
    [self.tableViewVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.collectionVc.view.mas_bottom).offset(-_collectionOffset);
    }];
    [self.chartVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(0);
        make.height.mas_equalTo(260);
        make.width.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).offset(SCREEN_WIDTH);
    }];
  //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
    //    [self setWithHomeIndexModel:self.dataArray[arc4random()%4] needRefeshChartData:YES];
    //}];
    //self.topTimeLab.userInteractionEnabled = YES;
//    [self.topTimeLab addGestureRecognizer:tap];
    [self setWithHomeIndexModel:_data animation:YES];
    
    [self.topShowBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (self.chartVc.view.hidden) {
            [ChartHudView showInView:CurAppDelegate.window delegate:self];
        }else{
            [self hideChartAction];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 0, 70, 40)];
    UIImage *imageback = [UIImage imageNamed:@"Banner-Back"];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 15, 25)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addSubview:bakImage];
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 50, 25)];
    backLabel.text = @"返回";
    backLabel.textColor = [UIColor whiteColor];
    [backBtn addSubview:backLabel];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Subject-Refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(refreshView)];
    self.title =self.bannerTitle;
}

-(void)refreshView {
    //[self addShadowView];
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"加载中" mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    NSArray * models = [HomeIndexModel homeIndexModelWithJson:nil withUrl:self.dataLink];
    [self setWithHomeIndexArray:models];
    [self setWithHomeIndexModel:_data animation:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
    });
}

-(void)addShadowView {
    shadowView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    shadowView.opaque = NO;
    
    [self.view addSubview:shadowView];
    self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(shadowView.frame.size.width/2 -20, shadowView.frame.size.height/2-10,40.0f, 40.0f)];
    self.progressView.roundedCorners = YES;
    self.progressView.trackTintColor = [UIColor whiteColor];
    [shadowView addSubview:self.progressView];
    [UIView animateWithDuration:0.1 animations:^{
        [self startAnimation];
        shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }];
}


- (void)progressChange
{
    CGFloat progress = self.progressView.progress + 0.01f;
    [self.progressView setProgress:progress animated:YES];
        
    if (self.progressView.progress >= 1.0f && [self.timer isValid]) {
        [self.progressView setProgress:0.f animated:YES];
    }
}

- (void)startAnimation
{
     _timer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                  target:self
                                                selector:@selector(progressChange)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopAnimation
{
    [self.timer invalidate];
    self.timer = nil;
}


- (void)setWithHomeIndexArray:(NSArray *)array{
    if (array.count) {
        _dataArray = array;
        HomeIndexModel* model = [NSArray getObjectInArray:array keyPath:@"select" equalValue:@(YES)];
        if (!model) {
            model = array[_dataArray.count-1];
            model.select = YES;
        }
        [self setWithHomeIndexModel:model animation:YES];
    }

}

- (void)setWithHomeIndexModel:(HomeIndexModel *)model animation:(BOOL)animation{
    _data = model;
    self.title = model.head;
    self.topTimeLab.text = model.period;
    HomeIndexItemModel* oneItem = [NSArray getObjectInArray:model.products keyPath:@"select" equalValue:@(YES)];
    if (!oneItem) {
        if (model.products.count) {
            _curIndex = 0;
            [NSArray setValue:@(YES) keyPath:@"select" deafaultValue:@(NO) index:0 inArray:model.products];
            oneItem = model.products[0];
            [self homeIndexCollectionVCSelectIndex:[oneItem.items indexOfObject:oneItem.selctItem] model:oneItem vc:self.collectionVc];
        }
    }else{
        HomeIndexItemModel *selctItem = oneItem.selctItem;//[NSArray getObjectInArray:oneItem.items keyPath:@"select"
            [self homeIndexCollectionVCSelectIndex:[oneItem.items indexOfObject:selctItem] model:oneItem vc:self.collectionVc];//_curItemIndex = [item.items indexOfObject:selctItem];
    }
    if (_chartVc.view.hidden) { //如果报表视图消失了更新collection布局
        _collectionOffset = 0;
        if (oneItem.items.count<=4) {
            _collectionOffset = CollectionHeight*1.0/3.0;
        }
        if (oneItem.items.count<=2) {
            _collectionOffset = CollectionHeight*2.0/3.0;
        }
        if (oneItem.items.count<=0) {
            _collectionOffset = CollectionHeight;
        }
        if (self.tableViewVc.view.superview) {
            [self.tableViewVc.view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.collectionVc.view.mas_bottom).offset(-_collectionOffset);
            }];
        }
    }else{
//        if (refreshChart) { // 是否需要刷新chart数据
            [_chartVc setWithData:_dataArray curModel:_data animation:animation];
//        }
    }
    self.titleLab.text = oneItem.name;
    [self.tableViewVc setWithHomeIndexModel:model];
}

- (void)hideChartAction{
    [UIView animateWithDuration:0.5 animations:^{
        _topShowBtn.selected = NO;
        [self.chartVc.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(SCREEN_WIDTH);
        }];
        [self.tableViewVc.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(self.collectionVc.view.mas_bottom).offset(-_collectionOffset);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _chartVc.view.hidden = YES;
    }];
}

#pragma mark - 上方collection点击代理
/** 单击 */
- (void)homeIndexCollectionVCSelectIndex:(NSInteger)index model:(HomeIndexItemModel *)model vc:(HomeIndexCollectionVC *)vc{
    NSInteger index1 = [_data.products indexOfObject:model];
    for (HomeIndexModel* indexModel in _dataArray) {
        [NSArray setValue:@(YES) keyPath:@"select" deafaultValue:@(NO) index:index1 inArray:indexModel.products];
        for (int i=0; i<indexModel.products.count; i++) {
            [NSArray setValue:@(YES) keyPath:@"select" deafaultValue:@(NO) index:index inArray:indexModel.products[i].items];
        }
    }
    [self.collectionVc setWithHomeIndexModel:model];
    [self.tableViewVc setWithHomeIndexModel:_data];
}

/** 双击 */
- (void)doubClikWithHomeIndexCollectionVCSelectIndex:(NSInteger)index model:(HomeIndexItemModel *)model vc:(HomeIndexCollectionVC *)vc{
    /** 先执行一次单击事件操作更换选择数据 */
    [self homeIndexCollectionVCSelectIndex:index model:model vc:nil];
    [_chartVc setWithData:_dataArray curModel:_data animation:YES];
    [UIView animateWithDuration:0.5 animations:^{
        _chartVc.view.hidden = NO;
        _topShowBtn.selected = YES;
        [self.chartVc.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(0);
        }];
        [self.tableViewVc.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(self.chartVc.view.mas_bottom);
        }];
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - 下方tableView点击代理
- (void)HomeIndexDetailListVCSelectIndex:(NSInteger)index model:(HomeIndexModel *)model vc:(HomeIndexDetailListVC *)vc{
    for (HomeIndexModel* indexModel in _dataArray) {
        [NSArray setValue:@(YES) keyPath:@"select" deafaultValue:@(NO) index:index inArray:indexModel.products];
    }
//    [self.tableViewVc setWithHomeIndexModel:_data];
//    [self homeIndexCollectionVCSelectIndex:0 model:_data.products[index] vc:self.collectionVc];
    [self setWithHomeIndexModel:_data animation:YES];
}
/** 排序 */
- (void)HomeIndexDetailListVCSortDown:(BOOL)down model:(HomeIndexModel *)model vc:(HomeIndexDetailListVC *)vc{
//    HomeIndexModel* data = [HomeIndexModel mj_objectWithKeyValues:_data];
//    data.products = [NSArray sortArray:_data.products key:@"selctItem.main_data.data" down:down];
    
    [self.tableViewVc setWithHomeIndexModel:_data];
}

- (HomeIndexCollectionVC *)collectionVc{
    if (!_collectionVc) {
        _collectionVc = [[HomeIndexCollectionVC alloc] init];
        _collectionVc.view.clipsToBounds = YES;
        _collectionVc.delegate = self;
        [_collectionVc.view setBorderColor:[AppColor app_9color] width:.5];
    }
    return _collectionVc;
}

- (HomeIndexDetailListVC *)tableViewVc{
    if (!_tableViewVc) {
        _tableViewVc = [[HomeIndexDetailListVC alloc] init];
        _tableViewVc.delegate = self;
    }
    return _tableViewVc;
}

- (YH_ScrollTitleLineAndBarVC *)chartVc{
    if (!_chartVc) {
        _chartVc = [[YH_ScrollTitleLineAndBarVC alloc] init];
        MJWeakSelf;
        _chartVc.selectBack = ^(NSNumber* index){
            [weakSelf setWithHomeIndexModel:weakSelf.dataArray[index.integerValue] animation:NO];
        };
        _chartVc.view.hidden = YES;
    }
    return _chartVc;
}

@end
