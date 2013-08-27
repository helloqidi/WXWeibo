//
//  MessageViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "MessageViewController.h"
#import "FaceScrollView.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"消息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    FaceScrollView *scrollView=[[[FaceScrollView alloc] initWithFrame:CGRectMake(0, 100, 0, 0)] autorelease];
    
    [self.view addSubview:scrollView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
