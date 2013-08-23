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
#import "CommentTableView.h"
#import "InterfaceImageView.h"

@interface DetailViewController : BaseViewController<UITableViewEventDelegate>

@property(nonatomic,retain)InterfaceImageView *userImageView;

@property(nonatomic,retain)WeiboModel *weiboModel;
@property(nonatomic,retain)WeiboView *weiboView;

@property(nonatomic,retain)CommentTableView *tableView;

@property(nonatomic,retain)NSString *lastCommentId;
@property(nonatomic,retain)NSMutableArray *comments;

@end
