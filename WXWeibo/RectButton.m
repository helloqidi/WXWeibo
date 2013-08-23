//
//  RectButton.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-23.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "RectButton.h"

@implementation RectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        [_title release];
        _title = [title copy];
    }
    
    if (self.rectTitleLabel == nil) {
        self.rectTitleLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0, 30, 70, 30)] autorelease];
        self.rectTitleLabel.backgroundColor=[UIColor clearColor];
        self.rectTitleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.rectTitleLabel.textColor = [UIColor blackColor];
        self.rectTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.rectTitleLabel];
    }
    self.rectTitleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    if (_subtitle != subtitle) {
        [_subtitle release];
        _subtitle = [subtitle copy];
    }
    
    
    if (self.subtitleLabel == nil) {
        self.subtitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 70, 25)] autorelease];
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.font = [UIFont systemFontOfSize:18.0f];
        self.subtitleLabel.textColor = [UIColor blueColor];
        self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.subtitleLabel];
    }
    self.subtitleLabel.text = subtitle;

}


- (void)dealloc
{
    self.rectTitleLabel=nil;
    self.subtitleLabel=nil;
    self.title=nil;
    self.subtitle=nil;
    [super dealloc];
}

@end
