//
//  ThemeImageView.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-16.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

@property(nonatomic,copy)NSString *imageName;

- (id)initwithImageName:(NSString *)imageName;

@end
