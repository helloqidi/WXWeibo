//
//  FaceScrollView.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-27.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

@interface FaceScrollView : UIView<UIScrollViewDelegate>

@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)FaceView *faceView;
@property(nonatomic,retain)UIPageControl *pageControl;

- (id)initWithSelectBlock:(SelectBlock)block;

@end
