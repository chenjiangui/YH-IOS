//
//  NewManualInputViewController.m
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/8/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NewManualInputViewController.h"
#import "ScanResultViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface NewManualInputViewController ()
{
    UIView *inputView;
    UITextField *InputNum;
    UIButton *OpenLight;
    UILabel *OpenLabel;
    UIButton *quest;
    NSString *InputNumString;

}
@property (nonatomic,strong) AVCaptureSession * captureSession;
@property (nonatomic,strong) AVCaptureDevice * captureDevice;

@end

@implementation NewManualInputViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手动输入条码";
    [self.view setBackgroundColor:[NewAppColor yhapp_5color]];
//    self.view.alpha=0.5;
    


    [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    self.navigationController.navigationBar.barTintColor =[NewAppColor yhapp_5color];
    self.navigationController.navigationBar.alpha=0.5f;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    UIImage *imageback = [[UIImage imageNamed:@"nav_wback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn addSubview:bakImage];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
    
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
    [self addTopItems];
    [self addframe];
}


- (void)addTopItems{
    [self.view sd_addSubviews:@[self.inputView,self.InputNum,self.OpenLightbtn,self.OpenLabel]];
}
-(void)addframe
{
    
    [InputNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inputView.mas_left).offset(57);
        make.centerX.mas_equalTo(inputView.mas_centerX);
        make.centerY.mas_equalTo(inputView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width,50));
    }];
    
    [OpenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(OpenLight.mas_bottom);
        make.centerX.mas_equalTo(self.view);
    }];
    [OpenLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inputView.mas_bottom).offset(28);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(57, 57));
    }];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_topMargin).offset(108);
        //        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(344, 52));
    }];
}

-(void)InputNumChange:(UITextField*)InputNumber
{
    InputNumString=InputNumber.text;
}
//控制placeHolder的位置
//-(CGRect)placeholderRectForBounds:(CGRect)bounds
//{
//    CGRect inset = CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
//    return inset;
//}
- (void)backAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)OpenLight
{
    if (OpenLight.tag==100) {
        [OpenLight setBackgroundImage:[UIImage imageNamed:@"btn_lighton"]  forState:UIControlStateNormal];
        OpenLight.tag=101;
        
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
        [OpenLight setBackgroundImage:[UIImage imageNamed:@"btn_lightoff"]  forState:UIControlStateNormal];
        OpenLight.tag=100;
        
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
    quest=[[UIButton alloc] init];
    [self.view addSubview:quest];
    quest.backgroundColor=[NewAppColor yhapp_10color];
    quest.titleLabel.textAlignment=NSTextAlignmentCenter;
    [quest setTitle:@"确认" forState:UIControlStateNormal];
    [quest setTitleColor:[NewAppColor yhapp_1color] forState:UIControlStateNormal];
    [quest addTarget:self action:@selector(quest) forControlEvents:UIControlEventTouchUpInside];
    quest.titleLabel.font=[UIFont systemFontOfSize:16];
    [quest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom).offset(-(height+50));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    quest.hidden=YES;
    [quest removeFromSuperview];
}

-(void)quest
{
    quest.hidden=YES;
    [quest removeFromSuperview];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSLog(@"%@",InputNumString);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanResultViewController *scanResultVC = (ScanResultViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ScanResultViewController"];
    if ([InputNumString length] != 0) {
        scanResultVC.codeInfo = InputNumString;
        scanResultVC.codeType = @"input";
        UINavigationController *scanresult = [[UINavigationController alloc]initWithRootViewController:scanResultVC];
        [self presentViewController:scanresult animated:YES completion:nil];
    }
    else {
         [HudToolView showTopWithText:@"输入信息为空" color:[NewAppColor yhapp_11color]];
    }
}

- (UILabel *)OpenLabel{
    if (!OpenLabel) {
        OpenLabel =[[UILabel alloc] init];
        [self.view addSubview:OpenLabel];
        OpenLabel.text=@"打开手电筒";
        OpenLabel.textColor=[UIColor whiteColor];
        OpenLabel.font=[UIFont systemFontOfSize:12];
        
    }
    return OpenLabel;
}

- (UIButton *)OpenLightbtn{
    if (!OpenLight) {
        OpenLight =[[UIButton alloc] init];
        [self.view addSubview:OpenLight];
        [OpenLight addTarget:self action:@selector(OpenLight) forControlEvents:UIControlEventTouchUpInside];
        OpenLight.tag=100;
        [OpenLight setBackgroundImage:[UIImage imageNamed:@"btn_lightoff"] forState:UIControlStateNormal];
    }
    return OpenLight;
}

- (UIView *)inputView{
    if (!inputView) {
        inputView=[[UIView alloc] init];
        [self.view addSubview:inputView];
        inputView.backgroundColor=[NewAppColor yhapp_1color];
        inputView.alpha=0.6;
        inputView.layer.cornerRadius=8;
    }
    return inputView;
}
- (UITextField *)InputNum{
    if (!InputNum) {
        InputNum=[[UITextField alloc] init];
        
        [self.view addSubview:InputNum];
        
        //    [InputNum setValue:[UIFont systemFontOfSize:40] forKeyPath:@"ALTGOT2N.TTF"];
        
        InputNum.textColor=[NewAppColor yhapp_10color];
        
        InputNum.tintColor= [NewAppColor yhapp_7color];
        
        InputNum.font=[UIFont systemFontOfSize:40];
        
//        InputNum.font = [UIFont fontWithName:@"ALTGOT2N" size:80];
        [InputNum addTarget:self action:@selector(InputNumChange:) forControlEvents:UIControlEventEditingChanged];
        
        InputNum.keyboardType=UIKeyboardTypeNumberPad;
    }
    return InputNum;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
