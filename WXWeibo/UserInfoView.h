//
//  UserInfoView.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-23.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "RectButton.h"

@interface UserInfoView : UIView

@property(nonatomic,retain)UserModel *userModel;


//头像
@property(nonatomic,retain)UIImageView *userImage;
//昵称
@property(nonatomic,retain)UILabel *nickLabel;
//地址
@property(nonatomic,retain)UILabel *addressLabel;
//简介
@property(nonatomic,retain)UILabel *briefLabel;
//关注按钮
@property(nonatomic,retain)RectButton *followBtn;
//粉丝按钮
@property(nonatomic,retain)RectButton *fansBtn;
//资料按钮
@property(nonatomic,retain)RectButton *profileBtn;
//更多按钮
@property(nonatomic,retain)RectButton *moreBtn;
//微博总数量
@property(nonatomic,retain)UILabel *weiboCntLabel;


@end
