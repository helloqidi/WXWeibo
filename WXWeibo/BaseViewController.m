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
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo=appDelegate.sinaweibo;
    return sinaweibo;
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


@end
