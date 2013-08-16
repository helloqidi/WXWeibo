//
//  UIFactory.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-16.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory


+ (ThemeButton *)createButton:(NSString *)imageName
                  highlighted:(NSString *)highlightedName
{
    ThemeButton *btn=[[[ThemeButton alloc] initWithImage:imageName highlighted:highlightedName] autorelease];
    return btn;
}

+ (ThemeButton *)createButtonWithBackground:(NSString *)backgroundImageName
                      backgroundHighlighted:(NSString *)backgroundHighlightedName
{
    ThemeButton *btn=[[[ThemeButton alloc] initWithBackgroundImage:backgroundHighlightedName highlighted:backgroundHighlightedName] autorelease];
    return btn;
}


@end
