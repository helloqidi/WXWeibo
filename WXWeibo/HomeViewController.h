//
//  HomeViewController.h
//  WXWeibo

//  个人首页控制器

//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController<SinaWeiboRequestDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSArray *data;

@end
