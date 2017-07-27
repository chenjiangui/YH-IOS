//
//  NewMineQuestionController.m
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/7/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NewMineQuestionController.h"
#import "PhotoNavigationController.h"
#import "PhotoManagerConfig.h"
#import "PhotoRevealCell.h"
#import "UIImage+StackBlur.h"
#import "zoomPopup.h"
#import "UIImage+StackBlur.h"
#import "User.h"
#import "SCLAlertView.h"
#import "Version.h"
#import "APIHelper.h"

@interface NewMineQuestionController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView *QuestionTableView;
    UIButton *saveBtn;
}

@end

@implementation NewMineQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController setNavigationBarHidden:false];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#32414b"]}] ;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    
    UIImage *imageback = [[UIImage imageNamed:@"newnav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    bakImage.image = imageback;
    
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(NewQuestionViewBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn addSubview:bakImage];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];

    [self setTableView];
}


-(void)setTableView
{
    
    QuestionTableView=[[UITableView alloc] init];
    
    [self.view addSubview:QuestionTableView];
    
    
    QuestionTableView.scrollEnabled =NO; //设置tableview 不能滚动
    
    [QuestionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height));
    }];
    [QuestionTableView setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"]];
    QuestionTableView.dataSource = self;
    QuestionTableView.delegate = self;
    
}

#pragma  get GroupArray count  to set number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        return 155;
    }
    else if (indexPath.row==1)
    {
        return 110;
    }
    else if (indexPath.row==2)
    {
        return 45;
    }
    else
    {
        return 50;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

        return self.view.frame.size.height-360;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        static NSString *Identifier = @"questionCell";
        UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {//重新实例化对象的时候才添加button，队列中已有的cell上面是有button的
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            //添加按钮（或者其它控件）也可以写在继承自UITableViewCell的子类中,然后用子类来实例化这里的cell，将button作为子类的属性，这样添加button的触发事件的响应可以写在这里，target就是本类，方法也在本类中实现
        
            UILabel *opinionLabel=[[UILabel alloc] init];
            opinionLabel.text=@"问题修改及改进意见：";
            opinionLabel.textColor=[UIColor colorWithHexString:@"#666666"];
            opinionLabel.font=[UIFont systemFontOfSize:15];
            opinionLabel.textAlignment=NSTextAlignmentLeft;
            [cell addSubview:opinionLabel];
            UITextView *opinionTextview=[[UITextView alloc] init];
            opinionTextview.text=@"请描述您遇到的问题(1-500字)";
            opinionTextview.textColor=[UIColor colorWithHexString:@"bcbcbc"];
            opinionTextview.font=[UIFont systemFontOfSize:15];
            opinionTextview.textAlignment=NSTextAlignmentLeft;
            opinionTextview.userInteractionEnabled=YES;

            opinionTextview.delegate=self;
            opinionTextview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            opinionTextview.keyboardType = UIKeyboardTypeDefault;
            [cell addSubview:opinionTextview];
            [opinionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).offset(16);
                make.left.mas_equalTo(cell.mas_left).offset(16);
            }];
            [opinionTextview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).offset(44);
                make.left.mas_equalTo(cell.mas_left).offset(16);
                make.right.mas_equalTo(cell.mas_right).offset(-16);
                make.size.mas_equalTo(CGSizeMake(cell.bounds.size.width, cell.bounds.size.height));
            }];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row==1)
    {
        static NSString *Identifier = @"photoCell";
        UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {//重新实例化对象的时候才添加button，队列中已有的cell上面是有button的
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            //添加按钮（或者其它控件）也可以写在继承自UITableViewCell的子类中,然后用子类来实例化这里的cell，将button作为子类的属性，这样添加button的触发事件的响应可以写在这里，target就是本类，方法也在本类中实现
            UILabel *oscreenshotLabel=[[UILabel alloc] init];
            oscreenshotLabel.text=@"页面截图(最多3张)：";
            
            oscreenshotLabel.textColor=[UIColor colorWithHexString:@"#666666"];
            
            oscreenshotLabel.font=[UIFont systemFontOfSize:15];
            
             [cell addSubview:oscreenshotLabel];
            
            [oscreenshotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).offset(16);
                make.left.mas_equalTo(cell.mas_left).offset(16);
            }];
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else if (indexPath.row==2)
    {
        static NSString *Identifier = @"photoCell";
        UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {//重新实例化对象的时候才添加button，队列中已有的cell上面是有button的
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            //添加按钮（或者其它控件）也可以写在继承自UITableViewCell的子类中,然后用子类来实例化这里的cell，将button作为子类的属性，这样添加button的触发事件的响应可以写在这里，target就是本类，方法也在本类中实现
            
            UILabel *stimulateLabel=[[UILabel alloc] init];
            
            stimulateLabel.text=@"您的鞭策是我们进步的源泉，感谢您的宝贵意见！";
            
            
            stimulateLabel.textColor=[UIColor colorWithHexString:@"#666666"];
            
            stimulateLabel.font=[UIFont systemFontOfSize:13];
            
            [cell.contentView addSubview:stimulateLabel];
            [stimulateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(cell.contentView.mas_centerX);
                 make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            }];
            [cell setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"]];

        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *Identifier = @"saveCell";
        UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {//重新实例化对象的时候才添加button，队列中已有的cell上面是有button的
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            //添加按钮（或者其它控件）也可以写在继承自UITableViewCell的子类中,然后用子类来实例化这里的cell，将button作为子类的属性，这样添加button的触发事件的响应可以写在这里，target就是本类，方法也在本类中实现
            saveBtn=[[UIButton alloc]init];
            [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
            saveBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
            [saveBtn addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
            [saveBtn setTitleColor:[UIColor colorWithHexString:@"#00a4e9"] forState:UIControlStateNormal];
            [saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            [saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"]  forState:UIControlStateSelected];
            [saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"] forState:UIControlStateHighlighted];
            [cell addSubview:saveBtn];
            [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(cell.mas_centerX);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 50));
            }];
        }
        return cell;

    }
}



//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    return YES;
//    
//}
/**
 开始编辑
 @param textView textView
 */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请描述您遇到的问题(1-500字)"]) {
        
        textView.text = @"";
        
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text length]==0) {
        textView.text = @"请描述您遇到的问题(1-500字)";
    }
}


-(void)textViewDidChange:(UITextView *)textView
{
        NSLog(@"%@",textView.text);
}


-(void)saveBtn
{
    NSLog(@"13");

}









-(void)NewQuestionViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
