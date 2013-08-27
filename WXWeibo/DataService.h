//
//  DataService.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-27.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^RequestFinishBlock)(id result);

@interface DataService : NSObject


+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                     completeBlock:(RequestFinishBlock)block;

@end
