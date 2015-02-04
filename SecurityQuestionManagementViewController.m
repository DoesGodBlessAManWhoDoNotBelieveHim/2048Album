//
//  SecurityQuestionManagementViewController.m
//  2048Album
//
//  Created by Jzhang on 15-1-26.
//  Copyright (c) 2015年 hket.com. All rights reserved.
//

#import "SecurityQuestionManagementViewController.h"

#import "SecurityQuestion.h"

@interface SecurityQuestionManagementViewController ()<UITextFieldDelegate>{
    SecurityQuestion *security;
    BOOL firstIn;
}
@property (nonatomic,strong) UIBarButtonItem *rightDone;

@end

@implementation SecurityQuestionManagementViewController

@synthesize quetionTextField,question,answer1,answer1TextField,answer2,answer2TextField,rightDone,securityType,tipsOfAnswer2,titleOfAnswer2,questionLabel,tipsLabel;

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:quetionTextField];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:answer1TextField];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:answer2TextField];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    quetionTextField.text = @"";
    answer1TextField.text = @"";
    answer2TextField.text = @"";
    tipsLabel.hidden = YES;
    firstIn = YES;
    rightDone = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveNewSecurityQuestionAndAnswers:)];
    rightDone.enabled = NO;
    self.navigationItem.rightBarButtonItem = rightDone;
    
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(textInputChanged:) name:  UITextFieldTextDidChangeNotification object:quetionTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textInputChanged:) name:UITextFieldTextDidChangeNotification object:answer1TextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textInputChanged:) name:UITextFieldTextDidChangeNotification object:answer2TextField];
    
    LKDBHelper *globalHelper = [AppDelegate getUsingLKDBHelper];
    security = [globalHelper searchSingle:[SecurityQuestion class] where:nil orderBy:nil];
    
    questionLabel.text = security.question;
    
    quetionTextField.hidden = YES;
    quetionTextField.placeholder = NSLocalizedString(@"Please_Input_Security_Question_Here", nil);
    
    answer1TextField.text = @"";
    answer1TextField.placeholder = NSLocalizedString(@"Please_Input_Security_Answer_Here", nil);;
    
    answer2TextField.hidden = YES;
    titleOfAnswer2.hidden = YES;
    tipsOfAnswer2.hidden = YES;
    answer2TextField.placeholder = NSLocalizedString(@"Please_Input_The_Second_Security_Answer_Here", nil);;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1001) {
        textField.returnKeyType = UIReturnKeyNext;
    }
    else if (textField.tag == 1002){
        if (firstIn) {
            textField.returnKeyType = UIReturnKeyDone;
        }
        else{
            textField.returnKeyType = UIReturnKeyNext;
        }
    }
    else{
        textField.enablesReturnKeyAutomatically = YES;
        textField.returnKeyType = UIReturnKeyDone;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 1001) {
        [answer1TextField becomeFirstResponder];
    }
    else if (textField.tag == 1002){
        if (firstIn) {
            if (textField.text.length>0) {
                [self checkTheAnswer];
            }
            else{
                // 请输入密保
                NSLog(@"请输入密保");
            }
        }
        else{
            [answer2TextField becomeFirstResponder];
        }
        
    }
    else{
        if ([self shouldEnableDoneButton]) {
            [self saveNewSecurityQuestionAndAnswers:nil];
        }
        else{
            NSLog(@"请填写完整信息");
        }
        
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location == 16) {
        return NO;
    }
    return YES;
}

- (void)textInputChanged:(NSNotification *)note{
    rightDone.enabled = [self shouldEnableDoneButton];
}

-(BOOL)shouldEnableDoneButton
{
    BOOL enableDoneButton = NO;
    
    if (quetionTextField.text != nil &&
        quetionTextField.text.length > 0 &&
        answer1TextField.text != nil &&
        answer1TextField.text.length > 0 &&
        answer2TextField.text != nil &&
        answer2TextField.text.length > 0)
    {
        enableDoneButton = YES;
        //NSLog(@"done button enabled");
    }
    return enableDoneButton;
    
}

- (void)checkTheAnswer{
    if (securityType == UpdateSecurity) {//修改密保问题
        if ([answer1TextField.text isEqualToString:security.answer1] || [answer1TextField.text isEqualToString:security.answer2]) {// 填写的答案为数据库中得两个答案之一，就可以进入修改界面
            firstIn = NO;
            
            questionLabel.hidden = YES;
            quetionTextField.hidden = NO;
            quetionTextField.text = @"";
            
            answer1TextField.text = @"";
            answer2TextField.text = @"";
            answer2TextField.hidden = NO;
            titleOfAnswer2.hidden = NO;
            tipsOfAnswer2.hidden = NO;
            tipsLabel.hidden = NO;
        }
        else{
            // Alert Error Message !!!
        }
    }
    else{// 忘记密码，重置密码
        if ([answer1TextField.text isEqualToString:security.answer1]) {//重置密码，不删除文件
            // popToRootViewController
            [[FileManager shareFileManager]initAllPasswordAndInitSecurity:NO DeleteAllPhotosAndVideos:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if([answer1TextField.text isEqualToString:security.answer2]){//重置密码，同时删除文件
            // popToRootViewController
            [[FileManager shareFileManager]initAllPasswordAndInitSecurity:NO DeleteAllPhotosAndVideos:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
}

- (void)saveNewSecurityQuestionAndAnswers:(id)sender{
    if ([answer2TextField.text isEqualToString:answer1TextField.text]) {
    //两个答案不能相同
    }
    else{
        LKDBHelper *globalHelper = [AppDelegate getUsingLKDBHelper];
        [globalHelper updateToDB:[security class] set:[NSString stringWithFormat:@"question='%@',answer1='%@',answer2='%@'",quetionTextField.text,answer1TextField.text,answer2TextField.text] where:@{@"question":security.question}];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (IBAction)dismissKeyBoard:(id)sender {
    [quetionTextField resignFirstResponder];
    
    [answer1TextField resignFirstResponder];
    [answer2TextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
