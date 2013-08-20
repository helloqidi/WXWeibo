//
//  WeiboCell.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-19.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "WeiboCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"

@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

//初始化子视图
- (void)_initView{
    //用户头像
    self.userImage=[[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    self.userImage.backgroundColor=[UIColor clearColor];
    //圆角
    self.userImage.layer.cornerRadius=5;
    self.userImage.layer.borderWidth=.5;
    self.userImage.layer.borderColor=[UIColor grayColor].CGColor;
    //超出部分裁减掉
    self.userImage.layer.masksToBounds=YES;
    [self.contentView addSubview:self.userImage];

    //昵称
    self.nickLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.nickLabel.backgroundColor=[UIColor clearColor];
    self.nickLabel.font=[UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.nickLabel];
    
    //转发数
    self.repostCountLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.repostCountLabel.backgroundColor=[UIColor clearColor];
    self.repostCountLabel.font=[UIFont systemFontOfSize:12.0];
    self.repostCountLabel.textColor=[UIColor blackColor];
    [self.contentView addSubview:self.repostCountLabel];
    
    //评论数
    self.commentLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.commentLabel.backgroundColor=[UIColor clearColor];
    self.commentLabel.font=[UIFont systemFontOfSize:12.0];
    self.commentLabel.textColor=[UIColor blackColor];
    [self.contentView addSubview:self.commentLabel];
    
    //来源
    self.sourceLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.sourceLabel.backgroundColor=[UIColor clearColor];
    self.sourceLabel.font=[UIFont systemFontOfSize:12.0];
    self.sourceLabel.textColor=[UIColor blackColor];
    [self.contentView addSubview:self.sourceLabel];

    //发布时间
    self.createLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.createLabel.backgroundColor=[UIColor clearColor];
    self.createLabel.font=[UIFont systemFontOfSize:12.0];
    self.createLabel.textColor=[UIColor blueColor];
    [self.contentView addSubview:self.createLabel];
    
    //weibo view
    self.weiboView=[[[WeiboView alloc] initWithFrame:CGRectZero] autorelease];
    [self.contentView addSubview:self.weiboView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //----用户头像----
    self.userImage.frame=CGRectMake(5, 5, 35, 35);
    NSString *userImageUrl=self.weiboModel.user.profile_image_url;
    [self.userImage setImageWithURL:[NSURL URLWithString:userImageUrl]];
    
    //----昵称----
    self.nickLabel.frame=CGRectMake(50, 5, 200, 20);
    self.nickLabel.text=self.weiboModel.user.screen_name;
    
    //----微博视图----
    self.weiboView.weiboModel=self.weiboModel;
    float h= [WeiboView getWeiboViewHeight:self.weiboModel isRepost:NO isDetail:NO];
    self.weiboView.frame=CGRectMake(50, self.nickLabel.bottom+10,kWeibo_Width_List, h);
    
}


#pragma mark - dealloc/memoryWarning
- (void)dealloc
{
    self.weiboView=nil;
    self.weiboModel=nil;
    self.userImage=nil;
    self.nickLabel=nil;
    self.repostCountLabel=nil;
    self.commentLabel=nil;
    self.sourceLabel=nil;
    self.createLabel=nil;
    [super dealloc];
}

@end
