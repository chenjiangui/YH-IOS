//
//  JYScrollNavBar.m
//  JYScrollNavBar
//
//  Created by haha on 15/5/2.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "JYScrollNavBar.h"
#import "UIView+Extension.h"
#import "UIColor+RGBA.h"
#import "JYItemManager.h"


#define ItemWidth                 120
#define FontMinSize               10
#define FontDetLeSize             5
#define FontDefSize               10
#define StaticItemIndex           3
#define scrollNavBarUpdate        @"scrollNavBarUpdate"
#define rootScrollUpdateAfterSort @"updateAfterSort"
#define moveToSelectedItem        @"moveToSelectedItem"
#define moveToTop                 @"moveToTop"

@interface JYScrollNavBar()<UIScrollViewDelegate>

@property (nonatomic, weak) UIButton *firstButton;
@property (nonatomic, weak) UIButton *secButton;

@property (nonatomic, strong) NSMutableDictionary *tmpPageViewDic;

@property (nonatomic, strong) NSMutableDictionary *itemsDic;
@property (nonatomic, strong) NSMutableArray      *tmpKeys;

@property (nonatomic, assign) BOOL                isLayoutitems;
@property (nonatomic, assign) BOOL                isHiddenAllItem;

@property (nonatomic, assign) CGPoint             beginPoint;
@property (nonatomic, assign) CGFloat             lastXpoint;
@property (nonatomic, assign) CGFloat             red1;
@property (nonatomic, assign) CGFloat             green1;
@property (nonatomic, assign) CGFloat             blue1;
@property (nonatomic, assign) CGFloat             alpha1;
@property (nonatomic, assign) CGFloat             red2;
@property (nonatomic, assign) CGFloat             green2;
@property (nonatomic, assign) CGFloat             blue2;
@property (nonatomic, assign) CGFloat             alpha2;
@property (nonatomic, assign) NSInteger           currctIndex;
@property (nonatomic, strong) NSMutableArray      *tempKeysWidth;

@end

@implementation JYScrollNavBar


#pragma mark - 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.userInteractionEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
}

- (void)setupItems{
    NSInteger itensCount = self.tmpKeys.count;
    for (NSInteger i = 0; i < itensCount; i++) {
        // 创建按钮
        UIButton *button = [self createItemWithTitle:self.tmpKeys[i]];
        
        [self.itemsDic setObject:button forKey:self.tmpKeys[i]];
        button.tag = i;
        
        // 设置默认第一个
        if (i == 0) {
            button.selected = YES;
            // 设置按钮的字体大小
            if (self.maxFontSize) {
                button.titleLabel.font = [UIFont systemFontOfSize:self.maxFontSize];
            }else{                
                button.titleLabel.font = [UIFont systemFontOfSize:FontDetLeSize + FontMinSize];
            }
            _currectItem = button;
        }
    }
}

// 创建顶部的 UIButton
- (UIButton *)createItemWithTitle:(NSString *)title{
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    NSInteger fontSize = self.minFontSize > 0 ? self.minFontSize : FontMinSize;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}


//布局上面的页签点击按钮
- (void)layoutButtons{
    self.contentSize = CGSizeMake(self.tmpKeys.count * ItemWidth, 0);
    NSInteger itemsCount = self.tmpKeys.count;
    
    //在这里修改那个表上面的标题名的宽度哦！！！
    CGFloat buttonW = 10;
    CGFloat buttonH = self.height;
    CGFloat buttonY = self.isItemHiddenAfterDelet ? self.height : 0;
    buttonH -= JYDefaultMargin;
    buttonY += JYDefaultMargin / 2.0;
    for (NSInteger i = 0; i < itemsCount; i++) {
        if (i != itemsCount) {
            NSString *key = self.tmpKeys[i];
            UIButton *button = [self.itemsDic objectForKey:key];
            button.tag = i;
            CGFloat buttonX = [self.tempKeysWidth[i] floatValue];
            button.frame = CGRectMake(buttonW, 7, buttonX, 30);
            self.itemW = [self.tempKeysWidth[i] floatValue];
            buttonW += buttonX;
            button.layer.cornerRadius = button.height/2.0;
        }
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    // 布局顶部页签
    [self layoutButtons];
}

#pragma mark - 业务逻辑

// 从字典中获取按钮
- (UIButton *)getItemWithIndex:(NSInteger)index{
    return [self.itemsDic objectForKey:self.tmpKeys[index]];
}


// 按钮点击之后移动位置
- (void)buttonClick:(UIButton *)button{
        _oldItem = _currectItem;
        _currectItem.selected = NO;
        [_currectItem setBackgroundColor:[UIColor clearColor]];
        
        button.selected = YES;
        [button setBackgroundColor:self.backgroundSelectedColor];
        
        _currectItem = button;
    
    // offx 的偏移量，点击了之后用来移动 scrollView 的offset 用来切换视图。
    CGFloat offX = button.tag * self.rootScrollView.width;
    NSLog(@"off ---> %f",offX);
    [UIView animateWithDuration:0.3 animations:^{
        // 设置偏移量
        self.rootScrollView.mj_offsetX = offX;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUpOrDown" object:self userInfo:@{@"origin": @"{0,110}"}];
    }];
}


#pragma mark - 懒加载

- (NSMutableArray *)tmpKeys{
    if (!_tmpKeys) {
        _tmpKeys = [NSMutableArray array];
    }
    return _tmpKeys;
}

- (NSMutableDictionary *)itemsDic{
    if (!_itemsDic) {
        _itemsDic = [NSMutableDictionary dictionary];
    }
    return _itemsDic;
}

- (NSMutableDictionary *)tmpPageViewDic{
    if (!_tmpPageViewDic) {
        _tmpPageViewDic = [NSMutableDictionary dictionary];
    }
    return _tmpPageViewDic;
}

-(NSMutableArray *)tempKeysWidth{
    if (!_tempKeysWidth) {
        _tempKeysWidth = [[NSMutableArray alloc]init];
        for (int i = 0; i < self.tmpKeys.count; i++) {
            CGFloat width =  [UILabel getWidthWithTitle:self.tmpKeys[i] font:[UIFont systemFontOfSize:15]] + 20;
            [_tempKeysWidth addObject:[NSNumber numberWithFloat:width]];
        }
    }
    return _tempKeysWidth;
}

#pragma mark - 属性配置
- (void)setItemKeys:(NSMutableArray *)itemKeys{
    _itemKeys = itemKeys;
    self.tmpKeys = itemKeys;
    if(self.itemsDic.count == 0){
        [self setupItems];
    }
}

- (void)setPageViews:(NSMutableArray *)pageViews{
    _pageViews = pageViews;
}

- (void)setupTmpPageViewDic{
    for (int i = 0; i < self.tmpKeys.count; i++) {
        [self.tmpPageViewDic setObject:self.pageViews[i] forKey:self.tmpKeys[i]];
    }
}

- (void)setOffsetX:(CGFloat)offsetX{
    _offsetX = self.contentOffset.x;
}

- (void)setRootScrollView:(JYRootScrollView *)rootScrollView{
    _rootScrollView = rootScrollView;
    _rootScrollView.delegate = self;
    _rootScrollView.scrollEnabled = NO;
    _rootScrollView.pageViews = self.pageViews;
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor{
    _titleNormalColor = titleNormalColor;
    [self.itemsDic enumerateKeysAndObjectsUsingBlock:^(id key, UIButton * button, BOOL *stop) {
        [button setTitleColor:titleNormalColor forState:UIControlStateNormal];
    }];
    
    RGBA rgba = RGBAFromUIColor(titleNormalColor);
    self.red1 = rgba.r;
    self.green1 = rgba.g;
    self.blue1 = rgba.b;
    self.alpha1 = rgba.a;
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor{
    _titleSelectedColor = titleSelectedColor;
    [self.itemsDic enumerateKeysAndObjectsUsingBlock:^(id key, UIButton * button, BOOL *stop) {
        [button setTitleColor:titleSelectedColor forState:UIControlStateSelected];
    }];
    RGBA rgba = RGBAFromUIColor(titleSelectedColor);
    self.red2 = rgba.r;
    self.green2 = rgba.g;
    self.blue2 = rgba.b;
    self.alpha2 = rgba.a;
}

- (void)setBackgroundSelectedColor:(UIColor *)backgroundSelectedColor {
    _backgroundSelectedColor = backgroundSelectedColor;
    [self.itemsDic enumerateKeysAndObjectsUsingBlock:^(id key, UIButton * button, BOOL *stop) {
        if ([button isEqual:_currectItem]) {
            [button setBackgroundColor:backgroundSelectedColor];
        }
    }];
    RGBA rgba = RGBAFromUIColor(backgroundSelectedColor);
    self.red2 = rgba.r;
    self.green2 = rgba.g;
    self.blue2 = rgba.b;
    self.alpha2 = rgba.a;
}

- (void)setMinFontSize:(NSInteger)minFontSize{
    if (minFontSize > FontMinSize && minFontSize <= FontDefSize + FontDetLeSize) {
        _minFontSize = minFontSize;
        [self setItemsFontWithFontSize:_minFontSize];
    }else{
        _minFontSize = FontMinSize;
    }
    [self setItemsFontWithFontSize:_minFontSize];
}


- (void)setMaxFontSize:(NSInteger)maxFontSize{
    if (maxFontSize > FontDefSize + FontDetLeSize) {
        _maxFontSize = maxFontSize;
    }else{
        _maxFontSize = FontMinSize + FontDetLeSize;
    }
}

- (void)setItemsFontWithFontSize:(NSInteger)size{
    [self.itemsDic enumerateKeysAndObjectsUsingBlock:^(id key, UIButton * obj, BOOL *stop) {
        obj.titleLabel.font = [UIFont systemFontOfSize:size];
    }];
}
@end
