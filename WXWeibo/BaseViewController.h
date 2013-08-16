//
//  BaseViewController.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface BaseViewController : UIViewController

//是否显示返回按钮
@property(nonatomic,assign)BOOL isBackButton;

- (SinaWeibo *) sinaweibo;

@end
