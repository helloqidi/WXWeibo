//
//  HomeViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "HomeViewController.h"
#import "WeiboModel.h"
#import "UIFactory.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "MainViewController.h"
#import "DetailViewController.h"

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
    
    //talbeview
    //NSLog(@"----%@",NSStringFromCGRect(self.view.bounds));
    //NSLog(@"++++%@",NSStringFromCGRect(self.navigationController.navigationBar.bounds));
    self.tableView=[[[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-20-44) style:UITableViewStylePlain] autorelease];
    //self.tableView.dataSource=self;
    //self.tableView.delegate=self;
    
    self.tableView.eventDelegate=self;
    //默认隐藏，有数据时再显示
    self.tableView.hidden=YES;
    [self.view addSubview:self.tableView];
  
    //判断是否认证
    if (self.sinaweibo.isAuthValid) {
        //加载数据
        [self loadWeiboData];
    }
    
}

#pragma mark - UI
//显示新微博的数量
- (void)showNewWeiboCount:(int)count
{
    if (self.barView==nil) {
        self.barView=[UIFactory createImageView:@"timeline_new_status_background.png"];
        //拉伸图片
        UIImage *image=[self.barView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        self.barView.image=image;
        self.barView.leftCapWidth=5;
        self.barView.topCapHeight=5;
        self.barView.frame=CGRectMake(5, -40, ScreenWidth-10, 40);
        [self.view addSubview:self.barView];
        
        UILabel *label=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.tag=2013;
        label.font=[UIFont systemFontOfSize:16.0f];
        label.textColor=[UIColor whiteColor];
        label.backgroundColor=[UIColor clearColor];
        [self.barView addSubview:label];
    }
    
    if (count>0) {
        UILabel *label=(UILabel *)[self.barView viewWithTag:2013];
        label.text=[NSString stringWithFormat:@"%d条新微博",count];
        [label sizeToFit];
        label.origin=CGPointMake((self.barView.width-label.width)/2, (self.barView.height-label.height)/2);
        //动画效果
        [UIView animateWithDuration:0.6 animations:^{
            self.barView.top=5;
        } completion:^(BOOL finished){
            if (finished) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:1];
                [UIView setAnimationDuration:0.6];
                self.barView.top=-40;
                [UIView commitAnimations];
            }
        }];
        
        //播放提示声音
        NSString *filePath=[[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url=[NSURL fileURLWithPath:filePath];
        
        //声明系统声音id
        SystemSoundID soundId;
        //注册系统声音
        AudioServicesCreateSystemSoundID((CFURLRef) url, &soundId);
        //播放声音
        AudioServicesPlaySystemSound(soundId);
    }
    
    //清除TabBar中的未读数量
    //或者通过AppDelegate获得MainViewController
    MainViewController *mainCtrl=(MainViewController *)self.tabBarController;
    [mainCtrl showBadge:NO];
    

}


#pragma mark - BaseTablViewEventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView
{
    //[tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3];
    [self pullDownData];
}

//上拉
- (void)pullUp:(BaseTableView *)tableView
{
    [self pullUpData];
}

//选中
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboModel *weibo=[self.weibos objectAtIndex:indexPath.row];
    DetailViewController *detail=[[[DetailViewController alloc] init] autorelease];
    detail.weiboModel=weibo;
    [self.navigationController pushViewController:detail animated:YES];
    
}


#pragma mark - Load Data
//默认加载微博
- (void)loadWeiboData
{
    
    //显示正在加载
    //[super showLoading:YES];
    [super showHUD:@"正在加载..." isDim:NO];
    
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
}

//下拉请求数据
- (void)pullDownData
{
    if (self.topWeiboId.length==0) {
        NSLog(@"微博id为空");
        //弹回
        //直接调用doneLoadingTableViewData不起作用，需要延迟1秒以上
        //[self.tableView doneLoadingTableViewData];
        [self.tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
        return;
    }
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",self.topWeiboId,@"since_id",nil];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result){
                                 [self pullDownDataFinish:result];
                             }];
}

//上拉请求数据
- (void)pullUpData
{
    if (self.lastWeiboId.length==0) {
        NSLog(@"微博id为空");
        return;
    }
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",self.lastWeiboId,@"max_id",nil];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result){
                                 [self pullUpDataFinish:result];
                             }];

}

//下拉加载完成
- (void)pullDownDataFinish:(id)result
{
    NSArray *statuses=[result objectForKey:@"statuses"];
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:statuses.count];
    
    for (NSDictionary *statuesDic in statuses) {
        WeiboModel *weibo=[[[WeiboModel alloc] initWithDataDic:statuesDic] autorelease];
        [array addObject:weibo];
    }
    
    //更新最大id
    if (array.count>0) {
        WeiboModel *weibo=[array objectAtIndex:0];
        self.topWeiboId=[weibo.weiboId stringValue];
    }
    
    //追加数组
    [array addObjectsFromArray:self.weibos];
    self.weibos=array;
    self.tableView.data=array;
    
    //刷新
    [self.tableView reloadData];

    //弹回
    [self.tableView doneLoadingTableViewData];
    
    //显示刷新了多少条微博
    //NSLog(@"更新条数：%d",[statuses count]);
    [self showNewWeiboCount:[statuses count]];
}

//上拉加载完成
- (void)pullUpDataFinish:(id)result
{
    NSArray *statuses=[result objectForKey:@"statuses"];
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:statuses.count];
    
    for (NSDictionary *statuesDic in statuses) {
        WeiboModel *weibo=[[[WeiboModel alloc] initWithDataDic:statuesDic] autorelease];
        [array addObject:weibo];
    }
    
    //更新最后一个id
    if (array.count>0) {
        WeiboModel *weibo=[array lastObject];
        self.lastWeiboId=[weibo.weiboId stringValue];
    }
    
    //追加数组
    [self.weibos addObjectsFromArray:array];
    self.tableView.data=self.weibos;
    
    //刷新
    [self.tableView reloadData];

}

- (void)autorefreshWeibo
{
    //下拉
    [self.tableView autoRefreshData];
    
     //取数据
     [self pullDownData];
}

#pragma mark -Sinaweibo Request Delegate
//加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"网络加载失败：%@",error);
}
//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    //隐藏正在加载
    //[super showLoading:NO];
    [super hideHUD];
    [super showHUDComplete:@"加载完成"];
    self.tableView.hidden=NO;
    
    NSArray *statuses=[result objectForKey:@"statuses"];
    NSMutableArray *weibos=[NSMutableArray arrayWithCapacity:statuses.count];
    
    for (NSDictionary *statuesDic in statuses) {
        WeiboModel *weibo=[[[WeiboModel alloc] initWithDataDic:statuesDic] autorelease];
        [weibos addObject:weibo];
    }
    self.tableView.data=weibos;
    self.weibos=weibos;
    
    //获得最大id
    if (weibos.count>0) {
        WeiboModel *topWeibo=[weibos objectAtIndex:0];
        //NSNumber转换为字符串
        self.topWeiboId=[topWeibo.weiboId stringValue];
        
        WeiboModel *lastWeibo=[weibos lastObject];
        self.lastWeiboId=[lastWeibo.weiboId stringValue];
    }
    
    
    //刷新talbeView
    [self.tableView reloadData];
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
    self.topWeiboId=nil;
    self.weibos=nil;
    self.barView=nil;
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
