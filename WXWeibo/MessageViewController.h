//
//  MessageViewController.h
//  WXWeibo

//  消息首页控制器

//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@interface MessageViewController : BaseViewController<UITableViewEventDelegate>

@property(nonatomic,retain)WeiboTableView *tableView;

@end
