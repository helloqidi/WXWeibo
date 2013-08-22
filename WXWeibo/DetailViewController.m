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
    NSArray *comments=[result objectForKey:@"comments"];
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:comments.count];
    
    for (NSDictionary *commentDic in comments) {
        CommentModel *comment=[[[CommentModel alloc] initWithDataDic:commentDic] autorelease];
        [array addObject:comment];
    }
    
    self.tableView.data=array;
    
    //刷新
    [self.tableView reloadData];
}

#pragma mark -dealloc/memoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
