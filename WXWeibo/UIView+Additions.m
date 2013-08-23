//
//  UIView+Additions.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-23.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)


- (UIViewController *)viewController
{
    //下一个响应者
    UIResponder *next=self.nextResponder;
    //循环查找viewController
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next=next.nextResponder;
    } while (next!=nil);
    
    return nil;
}

@end
