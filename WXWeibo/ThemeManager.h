//
//  ThemeManager.h
//  WXWeibo

//  主题管理类

//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kThemeDidChangeNotification @"kThemeDidChangeNotification"

@interface ThemeManager : NSObject

//主题名称
@property(nonatomic,retain)NSString *themeName;
@property(nonatomic,retain)NSDictionary *themesPlist;


+ (ThemeManager *)shareInstance;

//返回当前主题下的图片
- (UIImage *)getThemeImage:(NSString *)imageName;
@end
