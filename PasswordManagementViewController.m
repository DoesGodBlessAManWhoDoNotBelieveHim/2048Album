//
//  PasswordManagementViewController.m
//  2048Album
//
//  Created by Jzhang on 14-12-29.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "PasswordManagementViewController.h"
#import "SecurityViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "PasswordInfo.h"
@interface PasswordManagementViewController ()

@end

@implementation PasswordManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.GameBranch = YES;
    self.mm_drawerController.GameIsCenter = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)updateCurrentPassword:(id)sender {
    BOOL isMain= [TooManager currentPasswordIsMainPassword];

    SecurityViewController *securityViewController = [[SecurityViewController alloc]initWithType:LockViewTypeUpdate isMainPassword:isMain];
    [self.navigationController pushViewController:securityViewController animated:YES];
}

- (IBAction)settingPseudoPassword:(id)sender {

    BOOL isMain= [TooManager currentPasswordIsMainPassword];;
    
    SecurityViewController *securityViewController = [[SecurityViewController alloc]initWithType:LockViewTypeUpdate isMainPassword:NO];
    
    securityViewController.currentPasswordIsMain = isMain;
    [self.navigationController pushViewController:securityViewController animated:YES];
}
@end
