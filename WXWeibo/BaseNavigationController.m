//
//  BaseNavigationController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadThemeImage];
}



- (void)themeNotification
{
    [self loadThemeImage];
}

- (void)loadThemeImage
{
    float version=WXHLOSVersion();
    if(version>=5.0){
        UIImage *backgroundImage=[[ThemeManager shareInstance] getThemeImage:@"navigationbar_background.png"];
        [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }else{
        //调用setNeedsDisplay方法会让渲染引擎异步调用drawRect方法。
        //不能直接调drawRect方法，它是系统异步调用的。
        [self.navigationBar setNeedsDisplay];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
