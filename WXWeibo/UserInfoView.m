//
//  UserInfoView.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-23.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "UserInfoView.h"
#import "UIImageView+WebCache.h"

@implementation UserInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}


//初始化视图
- (void)_initView
{
    //头像
    self.userImage=[[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    self.userImage.backgroundColor=[UIColor clearColor];
    //默认图片
    self.userImage.image=[UIImage imageNamed:@"page_image_loading.png"];
    //圆角
    self.userImage.layer.cornerRadius=5;
    //裁剪掉超出部分
    self.userImage.layer.masksToBounds=YES;
    [self addSubview:self.userImage];
    
    
    //昵称
    self.nickLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.nickLabel.font=[UIFont boldSystemFontOfSize:18.0f];
    [self addSubview:self.nickLabel];
    
    //地址
    self.addressLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.addressLabel.font=[UIFont systemFontOfSize:16.0f];
    [self addSubview:self.addressLabel];
    
    //简介
    self.briefLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.briefLabel.font=[UIFont systemFontOfSize:16.0f];
    [self addSubview:self.briefLabel];
    
    //关注按钮
    self.followBtn=[RectButton buttonWithType:UIButtonTypeCustom];
    [self.followBtn setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background.png"] forState:UIControlStateNormal];
    [self.followBtn setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background_highlighted.png"] forState:UIControlStateHighlighted];
    [self addSubview:self.followBtn];
    
    //粉丝按钮
    self.fansBtn=[RectButton buttonWithType:UIButtonTypeCustom];
    [self.fansBtn setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background.png"] forState:UIControlStateNormal];
    [self.fansBtn setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background_highlighted.png"] forState:UIControlStateHighlighted];
    [self addSubview:self.fansBtn];
    
    //资料按钮
    self.profileBtn=[RectButton buttonWithType:UIButtonTypeCustom];
    [self.profileBtn setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background.png"] forState:UIControlStateNormal];
    [self.profileBtn setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background_highlighted.png"] forState:UIControlStateHighlighted];
    [self addSubview:self.profileBtn];
    
    //更多按钮
    self.moreBtn=[RectButton buttonWithType:UIButtonTypeCustom];
    [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background.png"] forState:UIControlStateNormal];
    [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background_highlighted.png"] forState:UIControlStateHighlighted];
    [self addSubview:self.moreBtn];
    
    //微博总数量
    self.weiboCntLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.weiboCntLabel.font=[UIFont systemFontOfSize:16.0f];
    [self addSubview:self.weiboCntLabel];
    
    
}


- (void)layoutSubviews
{
    
    //头像
    self.userImage.frame=CGRectMake(10, 10, 80, 80);
    NSString *userImageUrl=self.userModel.avatar_large;
    //加载网络图片
    [self.userImage setImageWithURL:[NSURL URLWithString:userImageUrl]];
    
    
    //昵称
    self.nickLabel.frame=CGRectMake(self.userImage.right+5, 10, 200, 20);
    self.nickLabel.text=self.userModel.screen_name;
    
    
    //地址
    self.addressLabel.frame=CGRectMake(self.userImage.right+5, self.nickLabel.bottom+5, 200, 20);
    self.addressLabel.text=self.userModel.location;
    
    //简介
    self.briefLabel.frame=CGRectMake(self.userImage.right+5, self.addressLabel.bottom+5, 200, 20);
    NSString *briefString=[NSString stringWithFormat:@"简介:%@",self.userModel.description];
    self.briefLabel.text=briefString;
    
    //关注按钮
    self.followBtn.frame=CGRectMake(10, self.userImage.bottom+10, 70, 70);
    [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    
    //粉丝按钮
    self.fansBtn.frame=CGRectMake(self.followBtn.right+10, self.userImage.bottom+10, 70, 70);
    [self.fansBtn setTitle:@"粉丝" forState:UIControlStateNormal];
    
    //资料按钮
    self.profileBtn.frame=CGRectMake(self.fansBtn.right+10, self.userImage.bottom+10, 70, 70);
    [self.profileBtn setTitle:@"资料" forState:UIControlStateNormal];
    
    //更多按钮
    self.moreBtn.frame=CGRectMake(self.profileBtn.right+10, self.userImage.bottom+10, 70, 70);
    [self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    
    //微博总数量
    self.weiboCntLabel.frame=CGRectMake(self.userImage.right+5, self.bottom+25, 200, 20);
    NSString *weiboCnt=[NSString stringWithFormat:@"共%@条微博",self.userModel.statuses_count];
    self.weiboCntLabel.text=weiboCnt;

    //总体高度
    self.height=200;
}


@end
