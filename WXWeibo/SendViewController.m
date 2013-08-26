//
//  SendViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-26.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "SendViewController.h"
#import "UIFactory.h"

@interface SendViewController ()

@end

@implementation SendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //监听键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title=@"发布新微博";
    self.buttons=[[[NSMutableArray alloc] init] autorelease];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //取消按钮
    UIButton *cancelbutton=[UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"取消" target:self action:@selector(cancelAction)];
    UIBarButtonItem *cancelButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:cancelbutton] autorelease];
    self.navigationItem.leftBarButtonItem=cancelButtonItem;
    
    //发布按钮
    UIButton *sendButton=[UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"发布" target:self action:@selector(sendAction)];
    UIBarButtonItem *sendButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:sendButton] autorelease];
    self.navigationItem.rightBarButtonItem=sendButtonItem;

    
    [self _initViews];
    
}

- (void)_initViews
{

    //输入框
    self.textView=[[[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44-80)] autorelease];
    self.textView.backgroundColor=[UIColor grayColor];
    [self.view addSubview:self.textView];
    
    //工具栏
    self.editorBar=[[[UIView alloc] initWithFrame:CGRectMake(0, self.textView.bottom, ScreenWidth, 55)] autorelease];
    self.editorBar.backgroundColor=[UIColor greenColor];
    [self.view addSubview:self.editorBar];
    
    //工具栏中的按钮
    NSArray *images=[NSArray arrayWithObjects:@"compose_locatebutton_background.png",@"compose_camerabutton_background.png", @"compose_trendbutton_background.png",@"compose_mentionbutton_background.png",@"compose_emoticonbutton_background.png",@"compose_keyboardbutton_background.png",nil];
    NSArray *highlightedImages=[NSArray arrayWithObjects:@"compose_locatebutton_background_highlighted.png",@"compose_camerabutton_background_highlighted.png", @"compose_trendbutton_background_highlighted.png",@"compose_mentionbutton_background_highlighted.png",@"compose_emoticonbutton_background_highlighted.png",@"compose_keyboardbutton_background_highlighted.png",nil];

    for (int i=0; i<images.count; i++) {
        NSString *imageName=[images objectAtIndex:i];
        NSString *highlightedName=[highlightedImages objectAtIndex:i];
        UIButton *button=[UIFactory createButton:imageName highlighted:highlightedName];
        [button setImage:[UIImage imageNamed:highlightedName] forState:UIControlStateHighlighted];
        button.tag=(10+i);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(20+64*i, 25, 23, 19);
        [self.editorBar addSubview:button];
        [self.buttons addObject:button];
        
        if (i==5) {
            button.hidden=YES;
            button.left -= 64;
        }
        
    }
    
    //显示键盘
    [self.textView becomeFirstResponder];
    
}

#pragma mark - Action
- (void)buttonAction:(UIButton *)button
{

}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//发布微博
- (void)sendAction
{
    [self doSendData];
}

#pragma mark - Data
- (void)doSendData
{
    NSString *text=self.textView.text;
    if (text.length==0) {
        NSLog(@"微博内容为空");
        return;
    }
    
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
    
    [self.sinaweibo requestWithURL:@"tatuses/update.json" params:params httpMethod:@"POST" block:^(id result) {
        [self cancelAction];
    }];
}


#pragma mark - NSNotification
- (void)keyboardShowNotification:(NSNotification *)notification
{
    NSLog(@"%@",notification.userInfo);
    //得到键盘frame信息
    NSValue *keyboardVale=[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame=[keyboardVale CGRectValue];
    //得到键盘高度
    float height=frame.size.height;
    
    //调整工具栏位置
    self.editorBar.bottom=ScreenHeight-height-20-44;
    //调整textview高度
    self.textView.height=self.editorBar.top;
    
    
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
