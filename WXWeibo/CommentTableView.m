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

//cell高度
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *commentModel=self.data[indexPath.row];
    float h=[CommentCell getCommentHeight:commentModel];
    return h;
}

//section高度
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)] autorelease];
    view.backgroundColor=[UIColor whiteColor];
    
    //评论数量
    UILabel *countlabel=[[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)] autorelease];
    countlabel.backgroundColor=[UIColor clearColor];
    countlabel.font=[UIFont boldSystemFontOfSize:16.0f];
    countlabel.textColor=[UIColor blueColor];
    NSNumber *total=[self.commentDic objectForKey:@"total_number"];
    countlabel.text=[NSString stringWithFormat:@"评论:%@",total];
    [view addSubview:countlabel];
    
    //间隔横线
    UIImageView *separatorImage=[[[UIImageView alloc] initWithFrame:CGRectMake(0, 40-1, tableView.width, 1)] autorelease];
    separatorImage.image=[UIImage imageNamed:@"userinfo_header_separator.png"];
    [view addSubview:separatorImage];
    
    return view;
}




@end
