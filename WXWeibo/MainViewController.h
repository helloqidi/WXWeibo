//
//  MainViewController.h
//  WXWeibo

//  TabBar主控制器

//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "HomeViewController.h"


@interface MainViewController : UITabBarController<SinaWeiboDelegate>

@property(nonatomic,retain)UIView *tabBarView;
@property(nonatomic,retain)UIImageView *sliderView;

//小图标，可显示未读信息数量
@property(nonatomic,retain)UIImageView *badgeView;

//可通过该属性操作HomeViewController中的事件
//@property(nonatomic,retain)HomeViewController *home;

//是否显示badge
- (void)showBadge:(BOOL)show;

@end
