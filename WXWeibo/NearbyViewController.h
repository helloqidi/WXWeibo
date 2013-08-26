//
//  NearbyViewController.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-26.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^SelectDoneBlock)(NSDictionary *);
@interface NearbyViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSArray *data;

@property(nonatomic,copy)SelectDoneBlock selectBlock;

@end
