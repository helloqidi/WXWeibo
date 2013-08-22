//
//  DetailViewController.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-21.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboModel.h"
#import "WeiboView.h"

@interface DetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)WeiboModel *weiboModel;
@property(nonatomic,retain)WeiboView *weiboView;

@property(nonatomic,retain)UITableView *tableView;

@end