//
//  UserViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-23.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoView.h"
#import "UIFactory.h"

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
	
    self.title=@"个人资料";
    
    [self _initView];
    
    [self loadUserData];
}

- (void)_initView
{
    self.tableView=[[[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44) style:UITableViewStylePlain] autorelease];
    [self.view addSubview:self.tableView];
    
    self.userInfo=[[[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)] autorelease];
    self.tableView.tableHeaderView=self.userInfo;
    
    //导航栏右侧按钮
    UIButton *homeButton = [UIFactory createButtonWithBackground:@"tabbar_home.png" backgroundHighlighted:@"tabbar_home_highlighted.png"];
    homeButton.frame = CGRectMake(0, 0, 34, 27);
    [homeButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem = [homeItem autorelease];
    
}

#pragma mark - Data
- (void)loadUserData
{
    if (self.userName.length==0) {
        NSLog(@"用户名空");
        return;
    }
    
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    [self.sinaweibo requestWithURL:@"users/show.json" params:params httpMethod:@"GET" block:^(id result) {
        [self loadUserDataFinish:result];
    }];
    
}


- (void)loadUserDataFinish:(NSDictionary *)result
{
    UserModel *userModel=[[UserModel alloc] initWithDataDic:result];
    self.userInfo.userModel=userModel;
    //注：此处传递userModel给UserInfoView后，UserInfoView并没有执行layoutSubviews.
    //两种解决方式：
    //1，把addSubview移动到获得数据之后
    //self.tableView.tableHeaderView=self.userInfo;
    //2，重新刷新UserInfoView
    [self.userInfo setNeedsLayout];
}


#pragma mark - Action
//返回首页
- (void)goHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
