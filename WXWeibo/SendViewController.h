//
//  SendViewController.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-26.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"

@interface SendViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,retain)UITextView *textView;
//键盘上方的工具栏
@property(nonatomic,retain)UIView *editorBar;

//工具栏中的按钮数组
@property(nonatomic,retain)NSMutableArray *buttons;

//经度
@property(nonatomic,copy)NSString *longitude;
//维度
@property(nonatomic,copy)NSString *latitude;

@property(nonatomic,retain)UIView *placeView;
@property(nonatomic,retain)UILabel *placeLabel;

@property(nonatomic,retain)UIImage *sendImage;

@property(nonatomic,retain)UIButton *sendImageButton;

@property(nonatomic,retain)UIImageView *fullImageView;

@end
