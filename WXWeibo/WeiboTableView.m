//
//  WeiboTableView.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-20.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "DetailViewController.h"

@implementation WeiboTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self=[super initWithFrame:frame style:style];
    if (self!=nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kReloadWeiboTableNotification object:nil];
    }
    return self;
}


#pragma mark - UITableView Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //WeiboCell *cell=[[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    static NSString *identifier=@"WeiboCell";
    WeiboCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    WeiboModel *weibo=self.data[indexPath.row];
    //WeiboModel *weiboModel=[self.data objectAtIndex:indexPath.row];
    cell.weiboModel=weibo;
    
    return cell;
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //此方法中不能得到cell,如下语句会报错,形成死循环
    //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    WeiboModel *weibo=self.data[indexPath.row];
    float height=[WeiboView getWeiboViewHeight:weibo isRepost:NO isDetail:NO];
    //留出昵称、创建时间、来源的高度
    height += 60;
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboModel *weibo=[self.data objectAtIndex:indexPath.row];
    DetailViewController *detail=[[[DetailViewController alloc] init] autorelease];
    detail.weiboModel=weibo;
    //利用自定义的类方法viewController获得视图的上级控制器
    [self.viewController.navigationController pushViewController:detail animated:YES];

    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReloadWeiboTableNotification object:nil];
    [super dealloc];
}

@end
