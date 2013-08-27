//
//  UserGridView.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-27.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "UserGridView.h"
#import "UIButton+WebCache.h"
#import "UserViewController.h"

@implementation UserGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{

    //给视图添加背景图片
    self.backgroundColor=[UIColor clearColor];  //将本身的背景色去掉
    UIImage *image=[UIImage imageNamed:@"profile_button3_1.png"];
    self.backgroundImageView=[[[UIImageView alloc] initWithImage:image] autorelease];
    [self insertSubview:self.backgroundImageView atIndex:0];
    
    //头像
    self.imageButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.imageButton.backgroundColor=[UIColor clearColor];
    [self.imageButton addTarget:self action:@selector(userImageAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.imageButton];
    
    //昵称
    self.nickLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.nickLabel.textAlignment=NSTextAlignmentCenter; //居中
    self.nickLabel.font=[UIFont systemFontOfSize:12.0f];
    self.nickLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:self.nickLabel];
    
    //粉丝数
    self.fansLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.fansLabel.textAlignment=NSTextAlignmentCenter;
    self.fansLabel.font=[UIFont systemFontOfSize:11.0f];
    self.fansLabel.textColor=[UIColor blueColor];
    self.fansLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:self.fansLabel];

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置宽度、高度
    self.width=96;
    self.height=96;
    
    //背景图片
    self.backgroundImageView.frame=self.bounds;
    
    //头像
    self.imageButton.frame=CGRectMake((self.width-55)/2, 5, 55, 55);
    NSString *urlString=self.userModel.profile_image_url;
    [self.imageButton setImageWithURL:[NSURL URLWithString:urlString]];
    
    //昵称
    self.nickLabel.frame=CGRectMake((self.width-85)/2, self.imageButton.bottom, 85, 18);
    self.nickLabel.text=self.userModel.screen_name;
    //[self.nickLabel sizeToFit];

    //粉丝
    self.fansLabel.frame=CGRectMake((self.width-85)/2, self.nickLabel.bottom, 85, 18);
    long fansL=[self.userModel.followers_count longValue];
    NSString *fans=[NSString stringWithFormat:@"%ld",fansL];
    if (fansL>=10000) {
        fansL=fansL/10000.0;
        fans=[NSString stringWithFormat:@"%ld万",fansL];
    }
    self.fansLabel.text=fans;
    //[self.nickLabel sizeToFit];
    
    
}


- (void)userImageAction
{
    UserViewController *userCtrl=[[[UserViewController alloc] init] autorelease];
    userCtrl.userName=self.userModel.screen_name;
    
    [self.viewController.navigationController pushViewController:userCtrl animated:YES];
}


@end
