//
//  HomeViewController.h
//  WXWeibo

//  个人首页控制器

//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"
#import "ThemeImageView.h"

@interface HomeViewController : BaseViewController<SinaWeiboRequestDelegate,UITableViewEventDelegate>

@property(nonatomic,retain)WeiboTableView *tableView;

@property(nonatomic,copy)NSString *topWeiboId;

@property(nonatomic,retain)NSMutableArray *weibos;

//显示微博数量的横条
@property(nonatomic,retain)ThemeImageView *barView;

//自动刷新微博
- (void)autorefreshWeibo;
@end
