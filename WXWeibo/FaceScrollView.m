//
//  FaceScrollView.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-27.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "FaceScrollView.h"

@implementation FaceScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (id)initWithSelectBlock:(SelectBlock)block
{
    self=[self initWithFrame:CGRectZero];
    if (self!=nil) {
        self.faceView.selectBlock=block;
    }
    return self;
}


- (void)initViews
{
    self.faceView=[[[FaceView alloc] initWithFrame:CGRectZero] autorelease];
    
    self.scrollView=[[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.faceView.height)] autorelease];
    self.scrollView.contentSize=CGSizeMake(self.faceView.width, self.faceView.height);
    self.scrollView.backgroundColor=[UIColor clearColor];
    self.scrollView.pagingEnabled=YES;
    //禁止水平滚动条
    self.scrollView.showsHorizontalScrollIndicator=NO;
    //超出部分不裁剪
    self.scrollView.clipsToBounds=NO;
    self.scrollView.delegate=self;
    [self.scrollView addSubview:self.faceView];
    [self addSubview:self.scrollView];
    
    
    //翻页
    self.pageControl=[[[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.bottom, 40, 20)] autorelease];
    self.pageControl.backgroundColor=[UIColor clearColor];
    self.pageControl.numberOfPages=self.faceView.pageNumber;
    //初始为第0页
    self.pageControl.currentPage=0;
    [self addSubview:self.pageControl];
    
    
    //当前视图的高度与宽度
    self.height=self.scrollView.height+self.pageControl.height;
    //NSLog(@"height:%f",self.height);
    self.width=self.scrollView.width;
    //背景图片高度不足，图片背身又不能拉伸，这时，要用drawRect绘制背景图片
    //self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background.png"]];
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //通过偏移量计算页数
    int pageNumber=scrollView.contentOffset.x/320;
    self.pageControl.currentPage=pageNumber;
}


- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"emoticon_keyboard_background.png"] drawInRect:rect];
}


- (void)dealloc
{
    self.scrollView=nil;
    self.faceView=nil;
    self.pageControl=nil;
    [super dealloc];
}
@end
