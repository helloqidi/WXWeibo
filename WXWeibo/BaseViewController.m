//
//  BaseViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    
    UILabel *titleLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0f];
    titleLabel.text=title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView=titleLabel;
}


@end
