//
//  WeiboView.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-19.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "RTLabel.h"
#import "ThemeImageView.h"

//微博在列表中的宽度
#define kWeibo_Width_List   (320-60)
//微博在详情中的宽度
#define kWeibo_Width_Detail   (320-20)


@interface WeiboView : UIView<RTLabelDelegate>

//微博模型
@property(nonatomic,retain)WeiboModel *weiboModel;
//转发的微博视图
@property(nonatomic,retain)WeiboView *repostView;
//转发的原微博背景图片
@property(nonatomic,retain)ThemeImageView *repostBackgroundView;
//当前微博视图是否是转发
@property(nonatomic,assign)BOOL isRepost;
//微博是否显示在微博详情中
@property(nonatomic,assign)BOOL isDetail;

//微博内容
@property(nonatomic,retain)RTLabel *textLabel;
//微博图片
@property(nonatomic,retain)UIImageView *image;

//可变字符串
@property(nonatomic,retain)NSMutableString *parseText;


//计算微博视图的高度
+ (float)getWeiboViewHeight:(WeiboModel *)weiboModel isRepost:(BOOL)isRepost isDetail:(BOOL)isDetail;
//获得字体
+ (float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost;

@end
