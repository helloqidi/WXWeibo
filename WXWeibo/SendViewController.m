//
//  SendViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-26.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "SendViewController.h"
#import "UIFactory.h"
#import "NearbyViewController.h"
#import "BaseNavigationController.h"

@interface SendViewController ()

@end

@implementation SendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //取消按钮
        //注：必须放在viewDidLoad之前(它是在基类BaseViewController中定义的)
        self.isCancelButton=YES;
        
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
    self.textView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.textView];
    
    //工具栏
    self.editorBar=[[[UIView alloc] initWithFrame:CGRectMake(0, self.textView.bottom, ScreenWidth, 55)] autorelease];
    self.editorBar.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.editorBar];
    
    //工具栏中的按钮
    NSArray *images=[NSArray arrayWithObjects:@"compose_locatebutton_background.png",@"compose_camerabutton_background.png", @"compose_trendbutton_background.png",@"compose_mentionbutton_background.png",@"compose_emoticonbutton_background.png",@"compose_keyboardbutton_background.png",nil];
    NSArray *highlightedImages=[NSArray arrayWithObjects:@"compose_locatebutton_background_highlighted.png",@"compose_camerabutton_background_highlighted.png", @"compose_trendbutton_background_highlighted.png",@"compose_mentionbutton_background_highlighted.png",@"compose_emoticonbutton_background_highlighted.png",@"compose_keyboardbutton_background_highlighted.png",nil];

    for (int i=0; i<images.count; i++) {
        NSString *imageName=[images objectAtIndex:i];
        NSString *highlightedName=[highlightedImages objectAtIndex:i];
        UIButton *button=[UIFactory createButton:imageName highlighted:highlightedName];
        //选中状态下的按钮图片
        [button setImage:[UIImage imageNamed:highlightedName] forState:UIControlStateSelected];
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
    
    
    //显示坐标的视图，默认隐藏
    self.placeView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 30)] autorelease];
    self.placeView.hidden=YES;
    [self.editorBar addSubview:self.placeView];
    UIImageView *placeBackgroundView=[[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 230, 23)] autorelease];
    UIImage *image=[UIImage imageNamed:@"compose_placebutton_background.png"];
    placeBackgroundView.image=[image stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    [self.placeView addSubview:placeBackgroundView];
    self.placeLabel=[[[UILabel alloc] initWithFrame:CGRectMake(30, 0, 160, 23)] autorelease];
    self.placeLabel.backgroundColor=[UIColor clearColor];
    [self.placeView addSubview:self.placeLabel];
    
}



#pragma mark - Action
- (void)buttonAction:(UIButton *)button
{
    //定位
    if (button.tag==10) {
        [self location];
    }
    /*
    else if (button.tag==11)
    {
        
    }else if (button.tag==12){
    
    }else if (button.tag==13){
    
    }else if (button.tag==14){
    
    }*/

}

//发布微博
- (void)sendAction
{
    [self doSendData];
}

#pragma mark - Data
- (void)doSendData
{
    [super showStatusTip:YES title:@"发送中..."];
    
    NSString *text=self.textView.text;
    if (text.length==0) {
        NSLog(@"微博内容为空");
        return;
    }
    
    //发布普通微博
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
    if (self.longitude.length>0) {
        [params setObject:self.longitude forKey:@"long"];
    }
    if (self.latitude.length>0) {
        [params setObject:self.latitude forKey:@"lat"];
    }
    
    [self.sinaweibo requestWithURL:@"statuses/update.json" params:params httpMethod:@"POST" block:^(id result) {
        //在状态栏（其实是一个单独的window）显示label
        [super showStatusTip:NO title:@"发送成功"];
        [self dismissModalViewControllerAnimated:YES];
    }];
    
}

- (void)location
{
    NearbyViewController *nearbyCtrl=[[[NearbyViewController alloc] init] autorelease];
    BaseNavigationController *baseNav=[[[BaseNavigationController alloc] initWithRootViewController:nearbyCtrl] autorelease];
    //[self presentViewController:baseNav animated:YES completion:NULL];
    nearbyCtrl.selectBlock=^(NSDictionary *result){
        
        //记录坐标
        self.latitude=[result objectForKey:@"lat"];
        self.longitude=[result objectForKey:@"lon"];
        
        NSString *address=[result objectForKey:@"address"];
        if ([address isKindOfClass:[NSNull class]] || address.length==0) {
            address=[result objectForKey:@"title"];
        }
        self.placeLabel.text=address;
        self.placeView.hidden=NO;
        
        //按钮的状态
        UIButton *locationBtn=[self.buttons objectAtIndex:0];
        locationBtn.selected=YES;
    };
    [self presentModalViewController:baseNav animated:YES];
}

#pragma mark - NSNotification
- (void)keyboardShowNotification:(NSNotification *)notification
{
    //NSLog(@"%@",notification.userInfo);
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
