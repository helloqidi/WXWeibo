//
//  ThemeButton.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-16.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

- (id)initWithImage:(NSString *)imageName highlighted:(NSString *)highlightImageName
{
    self = [self init];
    if (self) {
        self.imageName=imageName;
        self.highlightImageName=highlightImageName;
    }
    return self;
}

- (id)initWithBackgroundImage:(NSString *)backgroundImageName highlighted:(NSString *)backgroundHighlightImageName
{
    self = [self init];
    if (self) {
        self.backgroundImageName=backgroundImageName;
        self.backgroundHighlightImageName=backgroundHighlightImageName;
    }
    return self;
}

- (id)init
{
    self=[super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)themeNotification:(NSNotification *)notify
{
    [self loadThemeImage];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)loadThemeImage
{
    ThemeManager *themeManager=[ThemeManager shareInstance];
    
    UIImage *image=[themeManager getThemeImage:self.imageName];
    UIImage *highlightImage=[themeManager getThemeImage:self.highlightImageName];
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:highlightImage forState:UIControlStateHighlighted];
    
    UIImage *backgroundImage=[themeManager getThemeImage:self.backgroundImageName];
    UIImage *backgroundHighlightImage=[themeManager getThemeImage:self.backgroundHighlightImageName];
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [self setBackgroundImage:backgroundHighlightImage forState:UIControlStateHighlighted];
}

#pragma mark - Setter
- (void)setImageName:(NSString *)imageName
{
    if (_imageName!=imageName) {
        [_imageName release];
        _imageName=[imageName copy];
    }
    [self loadThemeImage];
}

- (void)setHighlightImageName:(NSString *)highlightImageName
{
    if (_highlightImageName!=highlightImageName) {
        [_highlightImageName release];
        _highlightImageName=[highlightImageName copy];
    }
    [self loadThemeImage];

}

- (void)setBackgroundImageName:(NSString *)backgroundImageName
{
    if (_backgroundImageName!=backgroundImageName) {
        [_backgroundImageName release];
        _backgroundImageName=[backgroundImageName copy];
    }
    [self loadThemeImage];
}

- (void)setBackgroundHighlightImageName:(NSString *)backgroundHighlightImageName
{
    if (_backgroundHighlightImageName!=backgroundHighlightImageName) {
        [_backgroundHighlightImageName release];
        _backgroundHighlightImageName=[backgroundHighlightImageName copy];
    }
    [self loadThemeImage];

}
@end
