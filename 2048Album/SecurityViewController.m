//
//  SecurityViewController.m
//  2048Album
//
//  Created by Jzhang on 14-12-8.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "SecurityViewController.h"
#import "PasswordInfo.h"

@interface SecurityViewController ()<LLLockDelegate,FileManagerDelegate>{
    int nRetryTimesRemain; // 剩余几次输入机会
    
    NSMutableArray *savedPasswords;
    
    PasswordInfo *currentPasswordInfo;
    
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
    }
    return self;
}

- (id)initWithType:(LockViewType)type isMainPassword:(BOOL)isMainPassword{
    if (self = [super init]) {
        lockViewType = type;
        _isMainPassword = isMainPassword;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"手势密码设置";
    if (mainScreenSize.height>480){
        tipLabelTopSpaceToIndicator.constant = 15;
        buttomButtonTopSpaceToLockView.constant = 10;
    }
    lockView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    LKDBHelper *globalHelper = [AppDelegate getUsingLKDBHelper];
    
    if(lockViewType == LockViewTypeUpdate){
        if (self.isMainPassword) {
            currentPasswordInfo = [globalHelper searchSingle:[PasswordInfo class] where:@"isMainPassword='1'" orderBy:nil];
        }
        else{
            currentPasswordInfo = [globalHelper searchSingle:[PasswordInfo class] where:@"isMainPassword='0'" orderBy:nil];
        }
        tipLabel.text = @"请先输入登陆密码";
        [buttomButton setTitle:@"" forState:UIControlStateNormal];
        buttomButton.enabled = NO;
    }
    else{// 登陆
        savedPasswords = [globalHelper search:[PasswordInfo class] column:nil where:nil orderBy:nil offset:0 count:0];
        tipLabel.text = @"请输入正确登陆密码";
        [buttomButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [buttomButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    nRetryTimesRemain = LockRetryTimes;
}

- (void)lockString:(NSString *)string{
    if (lockViewType == LockViewTypeLogin) {
        for (PasswordInfo *tempPassword in savedPasswords) {
            if ([string isEqualToString:tempPassword.password]) {
                [tipLabel setText:@"密码正确"];
                [self.navigationController dismissViewControllerAnimated:NO completion:^{
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    appDelegate.password = string;
                    
                    [appDelegate showAlbum];
                }];
                return;
            }
        }
        nRetryTimesRemain --;
        if (nRetryTimesRemain==0) {
            //没有次数了，这时应该消除密码，然后让用户进入密保问题选项。
        }
        else{
            [tipLabel setText:[NSString stringWithFormat:@"密码输错，还可输入%i次",nRetryTimesRemain]];
        }

    }
    else{// 修改密码
        if (!newPassword) {//修改状态，首次登陆
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if ([string isEqualToString:appDelegate.password]) {//密码正确，可以修改了
                [tipLabel setText:@"请输入新的密码"];
                newPassword = @"";
            }
            else{
                [tipLabel setText:@"当前密码输入错误，请重新输入"];
            }
            
        }
        else if (newPassword.length==0){
            if (string.length>=4) {
                //confirm = YES;
                newPassword = string;
                [tipLabel setText:@"请再次绘制确认"];
            }
            else{
                [tipLabel setText:@"密码不正确，长度不小于4,请重绘"];
            }
        }
        else{
            if (string.length>=4) {
                if ([newPassword isEqualToString:string]) {
                    [FileManager shareFileManager].delegate = self;
                    [[FileManager shareFileManager]updateCurrentPassword:currentPasswordInfo.password toNewPassword:newPassword];
                }
                else{
                    newPassword = @"";
                    [tipLabel setText:@"两次绘制不一致，请重绘！"];
                    //confirm = NO;
                }
            }
            else{
                newPassword = @"";
                [tipLabel setText:@"密码不正确，长度不小于4,请重绘"];
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
        if (!_currentPasswordIsMain) {
            appDelegate.password = aNewPassword;
        }
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"failed to update password" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
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
