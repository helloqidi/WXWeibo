//
//  BrowModeController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-23.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "BrowModeController.h"
#import "UIFactory.h"

@interface BrowModeController ()

@end

@implementation BrowModeController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"图片浏览模式";
        
        self.modes=[NSArray arrayWithObjects:@"小图",@"大图", nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView=[[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-20-44) style:UITableViewStylePlain] autorelease];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView Degelate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"modeCell";
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        UILabel *textLabel=[UIFactory createLabel:kThemeListLabel];
        textLabel.frame=CGRectMake(10, 10, 200, 30);
        textLabel.backgroundColor=[UIColor clearColor];
        textLabel.font=[UIFont boldSystemFontOfSize:16.0f];
        textLabel.tag=2013;
        [cell.contentView addSubview:textLabel];
    }
    //cell.textLabel.text=self.themes[indexPath.row];
    
    UILabel *textLabel=(UILabel *)[cell.contentView viewWithTag:2013];
    NSString *textName=self.modes[indexPath.row];
    textLabel.text=textName;
    
    int nowMode=1;
    if (indexPath.row==0) {
        nowMode=1;
    }else if (indexPath.row==1){
        nowMode=2;
    }
    
    int mode=[[NSUserDefaults standardUserDefaults] integerForKey:kModeName];
    if (mode==nowMode) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    return cell;
}

//切换主题
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int mode=-1;
    if (indexPath.row==0) {
        mode=SmallBrowMode;
    }else if (indexPath.row==1){
        mode=LargeBrowMode;
    }
    
    //保存主题到本地
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kModeName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //刷新微博列表
    //注：这种场景下，HomeViewController与BrowModeController完全扯不上关系，不能使用delegate,或者block。只能使用通知。
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboTableNotification object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - dealloc/memoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
