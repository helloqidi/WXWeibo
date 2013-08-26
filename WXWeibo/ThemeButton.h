//
//  ThemeButton.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-16.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

@property(nonatomic,copy)NSString *imageName;
@property(nonatomic,copy)NSString *highlightImageName;

@property(nonatomic,copy)NSString *backgroundImageName;
@property(nonatomic,copy)NSString *backgroundHighlightImageName;

//横向离原点的拉伸位置
@property(nonatomic,assign)int leftCapWidth;
//y左边离原点的拉伸位置
@property(nonatomic,assign)int topCapHeight;


- (id)initWithImage:(NSString *)imageName highlighted:(NSString *)highlightImageName;
- (id)initWithBackgroundImage:(NSString *)backgroundImageName highlighted:(NSString *)backgroundHighlightImageName;

@end
