//
//  BaseTableView.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-20.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"


@class BaseTableView;
@protocol UITableViewEventDelegate <NSObject>

@optional
//下拉
- (void)pullDown:(BaseTableView *)tableView;
//上拉
- (void)pullUp:(BaseTableView *)tableView;
//选中
- (void)tableView:(BaseTableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface BaseTableView : UITableView<EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic,assign)BOOL reloading;

//是否需要下拉效果
@property(nonatomic,assign)BOOL refreshHeader;

//为talbeview提供数据
@property(nonatomic,retain)NSArray *data;

//代理
@property(nonatomic,assign)id<UITableViewEventDelegate> eventDelegate;

//下拉弹回去
- (void)doneLoadingTableViewData;

//自动上拉刷新
- (void)autoRefreshData;

@end
