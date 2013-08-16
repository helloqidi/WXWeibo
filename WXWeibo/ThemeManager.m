//
//  ThemeManager.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "ThemeManager.h"


static ThemeManager *singleton=nil;

@implementation ThemeManager

+ (ThemeManager *)shareInstance
{
    if(singleton==nil){
        @synchronized(self){
            singleton=[[ThemeManager alloc] init];
    
        }
    }
    return singleton;
}

- (id)init
{
    self=[super init];
    if (self) {
        NSString *themePath=[[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        self.themesPlist=[NSDictionary dictionaryWithContentsOfFile:themePath];
        
        //默认为空
        self.themeName=nil;
    }
    return self;
}

//切换主题时会调用此方法，设置主题名称
- (void)setThemeName:(NSString *)themeName
{
    if (_themeName!=themeName) {
        [_themeName release];
        _themeName=[themeName copy];
    }
    NSString *themeDir=[self getThemePath];
    NSString *filePath=[themeDir stringByAppendingPathComponent:@"fontColor.plist"];
    self.fontColorPlist=[NSDictionary dictionaryWithContentsOfFile:filePath];
}

//获取主题目录
- (NSString *)getThemePath
{
    if(self.themeName==nil){
        NSString *resourcePath=[[NSBundle mainBundle] resourcePath];
        return resourcePath;
    }
    //获得主题路径
    NSString *themePath=[self.themesPlist objectForKey:self.themeName];
    //获得包的根路径
    NSString *resourcePath=[[NSBundle mainBundle] resourcePath];
    NSString *path=[resourcePath stringByAppendingPathComponent:themePath];
    return path;
}

- (UIImage *)getThemeImage:(NSString *)imageName
{
    if(imageName.length==0){
        return nil;
    }
    NSString *themePath=[self getThemePath];
    NSString *imagePath=[themePath stringByAppendingPathComponent:imageName];
    UIImage *image=[UIImage imageWithContentsOfFile:imagePath];
    return image;
}

- (UIColor *)getColorWithName:(NSString *)name
{
    if (name.length==0) {
        return nil;
    }
    //返回三色值，如：24，25，60
    NSString *rgb=[self.fontColorPlist objectForKey:name];
    NSArray *rgbs=[rgb componentsSeparatedByString:@","];
    if (rgbs.count==3) {
        float r=[rgbs[0] floatValue];
        float g=[rgbs[1] floatValue];
        float b=[rgbs[2] floatValue];
        UIColor *color=Color(r, g, b, 1);
        return color;
    }
    return nil;
}


//限制当前对象创建多实例
#pragma mark - sengleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (singleton == nil) {
            singleton = [super allocWithZone:zone];
        }
    }
    return singleton;
}

+ (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;
}

- (oneway void)release {
}

- (id)autorelease {
    return self;
}

@end
