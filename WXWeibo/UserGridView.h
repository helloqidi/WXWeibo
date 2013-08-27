//
//  UserGridView.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-27.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserGridView : UIView

@property(nonatomic,retain)UserModel *userModel;
@property(nonatomic,retain)UIImageView *backgroundImageView;
@property(nonatomic,retain)UILabel *nickLabel;
@property(nonatomic,retain)UILabel *fansLabel;
@property(nonatomic,retain)UIButton *imageButton;

@end
