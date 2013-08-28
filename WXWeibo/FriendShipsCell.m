//
//  FriendShipsCell.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-27.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "FriendShipsCell.h"
#import "UserGridView.h"
#import "UserModel.h"

@implementation FriendShipsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}


- (void)initViews
{
    //3个子视图
    for (int i=0; i<3; i++) {
        UserGridView *gridView=[[[UserGridView alloc] initWithFrame:CGRectZero] autorelease];
        gridView.tag=2013+i;
        [self.contentView addSubview:gridView];
    }

}

//针对cell复用时，当当前cell中的gridView没有时仍复用，导致仍然显示的情况。
//先隐藏所有的gridView，当有数据时才显示出来。
- (void)setData:(NSArray *)data {
    if (_data != data) {
        [_data release];
        _data = [data retain];
    }
    
    for (int i=0; i<3; i++) {
        UserGridView *userGridView = (UserGridView *)[self.contentView viewWithTag:2013+i];
        userGridView.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i=0; i<self.data.count; i++) {
        UserModel *userModel=[self.data objectAtIndex:i];
        UserGridView *gridView=(UserGridView *)[self.contentView viewWithTag:2013+i];
        gridView.frame=CGRectMake(100*i+12, 10, 0, 0);
        gridView.userModel=userModel;
        
        //结合setData方法(复写)，处理cell复用时发生重复的情况。
        gridView.hidden=NO;
        
        //让gridView 异步调用layoutSubviews. 否则，会发现有重复显示的情况.
        [gridView setNeedsLayout];
    }

}


@end
