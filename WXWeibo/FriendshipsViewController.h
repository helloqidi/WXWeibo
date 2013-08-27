//
//  FriendshipsViewController.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-27.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendShipsTableView.h"

@interface FriendshipsViewController : BaseViewController

@property(nonatomic,copy)NSString *userId;
@property(nonatomic,retain)NSMutableArray *data;

@property(nonatomic,retain)FriendShipsTableView *tableView;

@end
