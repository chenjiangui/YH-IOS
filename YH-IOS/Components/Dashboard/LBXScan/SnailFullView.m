//
//  SnailFullView.m
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "SnailFullView.h"
#import "ScanResultViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LineTextFiled.h"

@interface SnailFullView () <UIScrollViewDelegate> {
    CGFloat _gap, _space;
}

@property (nonatomic, strong) UILabel  *dateLabel;
@property (nonatomic, strong) UILabel  *weekLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *closeIcon;
@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *pageViews;

@property (nonatomic, strong) UIView *InputView;
@property (nonatomic, strong) LineTextFiled *InputNum;
@property (nonatomic, strong) UIButton *OpenLight;
@property (nonatomic, strong) UILabel *OpenLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *BackBtn;
@property (nonatomic, strong) UIButton *quest;
@property (nonatomic, strong) NSString *InputNumString;
@property (nonatomic,strong) AVCaptureSession * captureSession;
@property (nonatomic,strong) AVCaptureDevice * captureDevice;

@end

@implementation SnailFullView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [self setupUI];
    }
    return self;
}


-(void)setupUI
{
    [self sd_addSubviews:@[self.BackBtn,self.titleLabel,self.InputView,self.InputNum,self.OpenLightbtn,self.OpenLabel]];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topMargin).offset(33);
        make.centerX.mas_equalTo(self);
    }];
    
    [_BackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(19);
        make.centerY.mas_equalTo(_titleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];

    [_InputNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_InputView.mas_left).offset(57);
        make.centerX.mas_equalTo(_InputView.mas_centerX);
        make.centerY.mas_equalTo(_InputView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width,50));
    }];
    
    [_OpenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_OpenLight.mas_bottom);
        make.centerX.mas_equalTo(self);
    }];
    [_OpenLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_InputView.mas_bottom).offset(28);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(57, 57));
    }];
    
    [_InputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topMargin).offset(108);
        //        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.centerX.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(16);
        make.height.mas_equalTo(52);
    }];
}
-(void)InputNumChange:(UITextField*)InputNumber
{
    _InputNumString=InputNumber.text;
}


-(void)OpenLightBtn
{
    if (_OpenLight.tag==100) {
        [_OpenLight setBackgroundImage:[UIImage imageNamed:@"btn_lighton"]  forState:UIControlStateNormal];
        _OpenLight.tag=101;
        _OpenLabel.text=@"关闭手电筒";
        _OpenLabel.textColor=[NewAppColor yhapp_7color];
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
    }
    else
    {
        _OpenLabel.text=@"开启手电筒";
        _OpenLabel.textColor=[NewAppColor yhapp_10color];
        [_OpenLight setBackgroundImage:[UIImage imageNamed:@"btn_lightoff"]  forState:UIControlStateNormal];
        _OpenLight.tag=100;
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
    
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _quest=[[UIButton alloc] init];
    [self addSubview:_quest];
    _quest.backgroundColor=[NewAppColor yhapp_10color];
    _quest.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_quest setTitle:@"确认" forState:UIControlStateNormal];
    [_quest setTitleColor:[NewAppColor yhapp_1color] forState:UIControlStateNormal];
    [_quest addTarget:self action:@selector(questBtn) forControlEvents:UIControlEventTouchUpInside];
    _quest.titleLabel.font=[UIFont systemFontOfSize:16];
    [_quest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).offset(-(height+50));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    _quest.hidden=YES;
    [_quest removeFromSuperview];
}
-(void)questBtn
{
    _quest.hidden=YES;
    [_quest removeFromSuperview];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [HudToolView showLoadingInView:self];
    [self setUserInteractionEnabled:NO];
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
    if ([_InputNumString length] != 0) {
        if (!_clickTapBlock) {
            return;
        }
        _clickTapBlock(_InputNumString);
    }
    else {
        [HudToolView showTopWithText:@"输入信息为空" color:[NewAppColor yhapp_11color]];
    }
}

//延时执行函数
-(void)delayMethod
{
    self.userInteractionEnabled=YES;
    [HudToolView hideLoadingInView:self];
    
}
- (UIButton *)BackBtn{
    if (!_BackBtn) {
        _BackBtn =[[UIButton alloc] init];
//         _BackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
        UIImage *imageback = [[UIImage imageNamed:@"Banner-Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        bakImage.image = imageback;
        [bakImage setContentMode:UIViewContentModeScaleAspectFit];
        [_BackBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_BackBtn addSubview:bakImage];
    }
    return _BackBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] init];
        _titleLabel.text=@"手动输入条码";
        _titleLabel.textColor=[NewAppColor yhapp_10color];
        _titleLabel.font=[UIFont systemFontOfSize:17];
    }
    return _titleLabel;
}

- (UILabel *)OpenLabel{
    if (!_OpenLabel) {
        _OpenLabel =[[UILabel alloc] init];
        _OpenLabel.text=@"打开手电筒";
        _OpenLabel.textColor=[UIColor whiteColor];
        _OpenLabel.font=[UIFont systemFontOfSize:12];
        
    }
    return _OpenLabel;
}

- (UIButton *)OpenLightbtn{
    if (!_OpenLight) {
        _OpenLight =[[UIButton alloc] init];
        [_OpenLight addTarget:self action:@selector(OpenLightBtn) forControlEvents:UIControlEventTouchUpInside];
        _OpenLight.tag=100;
        [_OpenLight setBackgroundImage:[UIImage imageNamed:@"btn_lightoff"] forState:UIControlStateNormal];
    }
    return _OpenLight;
}
- (UIView *)InputView{
    if (!_InputView) {
        _InputView=[[UIView alloc] init];
        _InputView.userInteractionEnabled=YES;
        _InputView.backgroundColor=[NewAppColor yhapp_1color];
        _InputView.alpha=0.6;
        _InputView.layer.cornerRadius=8;
    }
    return _InputView;
}
- (LineTextFiled *)InputNum{
    if (!_InputNum) {
        _InputNum=[[LineTextFiled alloc] init];
        _InputNum.userInteractionEnabled=YES;
        //    [InputNum setValue:[UIFont systemFontOfSize:40] forKeyPath:@"ALTGOT2N.TTF"];
        _InputNum.textColor =[NewAppColor yhapp_10color];
        _InputNum.tintColor = [NewAppColor yhapp_7color];
        _InputNum.textAlignment = NSTextAlignmentCenter;
        _InputNum.font  = [UIFont fontWithName:CustomFontName size:40];
        [_InputNum addTarget:self action:@selector(InputNumChange:) forControlEvents:UIControlEventEditingChanged];
        _InputNum.keyboardType=UIKeyboardTypeNumberPad;
    }
    return _InputNum;
}

/** 返回*/
-(void)backAction
{
    WeakSelf;
    self.didClickFullView(weakSelf);
}

- (void)closeClicked:(UIButton *)sender {
    [_scrollContainer setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x /SCREEN_WIDTH + 0.5;
    _closeButton.userInteractionEnabled = index > 0;
    [_closeIcon setImage:[UIImage imageNamed:(index ? @"sina_返回" : @"sina_关闭")] forState:UIControlStateNormal];
}

- (void)startAnimationsCompletion:(void (^ __nullable)(BOOL finished))completion {
    
    [UIView animateWithDuration:0.5 animations:^{
        _closeIcon.transform = CGAffineTransformMakeRotation(M_PI_4);
    } completion:NULL];

}

- (void)endAnimationsCompletion:(void (^)(SnailFullView *))completion {
    
        [UIView animateWithDuration:0.35 animations:^{
            
        } completion:NULL];
    
    

}

@end
