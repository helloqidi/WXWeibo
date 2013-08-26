//
//  WebViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-25.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self _initViews];
    
    //加载网络
    NSURL *url=[NSURL URLWithString:self.webUrl];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.title=@"载入中...";
    //让状态栏中有风火轮效果
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)_initViews
{
    //web浏览器
    self.webView=[[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44-20-44)] autorelease];
    //适应屏幕缩放
    self.webView.scalesPageToFit=YES;
    self.webView.delegate=self;
    [self.view addSubview:self.webView];
    
    
    //tool bar 工具栏
    //UIToolbar *toolBar=[[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.webView.bottom, ScreenWidth, 44)] autorelease];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    //工具栏按钮
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"后退.png"] forState:UIControlStateNormal];
    backButton.frame=CGRectMake(0, 0, 30, 30);
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    UIButton *forwardButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setImage:[UIImage imageNamed:@"前进.png"] forState:UIControlStateNormal];
    forwardButton.frame=CGRectMake(0, 0, 30, 30);
    [forwardButton addTarget:self action:@selector(goForward:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *forwardButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:forwardButton] autorelease];
    
    UIButton *reloadButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setImage:[UIImage imageNamed:@"刷新.png"] forState:UIControlStateNormal];
    reloadButton.frame=CGRectMake(0, 0, 30, 30);
    [reloadButton addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *reloadButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:reloadButton] autorelease];
    
    UIBarButtonItem *spaceOne=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    spaceOne.width=100;
    UIBarButtonItem *spaceTwo=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    spaceTwo.width=100;
    
    NSArray *itemArray=[NSArray arrayWithObjects:backButtonItem,spaceOne,forwardButtonItem,spaceTwo,reloadButtonItem, nil];
    [self setToolbarItems:itemArray animated:YES];
    
    
}

//返回
- (void)goBack:(id)sender
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

//
- (void)goForward:(id)sender
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
    
}

- (void)reload:(id)sender
{
    [self.webView reload];
}

#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
    //执行javascript代码
    NSString *title=[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title=title;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    self.title=@"加载失败";
    NSLog(@"加载失败:%@",error);
}



#pragma mark - dealloc
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.webView=nil;
    self.webUrl=nil;
    [super dealloc];
}
@end
