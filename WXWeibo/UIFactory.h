//
//  UIFactory.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-16.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"

@interface UIFactory : NSObject

+ (ThemeButton *)createButton:(NSString *)imageName
                  highlighted:(NSString *)highlightedName;

+ (ThemeButton *)createButtonWithBackground:(NSString *)backgroundImageName
                      backgroundHighlighted:(NSString *)backgroundHighlightedName;

+ (ThemeImageView *)createImageView:(NSString *)imageName;

+ (ThemeLabel *)createLabel:(NSString *)colorName;

//创建导航栏的按钮
+ (UIButton *)createNavigationButton:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;

@end
