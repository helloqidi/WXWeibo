//
//  NearWeiboMapViewController.h
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-28.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NearWeiboMapViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property(nonatomic,retain)NSArray *data;
@property(nonatomic,retain)MKMapView *mapView;

@end
