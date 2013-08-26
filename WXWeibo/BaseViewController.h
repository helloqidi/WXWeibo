//
//  BaseViewController.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"


@interface BaseViewController : UIViewController

//是否显示返回按钮
@property(nonatomic,assign)BOOL isBackButton;
//用于装载“加载中”的视图
@property(nonatomic,retain)UIView *loadingView;

@property(nonatomic,retain)MBProgressHUD *hud;


- (SinaWeibo *) sinaweibo;
- (AppDelegate *)appDelegate;


//网络加载提示
- (void)showLoading:(BOOL)show;
//HUD控件
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim;
//隐藏HUD
- (void)hideHUD;
//HUD提示完成
- (void)showHUDComplete:(NSString *)title;

@end
