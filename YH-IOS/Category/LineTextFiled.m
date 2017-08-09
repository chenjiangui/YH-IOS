//
//  UITextView+placeLine.m
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/8/9.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "LineTextFiled.h"

@implementation LineTextFiled

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    CGRect originalRect = [super caretRectForPosition:position];
    
    originalRect.origin.y = self.font.lineHeight-4;
    originalRect.size.height = 2;
    originalRect.size.width = 12;
    
    return originalRect;
}

@end
