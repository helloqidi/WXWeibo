//
//  WebViewController.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-25.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController<UIWebViewDelegate>

@property(nonatomic,retain)UIWebView *webView;
@property(nonatomic,copy)NSString *webUrl;

@end
