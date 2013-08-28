//
//  NearWeiboMapViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-28.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "NearWeiboMapViewController.h"
#import "DataService.h"
#import "WeiboModel.h"


@interface NearWeiboMapViewController ()

@end

@implementation NearWeiboMapViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView=[[[MKMapView alloc] initWithFrame:self.view.bounds] autorelease];
    self.mapView.delegate=self;

    //定位
    CLLocationManager *locationManager=[[[CLLocationManager alloc] init] autorelease];
    //设置精度
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
    
}


- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    
    CLLocationCoordinate2D coordinate=newLocation.coordinate;
    
    if (self.data==nil) {
        NSString *lon=[NSString stringWithFormat:@"%f",coordinate.longitude];
        NSString *lat=[NSString stringWithFormat:@"%f",coordinate.latitude];
        [self loadNearWeiboData:lon latitude:lat];
    }

}

- (void)loadNearWeiboData:(NSString *)lon latitude:(NSString *)lat
{
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:lon,@"long",lat,@"lat", nil];
    [DataService requestWithURL:@"place/nearby_timeline.json" params:params httpMethod:@"GET" completeBlock:^(id result) {
        [self loadNearWeiboDataFinish:result];
    }];

}

- (void)loadNearWeiboDataFinish:(NSDictionary *)result
{
    NSArray *statuses=[result objectForKey:@"statuses"];
    NSMutableArray *weibos=[NSMutableArray arrayWithCapacity:statuses.count];
    
    for (NSDictionary *statuesDic in statuses) {
        WeiboModel *weibo=[[[WeiboModel alloc] initWithDataDic:statuesDic] autorelease];
        [weibos addObject:weibo];
        
        //创建Anatation对象，添加到地图上去
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
