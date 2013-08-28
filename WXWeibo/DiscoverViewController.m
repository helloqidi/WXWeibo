//
//  DiscoverViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-15.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "DiscoverViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"广场";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews
{
    //附近的微博图片按钮
    self.nearWeiboButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.nearWeiboButton.backgroundColor=[UIColor clearColor];
    [self.nearWeiboButton setImage:[UIImage imageNamed:@"附近微博.jpg"] forState:UIControlStateNormal];
    self.nearWeiboButton.frame=CGRectMake(10, 10, 70, 70);
    [self.nearWeiboButton addTarget:self action:@selector(nearWeiboAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nearWeiboButton];
    
    //附近的人图片按钮
    self.nearUserButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.nearUserButton.backgroundColor=[UIColor clearColor];
    [self.nearUserButton setImage:[UIImage imageNamed:@"附近的人.jpg"] forState:UIControlStateNormal];
    self.nearUserButton.frame=CGRectMake(self.nearWeiboButton.right+10, 10, 70, 70);
    [self.nearWeiboButton addTarget:self action:@selector(nearUserAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nearUserButton];
    
    //添加阴影
    NSArray *buttonArray=[NSArray arrayWithObjects:self.nearWeiboButton,self.nearUserButton, nil];
    for (int i=0; i<buttonArray.count; i++) {
        UIButton *button=[buttonArray objectAtIndex:i];
        button.layer.shadowColor=[UIColor blackColor].CGColor;
        button.layer.shadowOffset=CGSizeMake(2, 2);
        button.layer.shadowOpacity=1;
    }

}

#pragma mark - Action
- (void)nearWeiboAction
{

}

- (void)nearUserAction
{
    
}


#pragma mark - dealloc
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
