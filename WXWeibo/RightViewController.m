//
//  RightViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "RightViewController.h"
#import "SendViewController.h"
#import "BaseNavigationController.h"
#import "MainViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

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
    self.view.backgroundColor=[UIColor darkGrayColor];
    
    //按钮
    NSArray *buttonNames=[NSArray arrayWithObjects:@"newbar_icon_1.png",@"newbar_icon_2.png",@"newbar_icon_3.png",@"newbar_icon_4.png",@"newbar_icon_5.png", nil];
    
    for (int i=0; i<buttonNames.count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:[buttonNames objectAtIndex:i]] forState:UIControlStateNormal];
        
        button.frame=CGRectMake(ScreenWidth-40-10, 20+i*40, 40, 40);
        button.tag=i+1;
        [button addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

- (void)sendAction:(UIButton *)button
{
    if (button.tag==1) {
        //发微博
        SendViewController *sendCtrl=[[[SendViewController alloc] init] autorelease];
        BaseNavigationController *sendNav=[[[BaseNavigationController alloc] initWithRootViewController:sendCtrl] autorelease];
        //[self.appDelegate.ddMenuController presentViewController:sendNav animated:YES completion:NULL];
        [self.appDelegate.ddMenuController presentModalViewController:sendNav animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
