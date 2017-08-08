//
//  NewManualInputViewController.m
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/8/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NewManualInputViewController.h"

@interface NewManualInputViewController ()
{
    UIView *inputView;
    UITextField *InputNum;
    UIButton *OpenLight;
    UILabel *OpenLabel;
    UIButton *quest;
}
@end

@implementation NewManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手动输入条码";
    [self.view setBackgroundColor:[NewAppColor yhapp_5color]];
    self.view.alpha=0.5;
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
    
    
    inputView=[[UIView alloc] init];
    [self.view addSubview:inputView];
    inputView.backgroundColor=[NewAppColor yhapp_1color];
    inputView.alpha=0.6;
    inputView.layer.cornerRadius=8;
    
    OpenLight =[[UIButton alloc] init];
    [self.view addSubview:OpenLight];
    
    [OpenLight setBackgroundImage:[UIImage imageNamed:@"btn_lightoff"] forState:UIControlStateNormal];
    
    [OpenLight setBackgroundImage:[UIImage imageNamed:@"btn_lighton"]  forState:UIControlStateSelected];
    

    OpenLabel =[[UILabel alloc] init];
    [self.view addSubview:OpenLabel];
    
    
    
    
    OpenLabel.text=@"打开手电筒";
    OpenLabel.textColor=[UIColor whiteColor];
    OpenLabel.font=[UIFont systemFontOfSize:12];
    

    
    
    
    
    
    
    
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
        make.top.mas_equalTo(self.mas_topLayoutGuideTop).offset(44);
//        make.left.mas_equalTo(self.view.mas_left).offset(16);
           make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(344, 52));
      }];
}




- (void)backAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
