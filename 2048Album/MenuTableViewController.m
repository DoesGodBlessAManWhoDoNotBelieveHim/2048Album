//
//  MenuTableViewController.m
//  2048Album
//
//  Created by Jzhang on 14-10-24.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "MenuTableViewController.h"


@interface MenuTableViewController (){
    NSArray *dataSource;
    BOOL gaming;
}

@end

@implementation MenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Arial" size:21],
      NSFontAttributeName, nil]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.showMenu_ing = YES;
    self.mm_drawerController.GameIsCenter = NO;
    if ([NSStringFromClass([self.mm_drawerController.centerViewController class])isEqualToString:@"GameNavigationViewController"] ) {
        dataSource = @[NSLocalizedString(@"LeaderBoard", nil),NSLocalizedString(@"Guide", nil),NSLocalizedString(@"FeedBack", nil),NSLocalizedString(@"About", nil)];
        gaming = YES;
    }
    else{
        dataSource = @[NSLocalizedString(@"SecuritySettings", nil),NSLocalizedString(@"Guide", nil),NSLocalizedString(@"Rate", nil),NSLocalizedString(@"CheckVersion", nil),NSLocalizedString(@"About", nil),NSLocalizedString(@"BackToGame", nil)/*,NSLocalizedString(@"About"@"密码管理",@"功能介绍",@"给个评价",@"检查更新",@"关于",@"返回游戏"*/];
        gaming = NO;
    }
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.mm_drawerController.showMenu_ing = NO;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    cell.textLabel.text = dataSource[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:20.0f];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    if (gaming) {
        switch (indexPath.row) {
            case 0:
                [[NSNotificationCenter defaultCenter]postNotificationName:kLeaderBoardNotification object:nil userInfo:nil];
                break;
            case 1:
                [[NSNotificationCenter defaultCenter]postNotificationName:kGuideNotification object:nil userInfo:nil];
                break;
            case 2:
                [[NSNotificationCenter defaultCenter]postNotificationName:kFeedbackNotification object:nil userInfo:nil];
                break;
            case 3:
                [[NSNotificationCenter defaultCenter]postNotificationName:kAboutNotification object:nil userInfo:nil];
                break;
            default:
                break;
        }
        
    }
    else{//[@"密码管理",@"功能介绍",@"给个评价",@"检查更新",@"关于",@"返回游戏"]
        switch (indexPath.row) {
            case 0:
                [[NSNotificationCenter defaultCenter]postNotificationName:kPasswordManagementNotification object:nil userInfo:nil];
                break;
            case 1:
                [[NSNotificationCenter defaultCenter]postNotificationName:kFunctionIntroduceNotification object:nil userInfo:nil];
                break;
            case 2:
                //评分
                break;
            case 3:
                [[NSNotificationCenter defaultCenter]postNotificationName:kVersionUpdateNotification object:nil userInfo:nil];
                break;
            case 4:
                [[NSNotificationCenter defaultCenter]postNotificationName:kAboutAlbumNotification object:nil userInfo:nil];
                break;
            case 5:{
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate show2048GameViewController];
            }
                break;
            default:
                break;
        }
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
