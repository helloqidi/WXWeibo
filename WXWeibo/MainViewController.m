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
    }
    self.viewControllers=viewControllers;
}

//初始化TabBar工具栏
- (void)_initTabBarView
{
    self.tabBarView=[[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49-20, 320, 49)] autorelease];
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
        btn.frame=CGRectMake(64/2-30/2+i*64, 49/2-30/2, 30, 30);
        btn.tag=i;
        //[btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        //[btn setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tabBarView addSubview:btn];
    }
    
}

#pragma mark - Action
//TabBar的切换Action
- (void)selectTab:(UIButton *)button
{
    self.selectedIndex=button.tag;
};



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


#pragma mark - dealloc/memoryWarning
- (void)dealloc
{
    self.tabBarView=nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
