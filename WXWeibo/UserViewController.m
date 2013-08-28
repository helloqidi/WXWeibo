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
#import "WeiboModel.h"

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
    self.requests=[[[NSMutableArray alloc] init] autorelease];
	
    self.title=@"个人资料";
    
    if (self.showLoginUser) {
        //读取当前用户的信息
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        NSString *userId=[sinaweiboInfo objectForKey:@"UserIDKey"];
        self.userId=userId;
    }

    [self _initView];
    
    [self loadUserData];
    [self loadWeiboData];
}

- (void)_initView
{
    self.tableView=[[[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44) style:UITableViewStylePlain] autorelease];
    [self.view addSubview:self.tableView];
    self.tableView.eventDelegate=self;
    
    self.userInfo=[[[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)] autorelease];
    //必须声明高度
    self.userInfo.height=200;
    self.tableView.tableHeaderView=self.userInfo;
    
    //导航栏右侧按钮
    UIButton *homeButton = [UIFactory createButtonWithBackground:@"tabbar_home.png" backgroundHighlighted:@"tabbar_home_highlighted.png"];
    homeButton.frame = CGRectMake(0, 0, 34, 27);
    [homeButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem = [homeItem autorelease];
    
}


//取消网络请求
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (SinaWeiboRequest *request in self.requests) {
        [request disconnect];
    }
}

#pragma mark - Data
//获得用户资料信息
- (void)loadUserData
{
    if (self.userName.length==0 && self.userId.length==0) {
        NSLog(@"用户名和id都为空");
        return;
    }
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    if (self.userId.length!=0) {
        params=[NSMutableDictionary dictionaryWithObject:self.userId forKey:@"uid"];
    }else{
        params=[NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    }

    SinaWeiboRequest *request=[self.sinaweibo requestWithURL:@"users/show.json" params:params httpMethod:@"GET" block:^(id result) {
        [self loadUserDataFinish:result];
    }];
    [self.requests addObject:request];
    
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

//加载用户的微博
- (void)loadWeiboData
{
    
    if (self.userName.length==0 && self.userId.length==0) {
        NSLog(@"用户名和id都为空");
        return;
    }
    
    //注：这个接口，新浪微博改变为：只有授权的才能读取，所以，在这不能读取所有用户的微博了。
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    if (self.userId.length!=0) {
        params=[NSMutableDictionary dictionaryWithObject:self.userId forKey:@"uid"];
    }else{
        params=[NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    }
    SinaWeiboRequest *request=[self.sinaweibo requestWithURL:@"statuses/user_timeline.json" params:params httpMethod:@"GET" block:^(id result) {
        [self loadWeiboDataFinish:result];
    }];
    [self.requests addObject:request];
}

- (void)loadWeiboDataFinish:(NSDictionary *)result
{
    NSArray *statuses=[result objectForKey:@"statuses"];
    NSMutableArray *weibos=[NSMutableArray arrayWithCapacity:statuses.count];
    for (NSDictionary *weibo in statuses) {
        WeiboModel *weiboModel=[[[WeiboModel alloc] initWithDataDic:weibo] autorelease];
        [weibos addObject:weiboModel];
    }
    
    self.tableView.data=weibos;
    if (weibos.count>=20) {
        self.tableView.isMore=YES;
    }else{
        self.tableView.isMore=NO;
    }
    [self.tableView reloadData];
    
}

#pragma mark - EventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView
{
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2];
}

//上拉
- (void)pullUp:(BaseTableView *)tableView
{
    //[self performSelector:@selector(reloadData) withObject:nil afterDelay:2];
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
