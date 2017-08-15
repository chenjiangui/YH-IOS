//
//  BaseNavigationController.m
//  Chart
//
//  Created by ice on 16/5/17.
//  Copyright © 2016年 ice. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) CAGradientLayer* gradientLayer;
@property (nonatomic, strong) UIView* barBg;
@end

@implementation BaseNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self.navigationBar.layer addSublayer:gradientLayer];
    self.interactivePopGestureRecognizer.delegate = self;
    self.navigationBar.opaque = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBar.translucent = true;
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageWithColor:UIColorHex(e6e6e6)]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self customBackItem:viewController];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated hideBottom:(BOOL)hide{
    [viewController setHidesBottomBarWhenPushed:hide];
    [self pushViewController:viewController animated:animated];
}

- (void)customBackItem:(UIViewController *)viewController {
    if ([self.viewControllers count] > 1) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
//        UIBarButtonItem *button = [UIBarButtonItem createBarButtonItemWithString:@"返回" font:14 color:[UIColor whiteColor] target:self action:@selector(backAction)];
        viewController.navigationItem.leftBarButtonItem = item;
    }
}

- (void)backAction {
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.childViewControllers.count > 1) {
        return YES;
    }else{
        return NO;
    };
}@end
