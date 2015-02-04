//
//  TapGestureMaskView.h
//  2048Album
//
//  Created by Jzhang on 15-2-3.
//  Copyright (c) 2015年 hket.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapGestureMaskView : UIView<UITextFieldDelegate>
- (IBAction)save:(id)sender;
- (IBAction)cancelAndDiss:(id)sender;


@property (strong, nonatomic) IBOutlet UITextField *numberOfFingersTextField;
@property (strong, nonatomic) IBOutlet UILabel *numberOfFingersLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;

@property (strong, nonatomic) IBOutlet UITextField *numberOfTapsTextField;
@property (strong, nonatomic) IBOutlet UILabel *numberOfTapsLabel;
@property (strong, nonatomic) IBOutlet UIView *centerConstraintView;
@end
