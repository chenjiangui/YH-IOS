//
//
//
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "SubLBXScanViewController.h"
#import "MyQRViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import <SCLAlertView.h>
#import "ScanResultViewController.h"
#import "ManualInputViewController.h"
#import "NewManualInputViewController.h"
#import "SnailPopupController.h"
#import "SnailFullView.h"

@interface SubLBXScanViewController ()

@property (nonatomic, strong) UILabel* titleLab;
@property (nonatomic, strong) UILabel* tipLab;
@property (nonatomic, strong) UIButton* photoBtn;
@property (nonatomic, strong) UIButton* backBtn;
@property (nonatomic, strong) UIButton* handBtn;
@property (nonatomic, strong) UIButton* flashBtn;
@property (nonatomic, strong) UIButton* centerFocusBtn;


@end

@implementation SubLBXScanViewController

+ (instancetype)instance{
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 5;
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    style.colorAngle = RGBA(0, 255, 255, 1);
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    style.xScanRetangleOffset = 57.5;
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"scan_line"];
    style.colorRetangleLine = [UIColor clearColor];
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    SubLBXScanViewController *vc = [[SubLBXScanViewController alloc] init];;
    vc.style = style;
    vc.isVideoZoom = YES;
    return vc;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = [NewAppColor yhapp_10color];
        _titleLab.text = @"扫描条码";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.frame = CGRectMake(0, self.backBtn.top, 100, 44);
        _titleLab.centerX = SCREEN_WIDTH/2.0;
    }
    return _titleLab;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        MJWeakSelf;
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 20, 44, 44);
        [_backBtn setImage:@"nav_wback".imageFromSelf forState:UIControlStateNormal];
        [_backBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _backBtn;
}

- (UIButton *)photoBtn{
    if (!_photoBtn) {
        MJWeakSelf;
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_photoBtn setTitle:@"相册" forState:UIControlStateNormal];
        [_photoBtn setTitleColor:[NewAppColor yhapp_10color] forState:UIControlStateNormal];
        [_photoBtn setTitleColor:[NewAppColor yhapp_7color] forState:UIControlStateHighlighted];
        [_photoBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [weakSelf openPhoto];
        }];
        _photoBtn.frame = CGRectMake(SCREEN_WIDTH-44, 20, 44, 44);
    }
    return _photoBtn;
}

- (UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.textColor = [NewAppColor yhapp_4color];
        _tipLab.font = [UIFont systemFontOfSize:15];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.text = @"扫一扫商品上的条码, 可自动识别";
        _tipLab.frame = CGRectMake(0, 24+SCREEN_HEIGHT/2.0+(SCREEN_WIDTH-115)/2.0-self.style.centerUpOffset, 300, 15);
        _tipLab.centerX = SCREEN_WIDTH/2.0;
    }
    return _tipLab;
}

- (UIButton *)handBtn{
    if (!_handBtn) {
        MJWeakSelf;
        _handBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _handBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_handBtn setTitle:@"手动输入" forState:UIControlStateNormal];
        [_handBtn setImage:@"btn_manual2".imageFromSelf forState:UIControlStateNormal];
        [_handBtn setImage:@"btn_manual1".imageFromSelf forState:UIControlStateHighlighted];
        [_handBtn setImage:@"btn_manual1".imageFromSelf forState:UIControlStateSelected];
        [_handBtn setTitleColor:[NewAppColor yhapp_7color] forState:UIControlStateHighlighted];
        [_handBtn setTitleColor:[NewAppColor yhapp_7color] forState:UIControlStateSelected];
        [_handBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [weakSelf manualInput];
        }];
    }
    return _handBtn;
}

- (UIButton *)flashBtn{
    if (!_flashBtn) {
        MJWeakSelf;
        _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_flashBtn setTitle:@"关闭手电筒" forState:UIControlStateSelected];
        [_flashBtn setTitle:@"开启手电筒" forState:UIControlStateNormal];
        [_flashBtn setImage:@"btn_lightoff".imageFromSelf forState:UIControlStateNormal];
        [_flashBtn setImage:@"btn_lighton".imageFromSelf forState:UIControlStateHighlighted];
        [_flashBtn setImage:@"btn_lighton".imageFromSelf forState:UIControlStateSelected];
        [_flashBtn setTitleColor:[NewAppColor yhapp_7color] forState:UIControlStateHighlighted];
        [_flashBtn setTitleColor:[NewAppColor yhapp_7color] forState:UIControlStateSelected];
        [_flashBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [weakSelf openOrCloseFlash];
        }];
    }
    return _flashBtn;
}

- (UIButton *)centerFocusBtn{
    if (!_centerFocusBtn) {
        _centerFocusBtn = [[UIButton alloc] init];
        [_centerFocusBtn setImage:@"scan_focus".imageFromSelf forState:UIControlStateNormal];
        _centerFocusBtn.userInteractionEnabled = false;
        _centerFocusBtn.frame = CGRectMake(0, 0, 200, 200);
        _centerFocusBtn.centerX = SCREEN_WIDTH/2.0;
        _centerFocusBtn.centerY = SCREEN_HEIGHT/2.0 - self.style.centerUpOffset;
    }
    return _centerFocusBtn;
}

- (void)addTopItems{
    if (!self.backBtn.superview) {
        [self.view sd_addSubviews:@[self.backBtn,self.titleLab,self.photoBtn,self.centerFocusBtn]];
    }
}

- (void)addBottomItems{
    if (!self.tipLab.superview) {
        [self.view sd_addSubviews:@[self.tipLab,self.handBtn,self.flashBtn]];
        [_handBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view).offset(-40);
            make.centerX.mas_equalTo(self.view).offset(-88);
        }];
        [_handBtn sizeToFit];
        [_handBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:0];
        [_flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.handBtn);
            make.centerX.mas_equalTo(self.view).offset(88);
        }];
        [_flashBtn sizeToFit];
        [_flashBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:0];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    self.isOpenInterestRect = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (_isQQSimulator) {
//        [self drawBottomItems];
//        [self drawTitle];
//        [self.view bringSubviewToFront:_topTitle];
//    }
//    else {
//        _topTitle.hidden = YES;
//    }
    [self addTopItems];
    [self addBottomItems];
}

// 标题
//- (void)drawTitle {
//    if (_topTitle) return;
//    
//    self.topTitle = [[UILabel alloc]init];
//    _topTitle.bounds = CGRectMake(0, 0, 145, 40);
//    _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 40);
//    
//    // 3.5 inch iphone
//    if ([UIScreen mainScreen].bounds.size.height <= 568 ) {
//        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
//        _topTitle.font = [UIFont systemFontOfSize:14];
//    }
//    
//    _topTitle.textAlignment = NSTextAlignmentCenter;
//    _topTitle.numberOfLines = 0;
//    _topTitle.text = @"扫一扫";
//    _topTitle.textColor = [UIColor whiteColor];
//    
//    [self.view addSubview:_topTitle];
//    
//    UIButton *btn = [[UIButton alloc] init];
//    btn.bounds = CGRectMake(145, 0, 40, 40);
//    btn.center = CGPointMake(CGRectGetWidth(self.view.frame)-50, 40);
//    [btn setTitle:@"X" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(actionDismiss:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//}

- (IBAction)actionDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//- (void)drawBottomItems {
//    if (_bottomItemsView) return;
//    
//    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-130,
//                                                                      CGRectGetWidth(self.view.frame), 130)];
//    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//    
//    [self.view addSubview:_bottomItemsView];
//    
//    CGSize size = CGSizeMake(60, 60);
//    self.btnFlash = [[UIButton alloc] init];
//    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
//    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
//    [_btnFlash setTitle:@"开灯" forState:UIControlStateNormal];
//    _btnFlash.titleLabel.font = [UIFont systemFontOfSize:14];
//    _btnFlash.layer.borderWidth = 1;
//    _btnFlash.layer.cornerRadius = 30;
//    _btnFlash.layer.borderColor = [UIColor whiteColor].CGColor;
//   //  [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
//    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.btnPhoto = [[UIButton alloc] init];
//    _btnPhoto.bounds = _btnFlash.bounds;
//    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
//    [_btnPhoto setTitle:@"相册" forState:UIControlStateNormal];
//    _btnPhoto.titleLabel.font = [UIFont systemFontOfSize:14];
//    _btnPhoto.layer.borderWidth = 1;
//    _btnPhoto.layer.cornerRadius = 30;
//    _btnPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
//   // [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
//   // [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
//    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    self.btnManualInput = [[UIButton alloc] init];
//    _btnManualInput.bounds = _btnFlash.bounds;
//    _btnManualInput.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) *3/4 , CGRectGetHeight(_bottomItemsView.frame)/2);
//    [_btnManualInput setTitle:@"手工录入" forState:UIControlStateNormal];
//    _btnManualInput.titleLabel.font = [UIFont systemFontOfSize:14];
//    _btnManualInput.layer.cornerRadius = 30;
//    _btnManualInput.layer.borderWidth = 1;
//    _btnManualInput.layer.borderColor = [UIColor whiteColor].CGColor;
//    [_btnManualInput setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//   // [_btnManualInput setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
//    //[_btnManualInput setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor÷"] forState:UIControlStateHighlighted];
//    [_btnManualInput addTarget:self action:@selector(manualInput) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_bottomItemsView addSubview:_btnFlash];
//    [_bottomItemsView addSubview:_btnPhoto];
//    [_bottomItemsView addSubview:_btnManualInput];
//}


- (void)showError:(NSString*)str {
    [[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"知道" otherButtonTitles:nil] show];
}


- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array {
    
    if (array.count < 1) {
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    LBXScanResult *scanResult = array[0];
    NSString *strResult = scanResult.strScanned;
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
    [LBXScanWrapper systemVibrate];
    // 声音提醒
    [LBXScanWrapper systemSound];
    
    // NSString *message = [NSString stringWithFormat:@"info: %@\ntype: %@", scanResult.strScanned, scanResult.strBarCodeType];
    // [[[UIAlertView alloc] initWithTitle:@"扫描结果" message:message delegate:nil cancelButtonTitle:@"晓得了" otherButtonTitles:nil] show];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanResultViewController *scanResultVC = (ScanResultViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ScanResultViewController"];
    scanResultVC.codeInfo = scanResult.strScanned;
    scanResultVC.codeType = scanResult.strBarCodeType;
    UINavigationController *scanresult = [[UINavigationController alloc]initWithRootViewController:scanResultVC];
    [self presentViewController:scanresult animated:YES completion:nil];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult {
    strResult = strResult ?: @"识别失败";
    
    __weak __typeof(self) weakSelf = self;
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert addButton:@"知道了" actionBlock:^(void) {
        //点击完，继续扫码
        [weakSelf reStartDevice];
    }];
    [alert showInfo:self title:@"扫码内容" subTitle:strResult closeButtonTitle:nil duration:0.0f];
}


#pragma mark -底部功能项

//打开相册
- (void)openPhoto {
    if ([LBXScanWrapper isGetPhotoPermission]) {
        [self openLocalPhoto];
    }
    else {
        [self showError:@"请到设置->隐私中开启本程序相册权限"];
    }
}

//开关闪光灯
- (void)openOrCloseFlash {
    [super openOrCloseFlash];
    self.flashBtn.selected = self.isOpenFlash;
  //  NSString *imageName = [NSString stringWithFormat:@"CodeScan.bundle/qrcode_scan_btn_flash_%@", self.isOpenFlash ? @"down" : @"nor"];
  //  [_btnFlash setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

#pragma mark -底部功能项
- (void)myQRCode {
    MyQRViewController *vc = [MyQRViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

// 手动输入
- (void)manualInput {
    
//    ManualInputViewController *manualInput = [[ManualInputViewController alloc]init];
//    manualInput.fromViewController = @"click";
//    UINavigationController *manulCtrl = [[UINavigationController alloc]initWithRootViewController:manualInput];
//    [self presentViewController:manulCtrl animated:YES completion:nil];

//    NewManualInputViewController *NewManual=[[NewManualInputViewController alloc] init];
//    [self.navigationController pushViewController:NewManual animated:YES];
//    
//    UINavigationController *manulCtrl = [[UINavigationController alloc]initWithRootViewController:NewManual];
//   [self presentViewController:manulCtrl animated:YES completion:nil];

    
    
    [self openOrCloseFlash];
    
//    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    NSError *error = nil;
//    if ([captureDevice hasTorch]) {
//        BOOL locked = [captureDevice lockForConfiguration:&error];
//        if (locked) {
//            captureDevice.torchMode = AVCaptureTorchModeOff;
//            [captureDevice unlockForConfiguration];
//        }
//    }
    
    
    [self example5];
    
}
- (void)example5 {
    SnailFullView *full = [self fullView];
    
    full.didClickFullView = ^(SnailFullView * _Nonnull fullView) {
        [self.sl_popupController dismiss];
    };
    
    full.didClickItems = ^(SnailFullView *fullView, NSInteger index) {
        self.sl_popupController.didDismiss = ^(SnailPopupController * _Nonnull popupController) {
        };
        
        [fullView endAnimationsCompletion:^(SnailFullView *fullView) {
            [self.sl_popupController dismiss];
        }];
    };
    
    self.sl_popupController = [SnailPopupController new];
    self.sl_popupController.maskType = PopupMaskTypeBlackBlur;
    self.sl_popupController.allowPan = YES;
    [self.sl_popupController presentContentView:full];
    //跳转到手输入的报表页面
    full.clickTapBlock=^(NSString *InputNumString){
 
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ScanResultViewController *scanResultVC = (ScanResultViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ScanResultViewController"];
        scanResultVC.codeInfo = InputNumString;
        scanResultVC.codeType = @"input";
        UINavigationController *scanresult = [[UINavigationController alloc]initWithRootViewController:scanResultVC];
        [self presentViewController:scanresult animated:YES completion:nil];
    };
}


- (SnailFullView *)fullView {
    
    SnailFullView *fullView = [[SnailFullView alloc] initWithFrame:self.view.frame];
    
    fullView.backgroundColor=[[NewAppColor yhapp_5color] colorWithAlphaComponent:0.7];
    
    return fullView;
}

@end
