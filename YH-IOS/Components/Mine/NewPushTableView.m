//
//  NewPushTableView.m
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/8/2.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NewPushTableView.h"
#import "FileUtils+Assets.h"
#import "NewPushTableCell.h"
#import "SubjectViewController.h"
@interface NewPushTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *PushTableview;

    NSMutableArray *PushInfo;
}
@end

@implementation NewPushTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推送消息";
    [self.view setBackgroundColor:[NewAppColor yhapp_8color]];
    [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]},@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[NewAppColor yhapp_6color]}] ;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    UIImage *imageback = [[UIImage imageNamed:@"newnav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn addSubview:bakImage];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
 
    NSString *filePath = [[FileUtils userspace] stringByAppendingPathComponent:@"PushInfo.plist"];
    PushInfo=[NSMutableArray array];
    PushInfo = [NSMutableArray arrayWithContentsOfFile:filePath];
//    NSLog(@"%@",PushInfo);
//    PushInfo=[NSMutableArray array];
//    for (int i=0; i<userInfo.count; i++) {
//        NSString *info=[[[userInfo objectAtIndex:i] objectForKey:@"aps"] objectForKey:@"alert"];
//        [PushInfo addObject:info];
//    }
    [self setTableView];
}

-(void)setTableView
{
    PushTableview=[[UITableView alloc] init];
    [self.view addSubview:PushTableview];
    [PushTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height));
    }];
    PushTableview.contentInset = UIEdgeInsetsMake(0, 0, 67, 0);
    [PushTableview setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"]];
    //    GroupTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    PushTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    PushTableview.dataSource = self;
    PushTableview.delegate = self;
}
#pragma  get GroupArray count  to set number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (PushInfo.count==0) {
        [PushTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        return 0;
    }
    else
    return PushInfo.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 107;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (PushInfo.count==0) {
         return 0;
    }
    else
    return 10;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return SCREEN_HEIGHT-PushInfo.count*107+10;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (PushInfo.count==0) {
        return nil;
    }
    else
    {
        static NSString *Identifier = @"PushCell";
        NewPushTableCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[NewPushTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            
        }
        [cell UserInfo:PushInfo[indexPath.row]];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
        UIView *cellBackGround=[[UIView alloc] init];
        [cellBackGround setBackgroundColor:[NewAppColor yhapp_8color]];
        cell.selectedBackgroundView = cellBackGround;
//        NewPushTableCell* cell = [NewPushTableCell cellWithTableView:tableView needXib:false];
//        [cell UserInfo:PushInfo[indexPath.row]];
//        [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
//        UIView *cellBackGround=[[UIView alloc] init];
//        [cellBackGround setBackgroundColor:[NewAppColor yhapp_8color]];
//        cell.selectedBackgroundView = cellBackGround;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (PushInfo.count==0) {
        return;
    }
    else
    {
    if ([[PushInfo[indexPath.row] objectForKey:@"readState"] isEqualToString:@"false"]) {
        [PushInfo[indexPath.row] setValue:@"true" forKey:@"readState"];
        NSString *path = [FileUtils userspace];
        NSString *plistPath = [path stringByAppendingPathComponent:@"PushInfo.plist"];
        [PushInfo writeToFile:plistPath atomically:YES];
        [PushTableview reloadData];
    }
    NSString *remoteType = PushInfo[indexPath.row][@"type"];
    if ([remoteType isEqualToString:@"kpi"]) {
        return;
    }
    else if ([remoteType isEqualToString:@"report"]){
        [self jumpToDetailViewWithDict:PushInfo[indexPath.row]];
    }
    else if ([remoteType isEqualToString:@"message"]){
        self.tabBarController.selectedIndex = 3;
    }
    else if ([remoteType isEqualToString:@"analyse"]){
        self.tabBarController.selectedIndex = 1;
    }
    else if ([remoteType isEqualToString:@"app"]){
        self.tabBarController.selectedIndex = 2;
    }
    else{
        return;
    }
        
    }
}

-(void)jumpToDetailViewWithDict:(NSDictionary*)dict{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
    subjectView.bannerName =dict[@"title"];
    subjectView.link = dict[@"url"];
    subjectView.commentObjectType = [dict[@"obj_type"] intValue];
    subjectView.objectID = dict[@"obj_id"];
    /* else if ([data[@"link"] rangeOfString:@"template/"].location != NSNotFound){
     if ([data[@"link"] rangeOfString:@"template/5/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/1/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/2/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/3/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/4/"].location == NSNotFound) {
     SCLAlertView *alert = [[SCLAlertView alloc] init];
     [alert addButton:@"下一次" actionBlock:^(void) {}];
     [alert addButton:@"立刻升级" actionBlock:^(void) {
     NSURL *url = [NSURL URLWithString:[kPgyerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     [[UIApplication sharedApplication] openURL:url];
     }];
     [alert showSuccess:self title:@"温馨提示" subTitle:@"您当前的版本暂不支持该模块，请升级之后查看" closeButtonTitle:nil duration:0.0f];
     }
     }*/
    
    UINavigationController *subjectCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
    [self presentViewController:subjectCtrl animated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
