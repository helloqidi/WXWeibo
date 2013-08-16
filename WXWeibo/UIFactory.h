//
//  UIFactory.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-16.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeButton.h"

@interface UIFactory : NSObject

+ (ThemeButton *)createButton:(NSString *)imageName
                  highlighted:(NSString *)highlightedName;

+ (ThemeButton *)createButtonWithBackground:(NSString *)backgroundImageName
                      backgroundHighlighted:(NSString *)backgroundHighlightedName;


@end
