//
//  BaseViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "UIFactory.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackButton=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSArray *viewControllers=self.navigationController.viewControllers;
    if (viewControllers.count>1 && self.isBackButton) {
        UIButton *btn=[UIFactory createButton:@"navigationbar_back.png" highlighted:@"navigationbar_back_highlighted.png"];
        btn.frame=CGRectMake(0, 0, 24, 24);
        [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
        self.navigationItem.leftBarButtonItem=backItem;
    }
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (SinaWeibo *) sinaweibo
{
    AppDelegate *appDelegate=self.appDelegate;
    SinaWeibo *sinaweibo=appDelegate.sinaweibo;
    return sinaweibo;
}

- (AppDelegate *)appDelegate
{
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    return appDelegate;
}

//覆写setTitle方法 override

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    //导航栏中的x，y坐标会自己调整，不需要指定
    //UILabel *titleLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    UILabel *titleLabel=[UIFactory createLabel:kNavigationBarTitleLabel];
    //titleLabel.textColor=[UIColor blackColor];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0f];
    titleLabel.text=title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView=titleLabel;
}

#pragma mark - loading
- (void)showLoading:(BOOL)show
{
    if (self.loadingView==nil) {
        self.loadingView=[[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2-40, ScreenWidth, 20)] autorelease];
        
        //风火轮视图
        UIActivityIndicatorView *activityView=[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        [activityView startAnimating];
        
        //label
        UILabel *loadLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        loadLabel.backgroundColor=[UIColor clearColor];
        loadLabel.text=@"正在加载......";
        loadLabel.font=[UIFont boldSystemFontOfSize:16.0f];
        loadLabel.textColor=[UIColor blackColor];
        [loadLabel sizeToFit];
        
        loadLabel.left=(ScreenWidth-loadLabel.width)/2;
        activityView.right=loadLabel.left-5;
        
        [self.loadingView addSubview:loadLabel];
        [self.loadingView addSubview:activityView];
    }
    if (show) {
        //NSLog(@"----%@",[self.loadingView superview]);
        if (![self.loadingView superview]) {
            [self.view addSubview:self.loadingView];
        }
    }else{
        [self.loadingView removeFromSuperview];
    }
}


- (void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
    self.hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (isDim) {
        //黑色背景遮罩
        self.hud.dimBackground=YES;
    }
    if (title.length>0) {
        self.hud.labelText=title;
    }
}

- (void)hideHUD{
    [self.hud hide:YES];
}

- (void)showHUDComplete:(NSString *)title
{
    self.hud.customView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease] ;
    self.hud.mode=MBProgressHUDModeCustomView;
    if (title.length>0) {
        self.hud.labelText=title;
    }
    //2秒后隐藏
    [self.hud hide:YES afterDelay:2];
}

@end
