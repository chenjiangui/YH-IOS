//
//  ManageWarningItemCell.m
//  YH-IOS
//
//  Created by cjg on 2017/7/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "ManageWarningItemCell.h"
#import "YHKPIModel.h"

@interface ManageWarningItemCell ()
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;
@property (weak, nonatomic) IBOutlet UILabel *topRightLab;
@property (weak, nonatomic) IBOutlet UILabel *centerLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;
@property (weak, nonatomic) IBOutlet UIView *tipView;

@end

@implementation ManageWarningItemCell

+ (CGSize)sizeForSelf{
    return CGSizeMake(165, 90);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_contentV setBorderColor:UIColorHex(e6e6e6) width:0.5];
    [_tipView cornerRadius:4];
}

- (void)setItem:(YHKPIDetailModel*)item{
    _centerLab.text = SafeText(item.title);
    _unitLab.text = SafeText(item.unit);
    _bottomLab.text = SafeText(item.memo1);
    _topLab.text = SafeText(item.hightLightData.number);
    _topRightLab.text = SafeText(item.hightLightData.compare);
    _tipView.hidden = IsEmptyText(_bottomLab.text);
    NSString *colorText = WarnColor[item.hightLightData.arrow];
    _topRightLab.textColor = [UIColor colorWithHexString:colorText];
}

@end
