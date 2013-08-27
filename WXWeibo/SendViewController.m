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
    self.textView.delegate=self;
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
    if (button.tag==10) {
        //定位
        [self location];
    }
    else if (button.tag==11)
    {
        //相册、摄像头
        [self selectImage];
    }else if (button.tag==12){
        //显示话题
    
    }else if (button.tag==13){
        //显示AT用户
    
    }else if (button.tag==14){
        //显示表情
        [self showFaceView];
    }else if (button.tag==15){
        //显示键盘
        [self showKeyboard];
    }

}

//发布微博
- (void)sendAction
{
    [self doSendData];
}

//全屏放大图片
- (void)imageAction:(UIButton *)button
{
    //放大图片。用UIImageView（加在window上）全屏显示。
    if (self.fullImageView==nil) {
        self.fullImageView=[[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)] autorelease];
        self.fullImageView.backgroundColor=[UIColor blackColor];
        self.fullImageView.userInteractionEnabled=YES;
        //不拉伸
        self.fullImageView.contentMode=UIViewContentModeScaleAspectFit;
        
        //添加手势
        UITapGestureRecognizer *tapGesture=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageAction:)] autorelease];
        [self.fullImageView addGestureRecognizer:tapGesture];
        
        //创建删除按钮
        UIButton *deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
        deleteButton.frame=CGRectMake(280, 40, 20, 26);
        deleteButton.tag=100;
        //隐藏删除按钮，防止它也有动画效果
        deleteButton.hidden=YES;
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.fullImageView addSubview:deleteButton];
    }

    //键盘消失
    [self.textView resignFirstResponder];
    //如果没有父视图
    if (![self.fullImageView superview]) {
        self.fullImageView.image=self.sendImage;
        //加载window上
        [self.view.window addSubview:self.fullImageView];
        //动画效果
        self.fullImageView.frame=CGRectMake(5, ScreenHeight-250, 20, 20);
        [UIView animateWithDuration:0.4 animations:^{
            self.fullImageView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        } completion:^(BOOL finished) {
            //隐藏状态栏
            [UIApplication sharedApplication].statusBarHidden=YES;            
            UIButton *deleteButton=(UIButton *)[self.fullImageView viewWithTag:100];
            deleteButton.hidden=NO;
        }];
    }
    
}

//单击缩小图片
- (void)scaleImageAction:(UITapGestureRecognizer *)tapGesture
{
    //隐藏删除按钮，防止它也有动画效果
    UIButton *deleteButton=(UIButton *)[self.fullImageView viewWithTag:100];
    deleteButton.hidden=YES;
    
    //图片缩小
    [UIView animateWithDuration:0.4 animations:^{
        self.fullImageView.frame=CGRectMake(5, ScreenHeight-250, 20, 20);
    } completion:^(BOOL finished) {
        [self.fullImageView removeFromSuperview];
    }];
    
    [UIApplication sharedApplication].statusBarHidden=NO;
    [self.textView becomeFirstResponder];
}

//删除图片
- (void)deleteAction:(UIButton *)deleteButton
{
    //缩小图片
    [self scaleImageAction:nil];
    //移除缩略图按钮
    [self.sendImageButton removeFromSuperview];
    //把sendImage
    self.sendImage=nil;
    //恢复位置
    UIButton *button1=[self.buttons objectAtIndex:0];
    UIButton *button2=[self.buttons objectAtIndex:1];
    //动画
    [UIView animateWithDuration:0.5 animations:^{
        //使用transform，对比frame来说有个好处，方法CGAffineTransformIdentity可以直接恢复移动之前的坐标。
        button1.transform=CGAffineTransformIdentity;
        button2.transform=CGAffineTransformIdentity;
    }];
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
    if (self.sendImage==nil) {
        //不带图片
        [self.sinaweibo requestWithURL:@"statuses/update.json" params:params httpMethod:@"POST" block:^(id result) {
            //在状态栏（其实是一个单独的window）显示label
            [super showStatusTip:NO title:@"发送成功"];
            [self dismissModalViewControllerAnimated:YES];
        }];
    }else{
        //带图片
        //将图片转换为data,并压缩质量
        NSData *data=UIImageJPEGRepresentation(self.sendImage, 0.3);
        [params setObject:data forKey:@"pic"];
        [self.sinaweibo requestWithURL:@"statuses/upload.json" params:params httpMethod:@"POST" block:^(id result) {
            //在状态栏（其实是一个单独的window）显示label
            [super showStatusTip:NO title:@"发送成功"];
            [self dismissModalViewControllerAnimated:YES];
        }];
    
    }
    

    
}

//定位
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

//使用相片
- (void)selectImage
{
   
    UIActionSheet *actionSheet=[[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"用户相册", nil] autorelease];
    //显示UIActionSheet
    [actionSheet showInView:self.view];
}


//显示表情
- (void)showFaceView
{
    //收起键盘
    [self.textView resignFirstResponder];
    
    if (self.faceView==nil) {
        
        __block SendViewController *this=self;
        self.faceView=[[[FaceScrollView alloc] initWithSelectBlock:^(NSString *faceName) {
            //追加表情到输入框
            //注：此处用到了self，需要避免循环引用。
            NSString *text=this.textView.text;
            text=[text stringByAppendingString:faceName];
            this.textView.text=text;
            
        }] autorelease];
        //创建完后才知道faceView的高度
        self.faceView.top=ScreenHeight-20-44-self.faceView.height;
        //x坐标不用移动,y坐标移出屏幕,为了点击后出现显示的动画效果
        self.faceView.transform=CGAffineTransformTranslate(self.faceView.transform, 0, ScreenHeight);
        [self.view addSubview:self.faceView];
    }
    
    //动画效果
    UIButton *faceButton=[self.buttons objectAtIndex:4];
    UIButton *keyboard=[self.buttons objectAtIndex:5];
    faceButton.alpha=1;
    keyboard.alpha=0;
    keyboard.hidden=NO;
    [UIView animateWithDuration:0.3 animations:^{
        //faceView恢复原始状态
        self.faceView.transform=CGAffineTransformIdentity;
        //表情按钮消失
        faceButton.alpha=0;
        
        //调整textView,editorBar的Y坐标
        float height=self.faceView.height;
        self.editorBar.bottom=ScreenHeight-height-20-44;
        self.textView.height=self.editorBar.top;
        
    } completion:^(BOOL finished) {
        //键盘按钮显示
        [UIView animateWithDuration:0.3 animations:^{
            keyboard.alpha=1;
        }];
    }];
}

//显示键盘
- (void)showKeyboard
{
    [self.textView becomeFirstResponder];
    
    
    //动画
    UIButton *faceButton=[self.buttons objectAtIndex:4];
    UIButton *keyboard=[self.buttons objectAtIndex:5];
    faceButton.alpha=0;
    keyboard.alpha=1;
    [UIView animateWithDuration:0.3 animations:^{
        self.faceView.transform=CGAffineTransformTranslate(self.faceView.transform, 0, ScreenHeight);
        keyboard.alpha=0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            faceButton.alpha=1;
        }];
    }];

}

#pragma mark - UIActionSheet Deletage
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //声明一个枚举变量
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex==0) {
        //是否有摄像头
        BOOL isCamera=[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alertView=[[[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
            //显示UIAlertView
            [alertView show];
            return;
        }
        //拍照
        sourceType=UIImagePickerControllerSourceTypeCamera;
    }else if(buttonIndex==1){
        //相册
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }else if(buttonIndex==2){
        //取消
        return;
    }

    UIImagePickerController *imagePicker=[[[UIImagePickerController alloc] init] autorelease];
    imagePicker.sourceType=sourceType;
    imagePicker.delegate=self;
    //通过模态视图弹出
    [self presentModalViewController:imagePicker animated:YES];
    

}

#pragma mark -UIImagePickerController Deletate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到原始大小的图片
    self.sendImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (self.sendImageButton==nil){
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        //圆角
        button.layer.masksToBounds=YES;
        button.frame=CGRectMake(5, 20, 25, 25);
        [button addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
        self.sendImageButton=button;
    }
    [self.sendImageButton setImage:self.sendImage forState:UIControlStateNormal];
    [self.editorBar addSubview:self.sendImageButton];
    //移动按钮空出位置
    UIButton *button1=[self.buttons objectAtIndex:0];
    UIButton *button2=[self.buttons objectAtIndex:1];
    //动画
    [UIView animateWithDuration:0.5 animations:^{
        //使用transform，对比frame来说有个好处，方法CGAffineTransformIdentity可以直接恢复移动之前的坐标。
        button1.transform=CGAffineTransformTranslate(button1.transform, 20, 0);
        button2.transform=CGAffineTransformTranslate(button2.transform, 5, 0);
    }];
    
    //关闭窗口
    [picker dismissModalViewControllerAnimated:YES];
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

#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //显示键盘
    [self showKeyboard];
    
    return YES;
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    self.textView=nil;
    self.editorBar=nil;
    self.buttons=nil;
    self.longitude=nil;
    self.latitude=nil;
    self.placeView=nil;
    self.placeLabel=nil;
    self.sendImage=nil;
    self.sendImageButton=nil;
    self.fullImageView=nil;
    self.faceView=nil;

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
