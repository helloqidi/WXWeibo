//
//  HomeViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "HomeViewController.h"
#import "WeiboModel.h"
#import "WeiboCell.h"
#import "WeiboView.h"

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
    
    
    //talbeview
    //NSLog(@"----%@",NSStringFromCGRect(self.view.bounds));
    //NSLog(@"++++%@",NSStringFromCGRect(self.navigationController.navigationBar.bounds));
    self.tableView=[[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight-49-20-44) style:UITableViewStylePlain] autorelease];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    
    
}
#pragma mark - Load Data
- (void)loadWeiboData
{
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
}

#pragma mark -Sinaweibo Request Delegate
//加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"网络加载失败：%@",error);
}
//加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    //NSLog(@"%@",result);
    
    NSArray *statuses=[result objectForKey:@"statuses"];
    NSMutableArray *weibos=[NSMutableArray arrayWithCapacity:statuses.count];
    
    for (NSDictionary *statuesDic in statuses) {
        WeiboModel *weibo=[[[WeiboModel alloc] initWithDataDic:statuesDic] autorelease];
        [weibos addObject:weibo];
    }
    self.data=weibos;
    
    //刷新talbeView
    [self.tableView reloadData];
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //WeiboCell *cell=[[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    static NSString *identifier=@"WeiboCell";
    WeiboCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    WeiboModel *weibo=self.data[indexPath.row];
    //WeiboModel *weiboModel=[self.data objectAtIndex:indexPath.row];
    cell.weiboModel=weibo;
    
    return cell;
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //此方法中不能得到cell,如下语句会报错,形成死循环
    //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    WeiboModel *weibo=self.data[indexPath.row];
    float height=[WeiboView getWeiboViewHeight:weibo isRepost:NO isDetail:NO];
    //留出昵称、创建时间、来源的高度
    height += 50;
    
    return height;
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
    self.tableView=nil;
    self.data=nil;
    [_tableView release];
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
