//
//  SendViewController.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-26.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"
#import "FaceScrollView.h"

@interface SendViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate>

@property(nonatomic,retain)UITextView *textView;
//键盘上方的工具栏
@property(nonatomic,retain)UIView *editorBar;

//工具栏中的按钮数组
@property(nonatomic,retain)NSMutableArray *buttons;

//经度
@property(nonatomic,copy)NSString *longitude;
//维度
@property(nonatomic,copy)NSString *latitude;

//定位信息的显示视图
@property(nonatomic,retain)UIView *placeView;
@property(nonatomic,retain)UILabel *placeLabel;

//存储用户选择后的图片
@property(nonatomic,retain)UIImage *sendImage;

//缩略图按钮
@property(nonatomic,retain)UIButton *sendImageButton;

//图片的全屏视图
@property(nonatomic,retain)UIImageView *fullImageView;

//表情视图
@property(nonatomic,retain)FaceScrollView *faceView;

@end
