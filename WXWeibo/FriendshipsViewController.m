//
//  FriendshipsViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-27.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "FriendshipsViewController.h"
#import "DataService.h"
#import "UserModel.h"

@interface FriendshipsViewController ()

@end

@implementation FriendshipsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView=[[[FriendShipsTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    [self.view addSubview:self.tableView];
    
    //初始化数组
    self.data=[NSMutableArray array];
    
    self.tableView.eventDelegate=self;
    
    [super showHUD:@"加载中" isDim:YES];
    
    if (self.shipType==Fans) {
        self.title=@"粉丝";
        
    }else{
        self.title=@"关注";
    }
    
    [self loadFriendshipData];
}

- (void)loadFriendshipData
{
    [super hideHUD];
    
    NSString *url=nil;
    if (self.shipType==Fans) {
        url=@"friendships/followers.json";
        
    }else{
        url=@"friendships/friends.json";
    }
    if (self.userId.length==0) {
        NSLog(@"用户id为空");
        return;
    }
    
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObject:self.userId forKey:@"uid"];
    
    //如果有下一页的游标，则传递。
    if (self.cursor.length>0) {
        [params setObject:self.cursor forKey:@"cursor"];
    }
    
    
    [DataService requestWithURL:url params:params httpMethod:@"GET" completeBlock:^(id result) {
        [self loadAtDataFinish:result];
    }];

}


- (void)loadAtDataFinish:(NSDictionary *)result
{
    //记录游标值
    self.cursor=[[result objectForKey:@"next_cursor"] stringValue];
    
    //用户数据
    NSArray *usersArray=[result objectForKey:@"users"];
    /*组合后的结构：
     *[
     * [用户1,用户2，用户3],
     * [用户1,用户2，用户3],
     * ......
     *]
     */
    
    NSMutableArray *array2D=nil;
    for (int i=0; i<usersArray.count; i++) {
        array2D=[self.data lastObject];
        
        //每次判断最后一个数组是否填满数据
        if (array2D.count==3 || array2D==nil) {
            array2D=[NSMutableArray arrayWithCapacity:3];
            [self.data addObject:array2D];
        }
        NSDictionary *userDic=[usersArray objectAtIndex:i];
        UserModel *userModel=[[[UserModel alloc] initWithDataDic:userDic] autorelease];
        [array2D addObject:userModel];
    }
    
    //刷新UI
    //此处虽然请求的是50，但是新浪接口经常返回的不足50
    if (usersArray.count<47) {
        self.tableView.isMore=NO;
    }else{
        self.tableView.isMore=YES;
    }
    
    self.tableView.data=self.data;
    [self.tableView reloadData];
    
    //收回下拉
    if (self.cursor==nil) {
        [self.tableView doneLoadingTableViewData];
    }
    
}


#pragma mark -UITableView EventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView
{
    //此时下拉的功能是：重新显示第一页，且只显示第一页。

    self.cursor=nil;
    [self.data removeAllObjects];
    
    [self loadFriendshipData];
}

//上拉
- (void)pullUp:(BaseTableView *)tableView
{
    [self loadFriendshipData];
}


#pragma mark - dealloc
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
