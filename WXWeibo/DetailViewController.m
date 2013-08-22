//
//  DetailViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-21.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CommentModel.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

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
    
    self.tableView=[[[CommentTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44) style:UITableViewStylePlain] autorelease];
    //self.tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //NSLog(@"=====%f",self.tableView.height);
    //self.tableView.dataSource=self;
    //self.tableView.delegate=self;
    self.tableView.eventDelegate=self;
    //self.tableView.refreshHeader=NO;

    [self.view addSubview:self.tableView];
    
    [self _initView];
    
    [self loadData];
    
}


- (void)_initView
{
    UIView *tableHeaderView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)] autorelease];
    tableHeaderView.backgroundColor=[UIColor clearColor];
    
    
    //用户栏视图
    UIView *userBarView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)] autorelease];
    userBarView.backgroundColor=[UIColor clearColor];
    [tableHeaderView addSubview:userBarView];
    
    
    //用户头像
    UIImageView *userImageView=[[[UIImageView alloc] initWithFrame:CGRectMake(10, (60-40)/2, 40, 40)] autorelease];
    userImageView.backgroundColor=[UIColor clearColor];
    //圆角
    userImageView.layer.cornerRadius=5;
    //裁剪掉超出部分
    userImageView.layer.masksToBounds=YES;
    //加载网络图片
    [userImageView setImageWithURL:[NSURL URLWithString:self.weiboModel.user.profile_image_url]];
    [userBarView addSubview:userImageView];
    
    //昵称
    UILabel *nickLabel=[[[UILabel alloc] initWithFrame:CGRectMake(userImageView.right+10, (60-20)/2, 200, 20)] autorelease];
    nickLabel.font=[UIFont systemFontOfSize:17.0f];
    nickLabel.text=self.weiboModel.user.name;
    [nickLabel sizeToFit];
    [userBarView addSubview:nickLabel];
    
    //小图标
    UIImageView *iconImage=[[[UIImageView alloc] initWithFrame:CGRectMake(userBarView.width-20, (64-13)/2, 8, 13)] autorelease];
    iconImage.image=[UIImage imageNamed:@"icon_detail.png"];
    [userBarView addSubview:iconImage];
   
    //间隔横线
    UIImageView *separatorImage=[[[UIImageView alloc] initWithFrame:CGRectMake(0, 60-1, ScreenWidth, 1)] autorelease];
    separatorImage.image=[UIImage imageNamed:@"userinfo_header_separator.png"];
    [userBarView addSubview:separatorImage];

    
    //----创建微博视图----
    float h=[WeiboView getWeiboViewHeight:self.weiboModel isRepost:NO isDetail:YES];
    self.weiboView=[[WeiboView alloc] initWithFrame:CGRectMake(10, userBarView.bottom+10,ScreenWidth-20, h)];
    self.weiboView.isDetail=YES;
    self.weiboView.weiboModel=self.weiboModel;
    [tableHeaderView addSubview:self.weiboView];
    
    tableHeaderView.height+=userBarView.height+h+10;
    self.tableView.tableHeaderView=tableHeaderView;
    
}

- (void)loadData
{
    NSString *weiboId=[self.weiboModel.weiboId stringValue];
    if (weiboId.length==0) {
        return;
    }
    
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObject:weiboId forKey:@"id"];
    
    [self.sinaweibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" block:^(NSDictionary *result) {
        [self loadDataFinish:result];
    }];

}

- (void)loadDataFinish:(NSDictionary *)result
{
    NSArray *commentList=[result objectForKey:@"comments"];
    NSMutableArray *comments=[NSMutableArray arrayWithCapacity:commentList.count];
    
    for (NSDictionary *commentDic in commentList) {
        CommentModel *comment=[[[CommentModel alloc] initWithDataDic:commentDic] autorelease];
        [comments addObject:comment];
    }
    
    if (commentList.count>=20) {
        self.tableView.isMore=YES;
    }else{
        self.tableView.isMore=NO;
    }
    
    if (commentList.count>0) {
        CommentModel *lastComment=[comments lastObject];
        self.lastCommentId=[lastComment.id stringValue];
    }
    
    self.tableView.data=comments;
    self.comments=comments;
    
    //将字典传过去，可用于获得评论总数量等信息
    self.tableView.commentDic=result;
    
    //刷新
    [self.tableView reloadData];
}



//上拉请求数据
- (void)pullUpData
{
    if (self.lastCommentId.length==0) {
        NSLog(@"评论id为空");
        return;
    }
    
    NSString *weiboId=[self.weiboModel.weiboId stringValue];
    if (weiboId.length==0) {
        return;
    }
    
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",weiboId,@"id",self.lastCommentId,@"max_id",nil];
    [self.sinaweibo requestWithURL:@"comments/show.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result){
                                 [self pullUpDataFinish:result];
                             }];
    
}

- (void)pullUpDataFinish:(id)result
{
    NSArray *commentList=[result objectForKey:@"comments"];
    NSMutableArray *comments=[NSMutableArray arrayWithCapacity:commentList.count];
    
    for (NSDictionary *commentDic in commentList) {
        CommentModel *comment=[[[CommentModel alloc] initWithDataDic:commentDic] autorelease];
        [comments addObject:comment];
    }
    
    if (commentList.count>=20) {
        self.tableView.isMore=YES;
    }else{
        self.tableView.isMore=NO;
    }
    
    if (commentList.count>0) {
        CommentModel *lastComment=[comments lastObject];
        self.lastCommentId=[lastComment.id stringValue];
    }
    
    //追加数组
    [self.comments addObjectsFromArray:comments];
    self.tableView.data=self.comments;
    

    //刷新
    [self.tableView reloadData];
}

#pragma mark - BaseTablViewEventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView
{
    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2];
}

//上拉
- (void)pullUp:(BaseTableView *)tableView
{
    [self pullUpData];
}

//选中
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark -dealloc/memoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
