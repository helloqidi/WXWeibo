//
//  UserViewController.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-23.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"
#import "UserInfoView.h"

@interface UserViewController : BaseViewController<UITableViewEventDelegate>

@property(nonatomic,retain)NSString *userName;
@property(nonatomic,copy)NSString *userId;
//是否是显示当前用户的资料
@property(nonatomic,assign)BOOL showLoginUser;

@property(nonatomic,retain)WeiboTableView *tableView;

@property(nonatomic,retain)UserInfoView *userInfo;

@property(nonatomic,retain)NSMutableArray *requests;

@end
