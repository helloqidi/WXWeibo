//
//  ThemeViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-16.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeManager.h"
#import "UIFactory.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"主题切换";
        
        self.themes=[[ThemeManager shareInstance].themesPlist allKeys];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView=[[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight-49-20-44) style:UITableViewStylePlain] autorelease];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView Degelate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.themes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"themeCell";
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
    NSString *textName=self.themes[indexPath.row];
    textLabel.text=textName;
    
    NSString *themeName=[ThemeManager shareInstance].themeName;
    if (themeName==nil) {
        themeName=@"默认";
    }
    if ([textName isEqualToString:themeName]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    return cell;
}

//切换主题
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *themeName=self.themes[indexPath.row];
    if ([themeName isEqualToString:@"默认"]) {
        themeName=nil;
    }
    
    //保存主题到本地
    [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:kThemeName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [ThemeManager shareInstance].themeName=themeName;
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:themeName];
    
    //刷新
    [self.tableView reloadData];
}


#pragma mark - dealloc/memoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
