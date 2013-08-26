//
//  AppDelegate.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "DDMenuController.h"
//#import "MainViewController.h"
@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic)UIWindow *window;
@property(nonatomic,retain)SinaWeibo *sinaweibo;
@property(nonatomic,retain)MainViewController *mainViewController;
@property(nonatomic,retain)DDMenuController *ddMenuController;

@end
