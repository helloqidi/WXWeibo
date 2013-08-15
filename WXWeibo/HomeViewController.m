//
//  HomeViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"微博";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //绑定按钮
    UIBarButtonItem *bindItem=[[[UIBarButtonItem alloc] initWithTitle:@"绑定账号" style:UIBarButtonItemStyleBordered target:self action:@selector(bindAction:)] autorelease];
    //注销按钮
    UIBarButtonItem *logoutItem=[[[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction:)] autorelease];
    
    self.navigationItem.rightBarButtonItem=bindItem;
    self.navigationItem.leftBarButtonItem=logoutItem;
    
    if (self.sinaweibo.isAuthValid) {
        [self loadWeiboData];
    }
    
    
}
#pragma mark - Load Data
- (void)loadWeiboData
{
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObject:@"5" forKey:@"count"];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
}

#pragma mark -Sinaweibo Request Delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"网络加载失败：%@",error);
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",result);
}


#pragma mark - Action
- (void)bindAction:(UIBarButtonItem *)btnItem
{
    [self.sinaweibo logIn];
}

- (void)logoutAction:(UIBarButtonItem *)logoutItem
{
    [self.sinaweibo logOut];
}

#pragma mark - dealloc/memoryWarning
- (void)dealloc
{
    [super dealloc];
}

//6.0以下版本
- (void)viewDidUnload
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
