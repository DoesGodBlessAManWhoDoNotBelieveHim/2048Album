//
//  PasswordManagementViewController.h
//  2048Album
//
//  Created by Jzhang on 14-12-29.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordManagementViewController : UIViewController

@property (nonatomic,assign) BOOL willModifyTapsGesrure;

- (IBAction)updateCurrentPassword:(id)sender;
- (IBAction)settingTapGesture:(id)sender;

- (IBAction)updateSecurity:(id)sender;
@end
