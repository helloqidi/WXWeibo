//
//  CommentCell.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-22.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "CommentModel.h"

@interface CommentCell : UITableViewCell<RTLabelDelegate>

@property(nonatomic,retain)UIImageView *userImage;
@property(nonatomic,retain)UILabel *nickLabel;
@property(nonatomic,retain)UILabel *timeLabel;
@property(nonatomic,retain)RTLabel *contentLabel;

@property(nonatomic,retain)CommentModel *commentModel;

//计算评论单元格高度
+ (float)getCommentHeight:(CommentModel *)commentModel;

@end
