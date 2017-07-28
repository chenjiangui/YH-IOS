//
//  BusinessGeneralCell.m
//  YH-IOS
//
//  Created by cjg on 2017/7/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "BusinessGeneralCell.h"
#import "YHKPIModel.h"

@interface BusinessGeneralCell ()
@property (weak, nonatomic) IBOutlet UILabel *topLeftLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomRightLab;
@property (weak, nonatomic) IBOutlet UILabel *topRightLab;

@end

@implementation BusinessGeneralCell

+ (CGFloat)heightForSelf{
    return 80;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(YHKPIDetailModel*)item{
    
    _topLeftLab.text = SafeText(item.hightLightData.compare);
    _bottomLeftLab.text = SafeText(item.memo2);
    _topRightLab.text = SafeText(item.title);
    _bottomRightLab.text = [NSString stringWithFormat:@"%@%@%@",SafeText(item.memo1),SafeText(item.hightLightData.number),SafeText(item.unit)];
    if (!IsEmptyText(item.hightLightData.number)) {
        NSRange range = [_bottomRightLab.text rangeOfString:item.hightLightData.number];
        [_bottomRightLab setLabelColor:UIColorHex(4688b5) StringFromLocation:range.location StringNeedLength:range.length + SafeText(item.unit).length];
    }
    _topLeftLab.textColor = [_topLeftLab.text removeString:@"%"].floatValue > 0 ? UIColorHex(91c941):UIColorHex(f57658);


}

@end
