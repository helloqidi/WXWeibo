//
//  CommentTableView.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-22.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentCell.h"

@implementation CommentTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
    }
    return self;
}


#pragma mark - UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *identifier=@"CommentCell";
    CommentCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        //没有选中效果
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    CommentModel *commentModel=self.data[indexPath.row];
    cell.commentModel=commentModel;
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *commentModel=self.data[indexPath.row];
    float h=[CommentCell getCommentHeight:commentModel];
    return h;
}

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
