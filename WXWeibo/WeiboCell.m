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
#import "UIUtils.h"
#import "RegexKitLite.h"
#import "UIFactory.h"

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
    //超出部分裁减掉(子layer是否被当前layer的边界剪切)
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
    
    //单元格选中的背景
    //宽度和高度其实会自己调整
    UIView *selectedBackgroundView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)] autorelease];
    selectedBackgroundView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"statusdetail_cell_sepatator.png"]];
    self.selectedBackgroundView=selectedBackgroundView;
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
    [self.nickLabel sizeToFit];
    
    //----微博视图----
    self.weiboView.weiboModel=self.weiboModel;
    float h= [WeiboView getWeiboViewHeight:self.weiboModel isRepost:NO isDetail:NO];
    self.weiboView.frame=CGRectMake(50, self.nickLabel.bottom+10,kWeibo_Width_List, h);
    
    
    //----发布时间----
    if (self.weiboModel.createDate!=nil) {
        self.createLabel.hidden=NO;
        //格式化日期
        NSString *datestring=[UIUtils fomateString:self.weiboModel.createDate];
        self.createLabel.text=datestring;
        self.createLabel.frame=CGRectMake(50, self.height-20, 100, 20);
        [self.createLabel sizeToFit];
    }else{
        self.createLabel.hidden=YES;
    }
    
    //----微博来源----
    if (self.weiboModel.source!=nil) {
        self.sourceLabel.hidden=NO;
        //去掉超链接
        NSString *source=[self parseSource:self.weiboModel.source];
        self.sourceLabel.text=[NSString stringWithFormat:@"来自:%@",source];
        self.sourceLabel.frame=CGRectMake(self.createLabel.right+8, self.createLabel.top, 100, 20);
        [self.sourceLabel sizeToFit];
    }else{
        self.sourceLabel.hidden=YES;
    }
    
    //----评论----
    if (self.weiboModel.commentsCount!=nil) {
        self.commentLabel.hidden=NO;
        self.commentLabel.text=[NSString stringWithFormat:@"评论:%@",self.weiboModel.commentsCount];
        self.commentLabel.frame=CGRectMake(self.right-60, 5, 50, 20);
        [self.commentLabel sizeToFit];
    }else{
        self.commentLabel.hidden=YES;
    }
    
    //----转发----
    if (self.weiboModel.repostsCount!=nil) {
        self.repostCountLabel.hidden=NO;
        self.repostCountLabel.text=[NSString stringWithFormat:@"转发:%@",self.weiboModel.repostsCount];
        self.repostCountLabel.frame=CGRectMake(self.commentLabel.left-10-50, 5, 50, 20);
        [self.repostCountLabel sizeToFit];
    }else{
        self.repostCountLabel.hidden=YES;
    }
    

}

//解析微博来源
- (NSString *)parseSource:(NSString *)source
{
    NSString *regex=@">\\w+<";
    NSArray *array=[source componentsMatchedByRegex:regex];
    if (array.count>0) {
        NSString *ret=[array objectAtIndex:0];
        NSRange range;
        range.location=1;
        range.length=ret.length-2;
        NSString *resultstring=[ret substringWithRange:range];
        return resultstring;
    }
    return  nil;
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
