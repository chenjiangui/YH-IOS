//
//  NewAppColor.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/7/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NewAppColor.h"

#define UIColorHex(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]

@implementation NewAppColor


+(UIColor *)yhapp_1color{
    return UIColorHex(00a4e9);
}

+(UIColor*)yhapp_2color{
    return UIColorHex(91c941);
}

+(UIColor*)yhapp_3color {
    return UIColorHex(666666);
}

+(UIColor*)yhapp_4color{
    return UIColorHex(bcbcbc);
}

+(UIColor*)yhapp_5color{
    return UIColorHex(2c3841);
}

+(UIColor*)yhapp_6color{
    return UIColorHex(32414b);
}

+(UIColor*)yhapp_7color{
    return UIColorHex(00ffff);
}

+(UIColor*)yhapp_8color{
    return UIColorHex(f3f3f3);
}

+(UIColor*)yhapp_9color{
    return UIColorHex(e6e6e6);
}

+(UIColor*)yhapp_10color{
    return UIColorHex(ffffff);
}

+(UIColor*)yhapp_11color{
    return UIColorHex(f57658);
}

+(UIColor*)yhapp_12color{
    return UIColorHex(f4bc45);
}

+(UIColor*)yhapp_13color{
    return UIColorHex(3cc7c9);
}

+(UIColor*)yhapp_14color{
    return UIColorHex(71a3ed);
}

+(UIColor *)yhapp_15color{
    return UIColorHex(4688b5);
}

+(UIColor*)yhapp_16color{
    return UIColorHex(a984d3);
}

+(UIColor*)yhapp_17color{
    return UIColorHex(f44f4f);
}

+(UIColor*)yhapp_18color{
    return UIColorHex(72b54d);
}

+(UIColor*)yhapp_clearcolor{
    return [UIColor clearColor];
}
@end
