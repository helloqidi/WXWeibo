//
//  FaceView.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-27.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "FaceView.h"


//表情区域的宽度
#define item_width  42
//表情区域的高度
#define item_height 45

@implementation FaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        //记录总页数
        self.pageNumber=self.items.count;
        //去掉背景
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}


/*初始化数据
 *
 * 行 row:4
 * 列 colum:7
 * 尺寸 30*30px
 *
 */
/*
 * items=[
 *          ["表情1","表情2"......"表情28"],
 *          ["表情1","表情2"......],
 *          ......
 *      ]
 */
- (void)initData
{
    self.items=[[[NSMutableArray alloc] init] autorelease];
    
    //读取表情数据
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *fileArray=[NSArray arrayWithContentsOfFile:filePath];
    //整理表情
    NSMutableArray *items2D=nil;
    for (int i=0; i<fileArray.count; i++) {
        NSDictionary *item=[fileArray objectAtIndex:i];
        if (i%28==0) {
            items2D=[NSMutableArray arrayWithCapacity:28];
            [self.items addObject:items2D];
        }
        [items2D addObject:item];
    }
    
    //设置尺寸
    self.width=self.items.count*320;    //有多少页
    self.height=4*item_height;  //每页4行
    
    //放大镜
    self.magnifierView=[[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 92)] autorelease];
    self.magnifierView.image=[UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
    self.magnifierView.hidden=YES;
    self.magnifierView.backgroundColor=[UIColor clearColor];
    [self addSubview:self.magnifierView];
    
    
    //表情视图,显示在放大镜视图中
    //注：不能在touch方法中创建，那样每次都会创建一次。最好是只创建一次，通过tag值来查找使用
    UIImageView *faceItem=[[[UIImageView alloc] initWithFrame:CGRectMake((64-30)/2, 15, 30, 30)] autorelease];
    faceItem.backgroundColor=[UIColor clearColor];
    faceItem.tag=2013;
    [self.magnifierView addSubview:faceItem];
    
}


- (void)drawRect:(CGRect)rect
{
    //定义行、列
    int row=0,column=0;
    
    for (int i=0; i<self.items.count; i++) {
        NSArray *items=[self.items objectAtIndex:i];
        for (int j=0; j<items.count; j++) {
            NSDictionary *item=[items objectAtIndex:j];
            
            NSString *imageName=[item objectForKey:@"png"];
            UIImage *image=[UIImage imageNamed:imageName];
            
            //在当前视图的指定坐标上画图片(15是间隙)
            CGRect frame=CGRectMake(column*item_width+i*320+15, row*item_height+15, 30, 30);
            [image drawInRect:frame];
            
            //更新行、列
            column++;
            if (column%7==0) {
                row++;
                column=0;
            }
            if (row==4) {
                row=0;
            }
        }
    }
    
}

//计算行、列
- (void)touchFace:(CGPoint)point
{
    //页数
    int page =point.x / 320;
    //获得点击的x坐标(10是测试调整的距离)
    float x=point.x-(page*320)-10;
    float y=point.y-10;
    
    //计算行、列
    int row=y/item_height;
    int colum=x/item_width;
    
    //不能超出数组的范围
    if (row>3) {
        row=3;
    }
    if (row<0) {
        row=0;
    }
    if (colum>6) {
        colum=6;
    }
    if (colum<0) {
        colum=0;
    }
    
    //在数组中的索引index
    int index=colum + row*7;
    
    //取出表情
    NSDictionary *item=[[self.items objectAtIndex:page] objectAtIndex:index];
    NSString *faceName=[item objectForKey:@"chs"];
    
    //同一图片的话，防止重复创建
    if (![self.selectFaceName isEqualToString:faceName] || self.selectFaceName==nil) {
        NSString *imageName=[item objectForKey:@"png"];
        //显示表情
        UIImageView *faceItem=(UIImageView *)[self.magnifierView viewWithTag:2013];
        UIImage *image=[UIImage imageNamed:imageName];
        faceItem.image=image;
        self.selectFaceName=faceName;
        
        //定位放大镜位置（参考表情的定位）
        self.magnifierView.left=colum*item_width+page*320;
        self.magnifierView.bottom=row*item_height+30;
    }    
}

//touch触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.magnifierView.hidden=NO;
    
    //获得touch对象
    UITouch *touch=[touches anyObject];
    //获得触摸的坐标
    CGPoint point=[touch locationInView:self];
    
    [self touchFace:point];
    //NSLog(@"%@",NSStringFromCGPoint(point));
    
    //禁止UIScrollView的移动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView=(UIScrollView *)self.superview;
        scrollView.scrollEnabled=NO;
    }
}

//触摸结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.magnifierView.hidden=YES;
    //开启UIScrollView的移动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView=(UIScrollView *)self.superview;
        scrollView.scrollEnabled=YES;
    }

    //调用block
    if (self.selectBlock!=nil){
        self.selectBlock(self.selectFaceName);
    }
}

//触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{    
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    [self touchFace:point];
}

//触摸取消(某些情况下的触摸取消)
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.magnifierView.hidden=YES;
    //开启UIScrollView的移动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView=(UIScrollView *)self.superview;
        scrollView.scrollEnabled=YES;
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    self.items=nil;
    self.magnifierView=nil;
    self.selectFaceName=nil;
    self.selectBlock=nil;
    [super dealloc];
}


@end
