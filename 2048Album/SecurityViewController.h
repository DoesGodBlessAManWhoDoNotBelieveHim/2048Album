//
//  SecurityViewController.h
//  2048Album
//
//  Created by Jzhang on 14-12-8.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLLockIndicator.h"
#import "LLLockView.h"
#import "LLLockPassword.h"

#define LockRetryTimes 5 // 最多重试几次
//#define LLLockAnimationOn  // 开启窗口动画，注释此行即可关闭

// 进入此界面时的不同目的
typedef enum {
    LockViewTypeLogin,  // 登陆
    LockViewTypeUpdate, // 修改密码
}LockViewType;


@interface SecurityViewController : UIViewController
@property (strong, nonatomic) IBOutlet LLLockIndicator *indicatorView;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;

@property (strong, nonatomic) IBOutlet LLLockView *lockView;

@property (strong, nonatomic) IBOutlet UIButton *buttomButton;

#pragma mark -
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tipLabelTopSpaceToIndicator;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttomButtonTopSpaceToLockView;

@property (nonatomic) LockViewType lockViewType; // 此窗口的类型
@property (nonatomic) BOOL isMainPassword; // 此窗口的类型

@property (nonatomic, assign) BOOL currentPasswordIsMain;//

- (id)initWithType:(LockViewType)type; // 直接指定方式打开
- (id)initWithType:(LockViewType)type isMainPassword:(BOOL)isMainPassword;
- (IBAction)buttomButtonAction:(id)sender;
@end
