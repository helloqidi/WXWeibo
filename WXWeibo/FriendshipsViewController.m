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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"关注";
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView=[[[FriendShipsTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    [self.view addSubview:self.tableView];
    
    //初始化数组
    self.data=[NSMutableArray array];
    
    [self loadAtData];
    
}

//加载关注列表数据
- (void)loadAtData
{
    if (self.userId.length==0) {
        NSLog(@"用户id为空");
        return;
    }
    
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObject:self.userId forKey:@"uid"];

    [DataService requestWithURL:@"friendships/friends.json" params:params httpMethod:@"GET" completeBlock:^(id result) {
        [self loadAtDataFinish:result];
    }];


}

- (void)loadAtDataFinish:(NSDictionary *)result
{
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
        if (i%3==0) {
            array2D=[NSMutableArray arrayWithCapacity:3];
            [self.data addObject:array2D];
        }
        NSDictionary *userDic=[usersArray objectAtIndex:i];
        UserModel *userModel=[[[UserModel alloc] initWithDataDic:userDic] autorelease];
        [array2D addObject:userModel];
    }
    self.tableView.data=self.data;
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
