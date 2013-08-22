//
//  CommentCell.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-22.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"


@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}


- (void)_initView
{    
    //用户头像
    self.userImage=[[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    self.userImage.backgroundColor=[UIColor clearColor];
    self.userImage.tag=100;
    //圆角
    self.userImage.layer.cornerRadius=5;
    //裁剪掉超出部分
    self.userImage.layer.masksToBounds=YES;
    [self.contentView addSubview:self.userImage];
    
    //昵称
    self.nickLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.nickLabel.font=[UIFont systemFontOfSize:15.0f];
    self.nickLabel.tag=101;
    [self.nickLabel sizeToFit];
    [self.contentView addSubview:self.nickLabel];
    
    //时间
    self.timeLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.timeLabel.font=[UIFont systemFontOfSize:14.0f];
    self.timeLabel.tag=102;
    [self.timeLabel sizeToFit];
    self.timeLabel.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];

    //内容
    self.contentLabel=[[[RTLabel alloc] initWithFrame:CGRectZero] autorelease];
    self.contentLabel.font=[UIFont systemFontOfSize:14.0f];
    self.contentLabel.delegate=self;
    //链接颜色
    self.contentLabel.linkAttributes=[NSDictionary dictionaryWithObject:@"red" forKey:@"color"];
    self.contentLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
    [self.contentView addSubview:self.contentLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //头像
    self.userImage.frame=CGRectMake(10, 2, 40, 40);
    NSString *userImageUrl=self.commentModel.user.profile_image_url;
    //加载网络图片
    [self.userImage setImageWithURL:[NSURL URLWithString:userImageUrl]];

    
    //昵称
    self.nickLabel.frame=CGRectMake(self.userImage.right+5, 2, 200, 20);
    self.nickLabel.text=self.commentModel.user.screen_name;
    
    //时间 01-25 22:22
    self.timeLabel.frame=CGRectMake(self.contentView.right-80-10,2, 80, 20);
    self.timeLabel.text=[UIUtils fomateString:self.commentModel.created_at];
    
    //内容
    self.contentLabel.frame=CGRectMake(self.userImage.right+10, self.nickLabel.bottom+5, 240, 20);
    NSString *commentText=self.commentModel.text;
    self.contentLabel.text=[UIUtils parseLink:commentText];
    self.contentLabel.height=self.contentLabel.optimumSize.height;
}


+ (float)getCommentHeight:(CommentModel *)commentModel
{
    float h=0;
    
    RTLabel *rt=[[[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)] autorelease];
    rt.text=commentModel.text;
    rt.font=[UIFont systemFontOfSize:14.0f];
    
    h=rt.optimumSize.height;
    h+=40;
    
    return h;
}

#pragma mark - RTLabel Delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{

}


@end
