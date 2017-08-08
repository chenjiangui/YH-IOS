//
//  ZJNewFeatureCell.m
//  GuidePageDemo
//
//  Created by zhengju on 16/11/7.
//  Copyright © 2016年 俱哥. All rights reserved.
//

#import "ZJNewFeatureCell.h"
#import "LoginViewController.h"

@interface ZJNewFeatureCell ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *startButton;
@property (copy) NSMutableString *aString;
@end
@implementation ZJNewFeatureCell

- (UIButton *)startButton
{
    if (_startButton == nil) {
        UIButton *startBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:startBtn];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"btn_enter"] forState:UIControlStateNormal];
        [startBtn addTarget:self action:@selector(jumpToLogin)forControlEvents:UIControlEventTouchUpInside];
        [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_bottom).mas_offset(-71);
            make.centerX.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(150, 52));
        }];
         _startButton = startBtn;
    }
    return _startButton;
}
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *imageV = [[UIImageView alloc] init];
        _imageView = imageV;
        // 注意:一定要加在contentView上
        [self.contentView addSubview:imageV];
    }
    return _imageView;
}
// 布局子控件的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
    self.imageView.contentMode=UIViewContentModeScaleToFill;
    self.imageView.backgroundColor = [UIColor clearColor];
}

// 判断当前cell是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
{
    if (indexPath.row == count - 1) { // 最后一页,显示分享和开始按钮
        self.startButton.hidden = NO;
    }else{ // 非最后一页，隐藏分享和开始按钮
        self.startButton.hidden = YES;
    }
}
// 点击开始的时候调用
- (void)jumpToLogin {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initViewController = [storyBoard instantiateInitialViewController];
    [[[UIApplication sharedApplication] keyWindow]  setRootViewController:initViewController];
    [[[UIApplication sharedApplication] keyWindow] makeKeyAndVisible];
}

@end
