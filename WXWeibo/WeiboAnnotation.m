//
//  WeiboAnnotation.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-28.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation


- (id)initWithWeibo:(WeiboModel *)weibo
{
    self=[super init];
    if (self!=nil) {
        self.weiboModel=weibo;
        
        //新浪相关接口返回的微博中有经纬度信息
    }
    return self;
}

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    if (_weiboModel!=weiboModel) {
        [_weiboModel release];
        _weiboModel=[weiboModel retain];
    }
    
    //获取经纬度
    //有时返回"null",会被解析成 NSNull
    NSDictionary *geo=weiboModel.geo;
    if ([geo isKindOfClass:[NSDictionary class]]) {
        NSArray *coord=[geo objectForKey:@"coordinates"];
        if (coord.count==2) {
            float lat=[[coord objectAtIndex:0] floatValue];
            float lon=[[coord objectAtIndex:1] floatValue];
            //self.coordinate=CLLocationCoordinate2DMake(lat, lon);
            //注：不能使用self.coordinate,它是readonly,没有set方法
            _coordinate=CLLocationCoordinate2DMake(lat, lon);
        }
    }

}


@end
