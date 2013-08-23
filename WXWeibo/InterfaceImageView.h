//
//  InterfaceImageView.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-23.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageBlock)(void);

@interface InterfaceImageView : UIImageView

@property(nonatomic,copy)ImageBlock touchBlock;

@end
