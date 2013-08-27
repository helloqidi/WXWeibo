//
//  FriendShipsTableView.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-27.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "FriendShipsTableView.h"
#import "FriendShipsCell.h"

@implementation FriendShipsTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    [super initWithFrame:frame style:style];
    if (self!=nil) {
        //去掉分割线
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return  self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"gridCell";
    FriendShipsCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell=[[[FriendShipsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        //不需要选中效果
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    //填充数据
    NSArray *array=[self.data objectAtIndex:indexPath.row];
    cell.data=array;
    
    return cell;
}

//cell的高度
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

@end
