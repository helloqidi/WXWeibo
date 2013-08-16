//
//  ThemeViewController.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-16.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"

@interface ThemeViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSArray *themes;

@end
