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
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"


@interface NearWeiboMapViewController ()

@end

@implementation NearWeiboMapViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView=[[[MKMapView alloc] init] autorelease];
    self.mapView.frame=self.view.bounds;
    self.mapView.delegate=self;
    self.mapView.showsUserLocation=YES;
    self.mapView.mapType=MKMapTypeStandard;
    [self.view addSubview:self.mapView];

    //定位
    CLLocationManager *locationManager=[[CLLocationManager alloc] init];
    //设置精度
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
    
}

#pragma mark - CLLocationManager Delegate

//定位的代理方法
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    
    CLLocationCoordinate2D coordinate=newLocation.coordinate;
    
    //显示当前区域
    MKCoordinateSpan span={0.1,0.1};
    MKCoordinateRegion region={coordinate,span};
    [self.mapView setRegion:region animated:YES];
    
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
    
    for (int i=0;i<statuses.count;i++) {
        NSDictionary *statuesDic=[statuses objectAtIndex:i];
        WeiboModel *weibo=[[[WeiboModel alloc] initWithDataDic:statuesDic] autorelease];
        [weibos addObject:weibo];
        
        //创建Anatation对象，添加到地图上去
        WeiboAnnotation *weiboAnnotation=[[[WeiboAnnotation alloc] initWithWeibo:weibo] autorelease];
        //延迟调用,可形成一个一个添加到地图上的动画效果
        [self.mapView performSelector:@selector(addAnnotation:) withObject:weiboAnnotation
                           afterDelay:i*0.05];
        //[self.mapView addAnnotation:weiboAnnotation];
        
    }
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    //判断是否是获得当前位置。如果是，则返回nil，让系统自己创建
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    //在地图上为 annotation 显示WeiboAnnotationView视图
    static NSString *identify=@"WeiboAnnotationView";
    WeiboAnnotationView *annotationView=(WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identify];
    if (annotationView==nil){
        annotationView=[[[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identify] autorelease];
    }
    return annotationView;

}

//添加在mapView后会调用这个方法。可用于实现动画效果
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (UIView *annotationView in views) {
        //动画：先从0.7--到1.2；在从1.2--到1；形成气泡的效果
        //原始的transform
        CGAffineTransform transform=annotationView.transform;
        annotationView.transform=CGAffineTransformScale(transform, 0.7, 0.7);
        annotationView.alpha=0;
        
        [UIView animateWithDuration:0.4 animations:^{
            //动画1
            annotationView.transform=CGAffineTransformScale(transform, 1.3, 1.3);
            annotationView.alpha=1;
        } completion:^(BOOL finished) {
            //动画2
            [UIView animateWithDuration:0.4 animations:^{
                //恢复到原始大小
                annotationView.transform=CGAffineTransformIdentity;
            }];
        }];
    }

}

#pragma mark - dealloc
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
