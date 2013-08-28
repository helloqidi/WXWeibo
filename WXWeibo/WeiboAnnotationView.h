//
//  WeiboAnnotationView.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-28.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WeiboAnnotationView : MKAnnotationView

@property(nonatomic,retain)UIImageView *userImage;
@property(nonatomic,retain)UIImageView *weiboImage;
@property(nonatomic,retain)UILabel *textLabel;


@end
