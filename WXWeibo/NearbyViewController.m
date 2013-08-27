//
//  NearbyViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-26.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "NearbyViewController.h"
#import "UIImageView+WebCache.h"
#import "DataService.h"

@interface NearbyViewController ()

@end

@implementation NearbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //取消按钮
        self.isCancelButton=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title=@"我在这里";
    
    [self _initViews];
    
    self.tableView.hidden=YES;
    
    [super showHUD:@"正在加载..." isDim:NO];
    
    CLLocationManager *locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate=self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager startUpdatingLocation];
}



- (void)_initViews
{
    self.tableView=[[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44) style:UITableViewStylePlain] autorelease];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];

}

#pragma mark - UI
- (void)refreshUI
{
    self.tableView.hidden=NO;
    [super hideHUD];
    
    [self.tableView reloadData];
}

#pragma mark - Data
- (void)loadNearbyDataFinish:(NSDictionary *)result
{
    NSArray *pois=[result objectForKey:@"pois"];
    self.data=pois;
    
    [self refreshUI];
}


#pragma mark -CLLocationManager Delegate
//注：会被多次调用
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    //停止定位
    [manager stopUpdatingLocation];
    
    if (self.data==nil) {
        //精度
        float longitude=newLocation.coordinate.longitude;
        //维度
        float latitude=newLocation.coordinate.latitude;
        NSString *longitudeString=[NSString stringWithFormat:@"%f",longitude];
        NSString *latitudeString=[NSString stringWithFormat:@"%f",latitude];
        
        
        NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:longitudeString,@"long",latitudeString,@"lat", nil];
        /*
        [self.sinaweibo requestWithURL:@"place/nearby/pois.json" params:params httpMethod:@"GET" block:^(id result) {
            [self loadNearbyDataFinish:result];
        }];*/
        [DataService requestWithURL:@"place/nearby/pois.json" params:params httpMethod:@"GET" completeBlock:^(id result) {
            [self loadNearbyDataFinish:result];
        }];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location error:%@",error);
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify] autorelease];
    }
    
    //数据
    NSDictionary *dic=[self.data objectAtIndex:indexPath.row];
    NSString *title=[dic objectForKey:@"title"];
    NSString *address=[dic objectForKey:@"address"];
    NSString *icon=[dic objectForKey:@"icon"];
    
    cell.textLabel.text=title;
    cell.detailTextLabel.text=address;
    [cell.imageView setImageWithURL:[NSURL URLWithString:icon]];
    
    return cell;
}

//调整高度
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock!=nil) {
        NSDictionary *dic=self.data[indexPath.row];
        self.selectBlock(dic);
        //注：如果调用多次,则不能再次释放block；如果调用一次，则可以在这里释放
        //关闭模态视图
        [self dismissModalViewControllerAnimated:YES];
    }
}


#pragma mark - dealloc
- (void)dealloc
{
    self.tableView=nil;
    self.data=nil;
    self.selectBlock=nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
