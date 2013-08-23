//
//  UserViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-23.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoView.h"

@interface UserViewController ()

@end

@implementation UserViewController

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
	
    [self _initView];
}

- (void)_initView
{
    self.tableView=[[[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44) style:UITableViewStylePlain] autorelease];
    [self.view addSubview:self.tableView];
    
    UserInfoView *userInfoView=[[[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)] autorelease];
    self.tableView.tableHeaderView=userInfoView;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
