//
//  SecurityViewController.m
//  2048Album
//
//  Created by Jzhang on 14-12-8.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "SecurityViewController.h"
#import "PasswordInfo.h"

#import "SecurityQuestionManagementViewController.h"
#import "PasswordManagementViewController.h"

@interface SecurityViewController ()<LLLockDelegate,FileManagerDelegate>{
    int nRetryTimesRemain; // 剩余几次输入机会
    
    NSMutableArray *savedPasswords;
    
    //PasswordInfo *currentPasswordInfo;
    NSString *curPard;
    
    NSString *newPassword;
    
    BOOL confirm;
}

@end

@implementation SecurityViewController
@synthesize tipLabel,indicatorView,lockView,buttomButton,buttomButtonTopSpaceToLockView,tipLabelTopSpaceToIndicator;

@synthesize lockViewType;

- (id)initWithType:(LockViewType)type{
    if (self = [super init]) {
        lockViewType = type;
        if (lockViewType!=LockViewTypeLogin) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            curPard = appDelegate.password;
        }
    }
    return self;
}
/*
- (id)initWithType:(LockViewType)type isMainPassword:(BOOL)isMainPassword{
    if (self = [super init]) {
        lockViewType = type;
        _isMainPassword = isMainPassword;
    }
    return self;
}
*/
- (IBAction)buttomButtonAction:(id)sender {
    if ([buttomButton.titleLabel.text isEqualToString:NSLocalizedString(@"ForgotPassword", nil)]) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        SecurityQuestionManagementViewController *securityQuestion = [appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"SecurityQuestionManagementViewController"];
        securityQuestion.securityType = ForgetPassword;
        [self.navigationController pushViewController:securityQuestion animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"GesturePassword", nil);
    if (mainScreenSize.height>480){
        tipLabelTopSpaceToIndicator.constant = 15;
        buttomButtonTopSpaceToLockView.constant = 10;
    }
    lockView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    LKDBHelper *globalHelper = [AppDelegate getUsingLKDBHelper];
    /*
    if(lockViewType == LockViewTypeUpdate){//修改密码
     
        if (self.isMainPassword) {
            currentPasswordInfo = [globalHelper searchSingle:[PasswordInfo class] where:@"isMainPassword='1'" orderBy:nil];
        }
        else{
            currentPasswordInfo = [globalHelper searchSingle:[PasswordInfo class] where:@"isMainPassword='0'" orderBy:nil];
        }
        tipLabel.text = NSLocalizedString(@"Please_input_login_password_first", nil);
        [buttomButton setTitle:@"" forState:UIControlStateNormal];
        buttomButton.enabled = NO;
    }*/
    if(lockViewType == LockViewTypeLogin){// 登陆
        savedPasswords = [[NSMutableArray alloc]initWithArray:[globalHelper search:[PasswordInfo class] column:nil where:nil orderBy:nil offset:0 count:0]];
        tipLabel.text =NSLocalizedString(@"Please_input_correct_password", nil);
        [buttomButton setTitle:NSLocalizedString(@"ForgotPassword", nil) forState:UIControlStateNormal];
        [buttomButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    else{
        tipLabel.text = NSLocalizedString(@"Please_input_login_password_first", nil);
        [buttomButton setTitle:@"" forState:UIControlStateNormal];
        buttomButton.enabled = NO;

    }
    //nRetryTimesRemain = LockRetryTimes;
}

- (void)lockString:(NSString *)string{
    NSLog(@"lockString-->%@",string);
    [indicatorView setPasswordString:string];
    if (lockViewType == LockViewTypeLogin) {
        for (PasswordInfo *tempPassword in savedPasswords) {
            if ([string isEqualToString:tempPassword.password]) {
                [tipLabel setText:NSLocalizedString(@"CorrectPassword", nil)];
                [self.navigationController dismissViewControllerAnimated:NO completion:^{
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    appDelegate.password = string;
                    
                    [appDelegate showAlbum];
                }];
                return;
            }
        }
        //nRetryTimesRemain --;
        //if (nRetryTimesRemain==0) {
            //没有次数了，这时应该消除密码，然后让用户进入密保问题选项。
        //}
        //else{
            [tipLabel setText:NSLocalizedString(@"WrongPassword", nil)];
        //}

    }
    else if (lockViewType == LockViewTypeCheck){
        if ([string isEqualToString:curPard]) {
            // 进入 点击手势修改界面
            //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            PasswordManagementViewController *passManaer =self.navigationController.viewControllers[1];
            //PasswordManagementViewController *passManaer = [appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"PasswordManagementViewController"];
            passManaer.willModifyTapsGesrure = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [tipLabel setText:NSLocalizedString(@"WrongPassword", nil)];
        }
    }
    else{// 修改密码
        if (!newPassword) {//修改状态，首次登陆
            //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if ([string isEqualToString:curPard]) {//密码正确，可以修改了
                [tipLabel setText:NSLocalizedString(@"Input_a_new_password", nil)];
                newPassword = @"";
            }
            else{
                [tipLabel setText:NSLocalizedString(@"Password_Error_Input_New_One", nil)];
            }
            
        }
        else if (newPassword.length==0){
            if (string.length>=4) {
                //confirm = YES;
                newPassword = string;
                [tipLabel setText:NSLocalizedString(@"Draw_Again_Ensure", nil)];
            }
            else{
                [tipLabel setText:NSLocalizedString(@"Try_again_4_numbers_at_least", nil)];
            }
        }
        else{
            if (string.length>=4) {
                if ([newPassword isEqualToString:string]) {
                    [FileManager shareFileManager].delegate = self;
                    [[FileManager shareFileManager]updateCurrentPassword:curPard toNewPassword:newPassword];
                }
                else{
                    newPassword = @"";
                    [tipLabel setText:NSLocalizedString(@"Not_The_Same", nil)];
                    //confirm = NO;
                }
            }
            else{
                newPassword = @"";
                [tipLabel setText:NSLocalizedString(@"Try_again_4_numbers_at_least", nil)];
            }
        }
       
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FileMangerDelegate

- (void)handleUpdateCurrentPassword:(NSString *)currentPassword newPassword:(NSString *)aNewPassword success:(BOOL)success error:(NSError *)error{
    
    if (success) {// show Alert and pop
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //if (!_currentPasswordIsMain) {
            appDelegate.password = aNewPassword;
        //}
    }
    else{
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Modify_Password_Error", nil) message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
