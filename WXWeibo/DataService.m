//
//  DataService.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-27.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "DataService.h"
#import "JSONKit.h"

#define BASE_URL @"https://open.weibo.cn/2/"

@implementation DataService

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                     completeBlock:(RequestFinishBlock)block
{
    //取得新浪微博的认证信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *accessToken=[sinaweiboInfo objectForKey:@"AccessTokenKey"];
    
    //拼接URL
    //例如：https://open.weibo.cn/2/statuses/home_timeline.json?access_token=abcdef
    urlstring=[BASE_URL stringByAppendingFormat:@"%@?access_token=%@",urlstring,accessToken];
    
    //处理GET请求
    //忽略大小写比较字符串
    NSComparisonResult comparRet1=[httpMethod caseInsensitiveCompare:@"GET"];
    if (comparRet1==NSOrderedSame) {
        NSMutableString *paramsString=[NSMutableString string];
        NSArray *allkeys=[params allKeys];
        for (int i=0; i<params.count; i++) {
            NSString *key=[allkeys objectAtIndex:i];
            id value= [params objectForKey:key];
            [paramsString appendFormat:@"%@=%@",key,value];
            if (i<params.count-1) {
                [paramsString appendString:@"&"];
            }
        }
    
        //get请求的拼接字符串
        if (paramsString.length>0) {
            urlstring=[urlstring stringByAppendingFormat:@"&%@",paramsString];
        }
    }

    NSURL *url=[NSURL URLWithString:urlstring];
    __block ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    //设置超时时间
    [request setTimeOutSeconds:60];
    [request setRequestMethod:httpMethod];
    
    //处理POST请求方式
    //忽略大小写比较字符串
    NSComparisonResult comparRet2=[httpMethod caseInsensitiveCompare:@"POST"];
    if (comparRet2==NSOrderedSame) {
        NSArray *allkeys=[params allKeys];
        for (int i=0; i<params.count; i++) {
            NSString *key=[allkeys objectAtIndex:i];
            id value=[params objectForKey:key];
            //判断是否文件上传
            if ([value isKindOfClass:[NSData class]]) {
                [request addData:value forKey:key];
            }else{
                [request addPostValue:value forKey:key];
            }
        }
    }

    //设置请求完成的block
    [request setCompletionBlock:^{
        NSData *data=request.responseData;
        float version=WXHLOSVersion();
        id result=nil;
        if (version>=5.0){
            result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }else{
            result=[data objectFromJSONData];
        }
        if (block!=nil){
            block(result);
        }
    }];

    //异步请求
    [request startAsynchronous];

    return request;
    
}

@end
