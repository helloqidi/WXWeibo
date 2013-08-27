//
//  AppDelegate.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DDMenuController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "ThemeManager.h"

@implementation AppDelegate



- (void)_initSinaWeibo
{
    self.sinaweibo = [[[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self.mainViewController] autorelease];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        self.sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        self.sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        self.sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //状态栏的背景色不随导航的背景色改变,固定为不透明黑色
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleBlackOpaque;
    
    //读取主题
    [self setTheme];
    
    //主控制器不能销毁，不用autorelease
    self.mainViewController=[[MainViewController alloc] init];
    LeftViewController *leftViewController=[[LeftViewController alloc] init];
    RightViewController *rightViewController=[[RightViewController alloc] init];
    
    self.ddMenuController=[[[DDMenuController alloc] initWithRootViewController:self.mainViewController] autorelease];
    self.ddMenuController.leftViewController=leftViewController;
    self.ddMenuController.rightViewController=rightViewController;
    
    [self _initSinaWeibo];
    
    self.window.rootViewController=self.ddMenuController;
    return YES;
}

- (void)setTheme
{
    NSString *themeName=[[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
    [ThemeManager shareInstance].themeName=themeName;
}


- (void)dealloc
{
    [_window release];
    self.sinaweibo=nil;
    self.mainViewController=nil;
    self.ddMenuController=nil;
    [super dealloc];
}
@end
