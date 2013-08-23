//
//  InterfaceImageView.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-23.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "InterfaceImageView.h"

@implementation InterfaceImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGesture=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)] autorelease];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}


- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    if (self.touchBlock) {
        self.touchBlock();
    }
}

- (void)dealloc
{
    self.touchBlock=nil;
    [super dealloc];
}

@end
