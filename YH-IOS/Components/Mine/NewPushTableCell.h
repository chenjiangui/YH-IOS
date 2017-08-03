//
//  NewPushTableCell.h
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/8/2.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPushTableCell : UITableViewCell



@property(nonatomic,strong)UILabel *infoTitle;
@property(nonatomic,strong)UILabel *infoContent;
@property(nonatomic,strong)UILabel *pushTime;

@property(nonatomic,strong)UIButton *readState;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)UserInfo:(NSDictionary*)Pushinfo;

@end
