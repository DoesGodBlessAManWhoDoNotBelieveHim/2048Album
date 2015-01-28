//
//  SecurityQuestionManagementViewController.h
//  2048Album
//
//  Created by Jzhang on 15-1-26.
//  Copyright (c) 2015年 hket.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ForgetPassword,
    UpdateSecurity
}SecurityType;

@interface SecurityQuestionManagementViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) IBOutlet UITextField *quetionTextField;
@property (strong, nonatomic) IBOutlet UITextField *answer1TextField;
@property (strong, nonatomic) IBOutlet UITextField *answer2TextField;

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleOfAnswer2;
@property (strong, nonatomic) IBOutlet UILabel *tipsOfAnswer2;

@property (nonatomic,copy) NSString *question;

@property (nonatomic,copy) NSString *answer1;
@property (nonatomic,copy) NSString *answer2;


@property (nonatomic)SecurityType securityType;

@end
