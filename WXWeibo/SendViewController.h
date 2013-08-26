//
//  SendViewController.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-26.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"

@interface SendViewController : BaseViewController

@property(nonatomic,retain)UITextView *textView;
@property(nonatomic,retain)UIView *editorBar;

@property(nonatomic,retain)NSMutableArray *buttons;

//经度
@property(nonatomic,copy)NSString *longitude;
//维度
@property(nonatomic,copy)NSString *latitude;

@property(nonatomic,retain)UIView *placeView;
@property(nonatomic,retain)UILabel *placeLabel;

@end
