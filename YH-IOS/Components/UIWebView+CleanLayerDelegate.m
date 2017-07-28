//
//  UIWebView+CleanLayerDelegate.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/7/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "UIWebView+CleanLayerDelegate.h"
#import <objc/runtime.h>

@implementation UIWebView (CleanLayerDelegate)


+ (void)load{
    //  "v@:"
    Class class = NSClassFromString(@"WebActionDisablingCALayerDelegate");
    class_addMethod(class, @selector(setBeingRemoved), setBeingRemoved, "v@:");
    class_addMethod(class, @selector(willBeRemoved), willBeRemoved, "v@:");
    
    class_addMethod(class, @selector(removeFromSuperview), willBeRemoved, "v@:");
}

id setBeingRemoved(id self, SEL selector, ...)
{
    return nil;
}

id willBeRemoved(id self, SEL selector, ...)
{
    return nil;
}


@end
