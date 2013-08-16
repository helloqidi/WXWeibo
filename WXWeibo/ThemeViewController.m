//
//  ThemeViewController.m
//  WXWeibo
//
//  Created by 张 启迪 on 13-8-16.
//  Copyright (c) 2013年 张 启迪. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeManager.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.themes=[[ThemeManager shareInstance].themesPlist allKeys];
    }
    return self;
}

- (void)viewDidLoad
{
    self.tableView=[[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight-49) style:UITableViewStylePlain] autorelease];
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
    }
    cell.textLabel.text=self.themes[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *themeName=self.themes[indexPath.row];
    [ThemeManager shareInstance].themeName=themeName;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:themeName];
}


#pragma mark - dealloc/memoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
