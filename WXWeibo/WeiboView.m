//
//  WeiboView.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-19.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "WeiboView.h"
#import "UIFactory.h"
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"


//列表中微博内容字体
#define LIST_FONT   14.0f
//列表中转发的微博内容字体
#define LIST_REPOST_FONT    13.0f
//详情微博内的内容字体
#define DETAIL_FONT   18.0f
//详情微博内转发的微博内容字体
#define DETAIL_REPOST_FONT    17.0f



@implementation WeiboView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
        self.parseText=[[NSMutableString alloc] initWithCapacity:1];
    }
    return self;
}


//初始化子视图
- (void)_initView
{
    //在layoutSubviews中实现布局，此处不实现
    self.textLabel=[[[RTLabel alloc] initWithFrame:CGRectZero] autorelease];
    self.textLabel.delegate=self;
    self.textLabel.font=[UIFont systemFontOfSize:14.0f];
    
    //也可以通过三色值来制定颜色
    self.textLabel.linkAttributes=[NSDictionary dictionaryWithObject:@"red" forKey:@"color"];
    self.textLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
    [self addSubview:self.textLabel];
    
    
    //微博图片
    self.image=[[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    self.image.backgroundColor=[UIColor clearColor];
    //默认图片,与主题无关
    self.image.image=[UIImage imageNamed:@"page_image_loading.png"];
    //设置图片的内容显示模式：等比例缩/放（不会被拉伸或压缩）
    self.image.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:self.image];

    //转发的微博的背景图片
    self.repostBackgroundView=[UIFactory createImageView:@"timeline_retweet_background.png"];
    //背景图片需要拉伸
    UIImage *image=[self.repostBackgroundView.image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
    self.repostBackgroundView.image=image;
    self.repostBackgroundView.leftCapWidth=25;
    self.repostBackgroundView.topCapHeight=10;
    self.repostBackgroundView.backgroundColor=[UIColor clearColor];
    //背景层在最底下，使用insertSubview而不是addSubview
    [self insertSubview:self.repostBackgroundView atIndex:0];
    
    //转发的微博视图不能在此创建,否则会出现死循环！！
    
}

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    if (_weiboModel!=weiboModel) {
        [_weiboModel release];
        _weiboModel=[weiboModel retain];
    }
    
    //创建转发微博视图
    //注：不能在_initView(被initWithFrame调用)中创建！！
    if(self.repostView==nil){
        self.repostView=[[[WeiboView alloc] initWithFrame:CGRectZero] autorelease];
        self.repostView.isRepost=YES;
        [self addSubview:self.repostView];
    }
    
    [self parseLink];
}

//解析超链接
- (void)parseLink
{
    //存储转换链接后的字符串。
    //注：每次都要清空，防止cell复用时self.parsetText被不断追加
    self.parseText=[[NSMutableString alloc] initWithString:@""];
    
    //获得微博内容
    NSMutableString *textMut=[[[NSMutableString alloc] initWithString:self.weiboModel.text] autorelease];
    
    //判断当前微博是否是被转发的微博
    if (self.isRepost) {
        //将微博作者拼接
        NSString *userName=self.weiboModel.user.name;
        [textMut insertString:[NSString stringWithFormat:@"@%@: ",userName] atIndex:0];
    }
    
    //由NSMutableString转换回NSString，以方面使用stringByReplacingOccurrencesOfString方法
    NSString *text=[[[NSString alloc] initWithString:textMut] autorelease];
    
    //正则表达式
    //注：OC里面的'\'是转义符
    NSString *regex=@"(@\\w+)|(#\\w+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";

    NSArray *matchArray=[text componentsMatchedByRegex:regex];
    
    for (NSString *linkString in matchArray) {
        //<a href='user://@用户' ></a>
        //<a href='http://www.baidu.com'>http://www.baidu.com</a>
        //<a href='topic://#话题#'>#话题#</a>
        
        NSString *replacing=nil;
        if ([linkString hasPrefix:@"@"]) {
            replacing=[NSString stringWithFormat:@"<a href='user://%@'>%@</a>",[linkString URLEncodedString],linkString];
        }else if ([linkString hasPrefix:@"http"]){
            replacing=[NSString stringWithFormat:@"<a href='%@'>%@</a>",linkString,linkString];
        }else if ([linkString hasPrefix:@"#"]){
            replacing=[NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",[linkString URLEncodedString],linkString];
        }
        
        
        if (replacing!=nil) {
            text=[[text stringByReplacingOccurrencesOfString:linkString withString:replacing] mutableCopy];
        }
    }
    
    [self.parseText appendString:text];

}


//展示数据，设置子视图布局
//注：layoutSubviews 可能会被调用多次，所有正则解析数据(或加载数据等费时操作)不能放在这里
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //----微博内容----
    //获取字体大小
    float fontSize=[WeiboView getFontSize:self.isDetail isRepost:self.isRepost];
    //判断是否为转发视图
    if (self.isRepost) {
        self.textLabel.frame=CGRectMake(10,10,self.width-20,0);
    }else{
        self.textLabel.frame=CGRectMake(0,0,self.width,20);
    }
    //self.textLabel.text=self.weiboModel.text;
    self.textLabel.text=self.parseText;
    
    self.textLabel.font=[UIFont systemFontOfSize:fontSize];
    //内容的size
    CGSize textsize=self.textLabel.optimumSize;
    self.textLabel.height=textsize.height;
    
    //----转发的微博内容----
    WeiboModel *repostWeibo=self.weiboModel.relWeibo;
    if (repostWeibo!=nil) {
        self.repostView.weiboModel=repostWeibo;
        
        float height =[WeiboView getWeiboViewHeight:repostWeibo isRepost:YES isDetail:self.isDetail];
        self.repostView.frame=CGRectMake(0, self.textLabel.bottom, self.width,height);
        self.repostView.hidden=NO;
    }else{
        self.repostView.hidden=YES;
    }
    
    //----微博图片视图----
    if (self.isDetail) {
        //中等图
        NSString *bmiddleImage=self.weiboModel.bmiddleImage;
        if (bmiddleImage!=nil && ![bmiddleImage isEqualToString:@"" ]) {
            self.image.hidden=NO;
            self.image.frame=CGRectMake(10, self.textLabel.bottom+10, 280, 200);
            
            //加载网络图片
            [self.image setImageWithURL:[NSURL URLWithString:bmiddleImage]];
        }else{
            self.image.hidden=YES;
        }
    }else{
        //缩略图
        NSString *thumbnailImage=self.weiboModel.thumbnailImage;
        if (thumbnailImage!=nil && ![thumbnailImage isEqualToString:@"" ]) {
            self.image.hidden=NO;
            self.image.frame=CGRectMake(10, self.textLabel.bottom+10, 70, 80);
            
            //加载网络图片
            [self.image setImageWithURL:[NSURL URLWithString:thumbnailImage]];
        }else{
            self.image.hidden=YES;
        }

    }
    
    
    //----转发的微博视图背景----
    if (self.isRepost) {
        self.repostBackgroundView.frame=self.bounds;
        self.repostBackgroundView.hidden=NO;
    }else{
        self.repostBackgroundView.hidden=YES;
    }
}


+ (float)getWeiboViewHeight:(WeiboModel *)weiboModel isRepost:(BOOL)isRepost isDetail:(BOOL)isDetail
{
    /*
     *  计算每个子视图的高度，然后相加
     */
    
    float height=0;
    
    
    //----计算微博内容的高度----
    RTLabel *textLabel=[[[RTLabel alloc] initWithFrame:CGRectZero] autorelease];
    float fontsize=[WeiboView getFontSize:isDetail isRepost:isRepost];
    textLabel.font=[UIFont systemFontOfSize:fontsize];
    
    //是否是详情
    if (isDetail) {
        textLabel.width=kWeibo_Width_Detail;
    }else{
        textLabel.width=kWeibo_Width_List;
    }
    if (isRepost) {
        textLabel.width -= 20;
    }
    
    NSMutableString *textMut=[[[NSMutableString alloc] initWithString:weiboModel.text] autorelease];
    if (isRepost) {
        //将微博作者拼接上去
        NSString *userName=weiboModel.user.name;
        [textMut insertString:[NSString stringWithFormat:@"@%@: ",userName] atIndex:0];
    }
    textLabel.text=[[[NSString alloc] initWithString:textMut] autorelease];
    
    height += textLabel.optimumSize.height;

    //----计算微博图片的高度----
    if (isDetail) {
        NSString *bmiddleImage=weiboModel.bmiddleImage;
        if (bmiddleImage!=nil && ![bmiddleImage isEqualToString:@"" ]) {
            height += (200+10);
        }
    }else{
        NSString *thumbnailImage=weiboModel.thumbnailImage;
        if (thumbnailImage!=nil && ![thumbnailImage isEqualToString:@"" ]) {
            height += (80+10);
        }    
    }

    
    
    //----计算转发微博的的高度----
    WeiboModel *relWeibo=weiboModel.relWeibo;
    if (relWeibo!=nil) {
        //转发微博视图的高度
        float repostHeight = [WeiboView getWeiboViewHeight:relWeibo isRepost:YES isDetail:isDetail];
        height += repostHeight;
    }
    
    if (isRepost==YES) {
        height+=30;
    }
    
    return height;
}

+ (float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost
{
    float fontSize=14.0f;
    if (!isDetail && !isRepost) {
        return LIST_FONT;
    }else if (!isDetail && isRepost){
        return LIST_REPOST_FONT;
    }else if (isDetail && !isRepost){
        return  DETAIL_FONT;
    }else if (isDetail && isRepost){
        return DETAIL_REPOST_FONT;
    }
    
    
    return fontSize;
}


#pragma mark - RTLabe Delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSString *absoluteString=[url absoluteString];
    if([absoluteString hasPrefix:@"user"]){
        NSString *urlString=[url host];
        urlString=[urlString URLDecodedString];
        NSLog(@"用户:%@",urlString);
    }else if ([absoluteString hasPrefix:@"http"]){
        NSLog(@"链接:%@",absoluteString);
    }else if ([absoluteString hasPrefix:@"topic"]){
        NSString *urlString=[url host];
        urlString=[urlString URLDecodedString];
        NSLog(@"话题:%@",urlString);
    }
    
    
    
}

#pragma mark - dealloc/memoryWarning
- (void)dealloc
{
    self.weiboModel=nil;
    self.repostView=nil;
    self.repostBackgroundView=nil;
    self.textLabel=nil;
    self.image=nil;
    self.parseText=nil;
    [super dealloc];
}

@end