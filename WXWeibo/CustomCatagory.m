//
//  CustomCatagory.m
//  WXMovie
//
//  Created by wei.chen on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomCatagory.h"

//5.0以下系统自定义UINavigationBar背景
@implementation UINavigationBar(setbackgroud)

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"navigationbar_background"];
    [image drawInRect:rect];
}

@end
