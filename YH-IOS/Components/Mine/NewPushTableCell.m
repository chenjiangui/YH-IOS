//
//  NewPushTableCell.m
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/8/2.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NewPushTableCell.h"

@implementation NewPushTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        _infoTitle=[[UILabel alloc] init];
        [self.contentView addSubview:_infoTitle];

        _infoContent=[[UILabel alloc] init];
        [self.contentView addSubview:_infoContent];
        
        _pushTime=[[UILabel alloc] init];
        [self.contentView addSubview:_pushTime];

        [_infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(16);
            make.top.mas_equalTo(self.contentView).offset(16);
        }];
    
        [_infoContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_infoTitle.mas_bottom).offset(10);
            make.left.mas_equalTo(self.contentView).offset(16);
            make.right.mas_equalTo(self.contentView).offset(-16);
//            make.height.mas_equalTo(30);
            
        }];
        
        [_pushTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(16);
            make.bottom.mas_equalTo(self.contentView).offset(-16);
        }];
    }
    return self;
}
-(void)UserInfo:(NSDictionary*)Pushinfo
{
    _infoTitle.text=[Pushinfo objectForKey:@"title"];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 4;// 字体的行间距
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 };
//    _infoContent.attributedText = [[NSAttributedString alloc] initWithString:[[Pushinfo objectForKey:@"aps"] objectForKey:@"alert"] attributes:attributes];
    _infoContent.text=[[Pushinfo objectForKey:@"aps"] objectForKey:@"alert"];
    _pushTime.text=[Pushinfo objectForKey:@"PushTime"];
    [_infoContent sizeToFit];
    
    
    _readState=[[UIButton alloc] init];
    [_readState setBackgroundColor:[NewAppColor yhapp_11color]];
    [self.contentView addSubview:_readState];
    [_readState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 6));
        make.left.mas_equalTo(_infoTitle.mas_right).offset(12);
        make.centerY.mas_equalTo(_infoTitle.mas_centerY);
    }];
    _readState.layer.cornerRadius = 3;
    _readState.clipsToBounds = YES;
    if ([[Pushinfo objectForKey:@"readState"] isEqualToString:@"false"]) {
        _readState.hidden=NO;
        
        [_infoTitle setFont:[UIFont boldSystemFontOfSize:15]];
        _infoTitle.textAlignment = NSTextAlignmentLeft;
        [_infoTitle setTextColor:[NewAppColor yhapp_6color]];
        
        [_infoContent setTextColor:[NewAppColor yhapp_3color]];
        [_infoContent setFont:[UIFont systemFontOfSize:12]];
        _infoContent.numberOfLines=2;
        _infoContent.textAlignment = NSTextAlignmentLeft;
        
        
        [_pushTime setFont:[UIFont systemFontOfSize:11]];
        [_pushTime setTextColor:[NewAppColor yhapp_4color]];
        _pushTime.textAlignment = NSTextAlignmentLeft;
    }
    else if ([[Pushinfo objectForKey:@"readState"] isEqualToString:@"true"])
    {
        [_infoTitle setFont:[UIFont boldSystemFontOfSize:15]];
        _infoTitle.textAlignment = NSTextAlignmentLeft;
        [_infoTitle setTextColor:[NewAppColor yhapp_4color]];
        
        [_infoContent setFont:[UIFont systemFontOfSize:12]];
        _infoContent.numberOfLines=2;
        _infoContent.textAlignment = NSTextAlignmentLeft;
        [_infoContent setTextColor:[NewAppColor yhapp_4color]];
        
        [_pushTime setFont:[UIFont systemFontOfSize:11]];
        _pushTime.textAlignment = NSTextAlignmentLeft;
        [_pushTime setTextColor:[NewAppColor yhapp_4color]];
         _readState.hidden=YES;
    }
    else
    {
        [_infoTitle setFont:[UIFont boldSystemFontOfSize:15]];
        _infoTitle.textAlignment = NSTextAlignmentLeft;
        [_infoTitle setTextColor:[NewAppColor yhapp_4color]];
        
        [_infoContent setFont:[UIFont systemFontOfSize:12]];
        _infoContent.numberOfLines=2;
        _infoContent.textAlignment = NSTextAlignmentLeft;
        [_infoContent setTextColor:[NewAppColor yhapp_4color]];
        
        [_pushTime setFont:[UIFont systemFontOfSize:11]];
        _pushTime.textAlignment = NSTextAlignmentLeft;
        [_pushTime setTextColor:[NewAppColor yhapp_4color]];
        _readState.hidden=YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
