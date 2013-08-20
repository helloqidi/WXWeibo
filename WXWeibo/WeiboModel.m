//
//  WeiboModel.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-19.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "WeiboModel.h"
#import "UserModel.h"

@implementation WeiboModel


- (NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt=@{
                           @"createDate":@"created_at",
                           @"weiboID":@"id",
                           @"text":@"text",
                           @"source":@"source",
                           @"favorited":@"favorited",
                           @"thumbnailImage":@"thumbnail_pic",
                           @"bmiddleImage":@"bmiddle_pic",
                           @"originalImage":@"original_pic",
                           @"geo":@"geo",
                           @"repostsCount":@"reposts_count",
                           @"commentsCount":@"comments_count"
                           };
    return mapAtt;
}


- (void)setAttributes:(NSDictionary *)dataDic
{
    //将字典数据 根据映射关系 填充到当前对象的属性上
    [super setAttributes:dataDic];
    
    NSDictionary *retweetDic=[dataDic objectForKey:@"retweeted_status"];
    if (retweetDic!=nil) {
        WeiboModel *weibo=[[[WeiboModel alloc] initWithDataDic:retweetDic] autorelease];
        self.relWeibo=weibo;
    }

    
    NSDictionary *userDic=[dataDic objectForKey:@"user"];
    if (userDic!=nil) {
        UserModel *user=[[[UserModel alloc] initWithDataDic:userDic] autorelease];
        self.user=user;
    }

}

- (void)dealloc
{
    self.createDate=nil;
    self.weiboID=nil;
    self.text=nil;
    self.source=nil;
    self.favorited=nil;
    self.thumbnailImage=nil;
    self.bmiddleImage=nil;
    self.originalImage=nil;
    self.geo=nil;
    self.user=nil;
    self.relWeibo=nil;
    self.repostsCount=nil;
    self.commentsCount=nil;
    [super dealloc];
}

@end