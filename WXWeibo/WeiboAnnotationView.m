//
//  WeiboAnnotationView.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-28.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"
#import "UIImageView+WebCache.h"

@implementation WeiboAnnotationView

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
*/

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self!=nil) {
        [self initViews];
    }

    return self;
}


- (void)initViews
{

    //头像
    self.userImage=[[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    //边框
    self.userImage.layer.borderColor=[UIColor whiteColor].CGColor;
    self.userImage.layer.borderWidth=1;
    
    //微博图片
    self.weiboImage=[[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    //保持比例显示（可能图片不能显示全）
    self.weiboImage.contentMode=UIViewContentModeScaleAspectFill;
    self.weiboImage.backgroundColor=[UIColor blackColor];

    //微博文字
    self.textLabel=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.textLabel.font=[UIFont systemFontOfSize:12.0f];
    self.textLabel.textColor=[UIColor whiteColor];
    self.textLabel.backgroundColor=[UIColor clearColor];
    self.textLabel.numberOfLines=3;
    
    [self addSubview:self.weiboImage];
    [self addSubview:self.textLabel];
    [self addSubview:self.userImage];
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    //获得annotation
    //注：MKAnnotationView类就有这个property
    WeiboAnnotation *weiboAnnotation=self.annotation;
    WeiboModel *weibo=nil;
    //做一步严谨的判断
    if ([weiboAnnotation isKindOfClass:[WeiboAnnotation class]]) {
        weibo=weiboAnnotation.weiboModel;
    }
    
    
    //微博是否有图片
    NSString *thumbnailImage=weibo.thumbnailImage;
    if (thumbnailImage.length>0) {
        //注：MKAnnotationView类就有image这个property,可用于设置背景图片
        self.image=[UIImage imageNamed:@"nearby_map_photo_bg.png"];
        
        //微博图片
        self.weiboImage.frame=CGRectMake(15, 15, 90, 85);
        [self.weiboImage setImageWithURL:[NSURL URLWithString:weibo.thumbnailImage]];;
        
        //头像
        self.userImage.frame=CGRectMake(70, 70, 30, 30);
        NSString *userURL=weibo.user.profile_image_url;
        [self.userImage setImageWithURL:[NSURL URLWithString:userURL]];
        
        //考虑MKAnnotationView复用的情况
        self.weiboImage.hidden=NO;
        self.textLabel.hidden=YES;
        
    }else{
        //背景图片
        self.image=[UIImage imageNamed:@"nearby_map_content.png"];
        
        //头像
        self.userImage.frame=CGRectMake(20, 20, 45, 45);
        NSString *userURL=weibo.user.profile_image_url;
        [self.userImage setImageWithURL:[NSURL URLWithString:userURL]];
        
        //微博内容
        self.textLabel.frame=CGRectMake(self.userImage.right+5, self.userImage.top, 110, 45);
        self.textLabel.text=weibo.text;
        
        //考虑MKAnnotationView复用的情况
        self.weiboImage.hidden=YES;
        self.textLabel.hidden=NO;
    }
   
    
}


@end
