//
//  UserViewController.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-23.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"
#import "UserModel.h"

@interface UserViewController : BaseViewController


@property(nonatomic,retain)UserModel *userModel;
@property(nonatomic,retain)WeiboTableView *tableView;

@end
