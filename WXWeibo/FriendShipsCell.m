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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i=0; i<self.data.count; i++) {
        UserModel *userModel=[self.data objectAtIndex:i];
        UserGridView *gridView=(UserGridView *)[self.contentView viewWithTag:2013+i];
        gridView.frame=CGRectMake(100*i, 10, 0, 0);
        gridView.userModel=userModel;
    }

}


@end
