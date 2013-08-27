//
//  FaceView.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-27.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(NSString *faceName);

@interface FaceView : UIView

//表情数组
@property(nonatomic,retain)NSMutableArray *items;
//放大镜
@property(nonatomic,retain)UIImageView *magnifierView;
//选中的表情
@property(nonatomic,copy)NSString *selectFaceName;

//数组的数量
@property(nonatomic,assign)NSInteger pageNumber;

@property(nonatomic,copy)SelectBlock selectBlock;

@end
