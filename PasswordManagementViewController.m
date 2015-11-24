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

#import "SecurityQuestionManagementViewController.h"


#import "TapGestureMaskView.h"
@interface PasswordManagementViewController ()

@end

@implementation PasswordManagementViewController
@synthesize willModifyTapsGesrure;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"SecuritySettings", nil);
    
    NSLog(@"the change");
    willModifyTapsGesrure = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.GameBranch = YES;
    self.mm_drawerController.GameIsCenter = NO;
    if (willModifyTapsGesrure) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"TapGestureMaskView" owner:self options:nil];
        TapGestureMaskView *maskView1 = [nibs firstObject];
        [maskView1 setFrame:CGRectMake(0, 0, mainScreenSize.width, mainScreenSize.height)];
        //maskView1.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        [self.view addSubview:maskView1];
        [self.view bringSubviewToFront:maskView1];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    willModifyTapsGesrure = NO;
    [super viewWillDisappear:animated];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"UpdateSecurity"]) {
        SecurityQuestionManagementViewController *destination = segue.destinationViewController;
        destination.securityType = UpdateSecurity;
    }
}


- (IBAction)updateCurrentPassword:(id)sender {
    //BOOL isMain= [TooManager currentPasswordIsMainPassword];

    //SecurityViewController *securityViewController = [[SecurityViewController alloc]initWithType:LockViewTypeUpdate isMainPassword:isMain];
    
    SecurityViewController *securityViewController = [[SecurityViewController alloc]initWithType:LockViewTypeUpdate];
    [self.navigationController pushViewController:securityViewController animated:YES];
}

- (IBAction)settingTapGesture:(id)sender {
    
    //BOOL isMain= [TooManager currentPasswordIsMainPassword];;
    
   // SecurityViewController *securityViewController = [[SecurityViewController alloc]initWithType:LockViewTypeUpdate isMainPassword:NO];
    
    SecurityViewController *securityViewController =[[SecurityViewController alloc]initWithType:LockViewTypeCheck];
    
    //securityViewController.currentPasswordIsMain = isMain;
    [self.navigationController pushViewController:securityViewController animated:YES];
}

- (IBAction)updateSecurity:(id)sender {
    [self performSegueWithIdentifier:@"UpdateSecurity" sender:self];
}
@end
