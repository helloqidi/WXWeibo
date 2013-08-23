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
    self.infoLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.infoLabel.font=[UIFont systemFontOfSize:16.0f];
    [self addSubview:self.infoLabel];
    
    //关注按钮
    self.attButton=[RectButton buttonWithType:UIButtonTypeCustom];
    [self.attButton setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background.png"] forState:UIControlStateNormal];
    [self.attButton setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background_highlighted.png"] forState:UIControlStateHighlighted];
    [self addSubview:self.attButton];
    
    //粉丝按钮
    self.fansButton=[RectButton buttonWithType:UIButtonTypeCustom];
    [self.fansButton setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background.png"] forState:UIControlStateNormal];
    [self.fansButton setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background_highlighted.png"] forState:UIControlStateHighlighted];
    [self addSubview:self.fansButton];
    
    //资料按钮
    self.profileButton=[RectButton buttonWithType:UIButtonTypeCustom];
    [self.profileButton setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background.png"] forState:UIControlStateNormal];
    [self.profileButton setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background_highlighted.png"] forState:UIControlStateHighlighted];
    [self addSubview:self.profileButton];
    
    //更多按钮
    self.moreButton=[RectButton buttonWithType:UIButtonTypeCustom];
    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background.png"] forState:UIControlStateNormal];
    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"userinfo_apps_background_highlighted.png"] forState:UIControlStateHighlighted];
    [self addSubview:self.moreButton];
    
    //微博总数量
    self.contentLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.contentLabel.font=[UIFont systemFontOfSize:16.0f];
    [self addSubview:self.contentLabel];
   
    //间隔横线
    UIImageView *separatorImage=[[[UIImageView alloc] initWithFrame:CGRectMake(0, 200-1, ScreenWidth, 1)] autorelease];
    separatorImage.image=[UIImage imageNamed:@"userinfo_header_separator.png"];
    [self addSubview:separatorImage];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //总体高度
    self.height=200;
    
    //头像
    self.userImage.frame=CGRectMake(10, 10, 80, 80);
    NSString *userImageUrl=self.userModel.avatar_large;
    //加载网络图片
    [self.userImage setImageWithURL:[NSURL URLWithString:userImageUrl]];
    
    
    //昵称
    self.nickLabel.frame=CGRectMake(self.userImage.right+5, 10, 200, 20);
    self.nickLabel.text=self.userModel.screen_name;
    
    
    //地址性别相关信息
    NSString *gender=self.userModel.gender;
    NSString *sexName=@"未知";
    if ([gender isEqualToString:@"f"]) {
        sexName=@"女";
    }else if ([gender isEqualToString:@"m"]){
        sexName=@"男";
    }
    NSString *location=self.userModel.location;
    //如果不判空，当没有简介时，会在界面上显示null
    if (location==nil) {
        location=@"";
    }
    self.addressLabel.frame=CGRectMake(self.userImage.right+5, self.nickLabel.bottom+5, 200, 20);
    self.addressLabel.text=[NSString stringWithFormat:@"%@ %@",sexName,location];
    
    //简介
    self.infoLabel.frame=CGRectMake(self.userImage.right+5, self.addressLabel.bottom+5, 200, 20);
    NSString *desc=self.userModel.description;
    if (desc==nil) {
        desc=@"";
    }
    NSString *infoString=[NSString stringWithFormat:@"简介:%@",desc];
    self.infoLabel.text=infoString;
    
    //关注按钮
    long followL=[self.userModel.friends_count longValue];
    NSString *follows=[NSString stringWithFormat:@"%ld",followL];
    if (followL>=1000) {
        followL=followL/1000.0;
        follows=[NSString stringWithFormat:@"%ld千",followL];
    }
    self.attButton.frame=CGRectMake(self.userImage.left, self.userImage.bottom+10, 70, 70);
    self.attButton.title=@"关注";
    self.attButton.subtitle=follows;
    
    //粉丝按钮
    long fansL=[self.userModel.followers_count longValue];
    NSString *fans=[NSString stringWithFormat:@"%ld",fansL];
    if (fansL>=10000) {
        fansL=fansL/10000.0;
        fans=[NSString stringWithFormat:@"%ld万",fansL];
    }
    self.fansButton.frame=CGRectMake(self.attButton.right+10, self.userImage.bottom+10, 70, 70);
    self.fansButton.title=@"粉丝";
    self.fansButton.subtitle=fans;
    
    //资料按钮
    self.profileButton.frame=CGRectMake(self.fansButton.right+10, self.userImage.bottom+10, 70, 70);
    [self.profileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.profileButton setTitle:@"资料" forState:UIControlStateNormal];
    
    //更多按钮
    self.moreButton.frame=CGRectMake(self.profileButton.right+10, self.userImage.bottom+10, 70, 70);
    [self.moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.moreButton setTitle:@"更多" forState:UIControlStateNormal];
    
    //微博总数量
    self.contentLabel.frame=CGRectMake(self.userImage.left, self.height-25, 200, 20);
    NSString *content=[NSString stringWithFormat:@"共%@条微博",self.userModel.statuses_count];
    self.contentLabel.text=content;


}


@end
