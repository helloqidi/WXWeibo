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


+ (ThemeImageView *)createImageView:(NSString *)imageName
{
    ThemeImageView *imageView=[[ThemeImageView alloc] initwithImageName:imageName];
    return imageView;
}

+ (ThemeLabel *)createLabel:(NSString *)colorName
{
    ThemeLabel *themeLabel=[[[ThemeLabel alloc] initWithColorName:colorName] autorelease];
    return themeLabel;
}


+ (UIButton *)createNavigationButton:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action
{
    ThemeButton *button=[self createButtonWithBackground:@"navigationbar_button_background.png" backgroundHighlighted:@"navigationbar_button_delete_background.png"];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    button.leftCapWidth=3;
    
    return button;
}

@end
