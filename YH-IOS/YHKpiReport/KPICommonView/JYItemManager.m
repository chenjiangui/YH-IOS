//
//  JYItemManager.m
//  JYScrollNavBar
//
//  Created by haha on 15/7/16.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "JYItemManager.h"


#define scrollNavBarUpdate @"scrollNavBarUpdate"
#define rootScrollerUpdate @"rootScrollerUpdate"

@interface JYItemManager()
@property (nonatomic, strong) NSMutableArray *titles;
@end

@implementation JYItemManager

// 设置 titles 即，上面的一些页签
- (NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

// 单例
+ (id)shareitemManager{
    static JYItemManager *manger = nil;
    if (manger == nil) {
        manger = [[JYItemManager alloc]init];
    }
    return manger;
}

// 设置scrollTitle
- (void)setItemTitles:(NSMutableArray *)titles{
    _titles = titles;
    self.scrollNavBar.itemKeys = titles;
}

- (void)removeTitle:(NSString *)title{
    [self.titles removeObject:title];
}

- (void)printTitles{
    NSLog(@"********************************");
    for (NSString *title in self.titles) {
        NSLog(@"JYItemManager ---> %@",title);
    }
}
@end
