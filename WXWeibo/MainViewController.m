//
//  MainViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "UIFactory.h"
#import "AppDelegate.h"
//#import "ThemeButton.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //隐藏TabBar自带工具栏
        self.tabBar.hidden=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self _initViewController];
    [self _initTabBarView];
    
    //定时查询未读信息数
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}


//是否显示badge
- (void)showBadge:(BOOL)show
{
    self.badgeView.hidden=!show;
}
- (void)showTabbar:(BOOL)show
{
    [UIView animateWithDuration:0.35 animations:^{
        if (show) {
            self.tabBarView.left= 0;
        }else{
            self.tabBarView.left= -ScreenWidth;
        }
    }];
    
    [self _resizeView:show];
}


#pragma mark - UI

//调整子视图高度
- (void)_resizeView:(BOOL)showTabbar
{
    for (UIView *subview in self.view.subviews) {
        
        if ([subview isKindOfClass:NSClassFromString(@"UITransitionView")]) {
            if (showTabbar) {
                subview.height=ScreenHeight-49-20;
            }else{
                subview.height=ScreenHeight-20;
            }
        }
    }
}


//初始化子控制器
- (void)_initViewController
{
    HomeViewController *home=[[[HomeViewController alloc] init] autorelease];
    MessageViewController *message=[[[MessageViewController alloc] init] autorelease];
    ProfileViewController *profile=[[[ProfileViewController alloc] init] autorelease];
    DiscoverViewController *discover=[[[DiscoverViewController alloc] init] autorelease];
    MoreViewController *more=[[[MoreViewController alloc] init] autorelease];
    
    NSArray *views=@[home,message,profile,discover,more];
    NSMutableArray *viewControllers=[NSMutableArray arrayWithCapacity:5];
    
    for (UIViewController *viewController in views) {
        BaseNavigationController *nav=[[[BaseNavigationController alloc] initWithRootViewController:viewController] autorelease];
        [viewControllers addObject:nav];
        nav.delegate=self;
    }
    self.viewControllers=viewControllers;
}

//初始化TabBar工具栏
- (void)_initTabBarView
{
    self.tabBarView=[[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49-20, ScreenWidth, 49)] autorelease];
    //self.tabBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    [self.view addSubview:self.tabBarView];
    
    UIImageView *tabbarGroundImage=[UIFactory createImageView:@"tabbar_background.png"];
    tabbarGroundImage.frame=self.tabBarView.bounds;
    [self.tabBarView addSubview:tabbarGroundImage];
    
    NSArray *background=@[@"tabbar_home.png",@"tabbar_message_center.png",@"tabbar_profile.png",@"tabbar_discover.png",@"tabbar_more.png"];
    NSArray *Highlightbackground=@[@"tabbar_home_highlighted.png",@"tabbar_message_center_highlighted.png",@"tabbar_profile_highlighted.png",@"tabbar_discover_highlighted.png",@"tabbar_more_highlighted.png"];
    
    
    for (int i=0; i<5; i++) {
        NSString *imageName=background[i];
        NSString *highlightImageName=Highlightbackground[i];
        
        //UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        //ThemeButton *btn=[[[ThemeButton alloc] initWithImage:imageName highlighted:highlightImageName] autorelease];
        UIButton *btn=[UIFactory createButton:imageName highlighted:highlightImageName];
        //点击后的高亮效果
        btn.showsTouchWhenHighlighted=YES;
        btn.frame=CGRectMake((64-30)/2+i*64, 49/2-30/2, 30, 30);
        btn.tag=i;
        //[btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        //[btn setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tabBarView addSubview:btn];
    }
    
    self.sliderView=[UIFactory createImageView:@"tabbar_slider.png"];
    self.sliderView.backgroundColor=[UIColor clearColor];
    self.sliderView.frame=CGRectMake((64-15)/2, 5, 15, 44);
    [self.tabBarView addSubview:self.sliderView];
}

- (void)refreshUnReadView:(NSDictionary *)result
{
    NSNumber *status=[result objectForKey:@"status"];

    if (self.badgeView==nil) {
        self.badgeView=[UIFactory createImageView:@"main_badge.png"];
        self.badgeView.frame=CGRectMake(64-20, 5, 20, 20);
        [self.tabBarView addSubview:self.badgeView];
        
        UILabel *badgeLabel=[[[UILabel alloc] initWithFrame:self.badgeView.bounds] autorelease];
        //[badgeLabel sizeToFit];
        badgeLabel.textAlignment=NSTextAlignmentCenter;
        badgeLabel.font=[UIFont boldSystemFontOfSize:13.0f];
        badgeLabel.backgroundColor=[UIColor clearColor];
        badgeLabel.textColor=[UIColor purpleColor];
        badgeLabel.tag=100;
        [self.badgeView addSubview:badgeLabel];
    }
    
    int n=[status intValue];
    
    if (n>0) {
        UILabel *badgeLabel=(UILabel *)[self.badgeView viewWithTag:100];
        //最多只显示99
        if (n>99) {
            n=99;
        }
        badgeLabel.text=[NSString stringWithFormat:@"%d",n];
        self.badgeView.hidden=NO;
    }else{
        self.badgeView.hidden=YES;
    }
    
    
}


#pragma mark - data
- (void)loadUnReadData
{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo=appDelegate.sinaweibo;

    [sinaweibo requestWithURL:@"remind/unread_count.json" params:nil httpMethod:@"GET" block:^(NSDictionary *result) {
        [self refreshUnReadView:result];
    }];
}


#pragma mark - Action
//TabBar的切换Action
- (void)selectTab:(UIButton *)button
{
    float x=button.left+(button.width-self.sliderView.width)/2;
    //动画效果
    [UIView animateWithDuration:0.2 animations:^{
        self.sliderView.left=x;
    }];
    
    //判断是否是重复点击tab按钮
    if (button.tag==self.selectedIndex && button.tag==0) {
        
        //通过viewControllers获得HomeViewController
        //或者[self.home autorefreshWeibo];
        UINavigationController *homeNav=[self.viewControllers objectAtIndex:0];
        HomeViewController *homeCtrl=[homeNav.viewControllers objectAtIndex:0];
        
        [homeCtrl autorefreshWeibo];
        
    }
    
    self.selectedIndex=button.tag;
    
};

- (void)timerAction:(NSTimer *)timer
{
    [self loadUnReadData];
}

#pragma mark - SinaWeibo Delegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    //保存认证数据到本地
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    //删除本地的认证数据
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}


#pragma mark - UINavigationContoller Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //导航控制器的子控制器个数
    int count=navigationController.viewControllers.count;
    if (count==1) {
        [self showTabbar:YES];
    }else if (count==2){
        [self showTabbar:NO];
    }
    
}

#pragma mark - dealloc/memoryWarning
- (void)dealloc
{
    self.tabBarView=nil;
    self.sliderView=nil;
    self.badgeView=nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
