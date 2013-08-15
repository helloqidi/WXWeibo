//
//  MainViewController.h
//  WXWeibo

//  TabBar主控制器

//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"


@interface MainViewController : UITabBarController<SinaWeiboDelegate>

@property(nonatomic,retain) UIView *tabBarView;

@end
