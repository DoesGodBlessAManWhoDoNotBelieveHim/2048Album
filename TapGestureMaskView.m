//
//  TapGestureMaskView.m
//  2048Album
//
//  Created by Jzhang on 15-2-3.
//  Copyright (c) 2015年 hket.com. All rights reserved.
//

#import "TapGestureMaskView.h"

#import "HUDManager.h"

@implementation TapGestureMaskView
@synthesize numberOfFingersLabel,numberOfFingersTextField,numberOfTapsLabel,numberOfTapsTextField,tipsLabel,centerConstraintView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    if (self = [super init]) {
        [tipsLabel setText:NSLocalizedString(@"ReasonableText", nil)];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [tipsLabel setText:NSLocalizedString(@"ReasonableText", nil)];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [tipsLabel setText:NSLocalizedString(@"ReasonableText", nil)];
    [numberOfFingersLabel setText:NSLocalizedString(@"Fingers", nil)];
    [numberOfTapsLabel setText:NSLocalizedString(@"Taps", nil)];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor_{
    //self.backgroundColor = backgroundColor_;
    [super setBackgroundColor:backgroundColor_];
    centerConstraintView.backgroundColor = backgroundColor_;
}

- (IBAction)save:(id)sender {
    if (numberOfFingersTextField.text && numberOfFingersTextField.text.length>0 && numberOfTapsTextField.text && numberOfTapsTextField.text.length>0) {//两个文本框都必须有内容
        NSInteger numberOfFingers =[numberOfFingersTextField.text integerValue];
        NSInteger numberOfTaps = [numberOfTapsTextField.text integerValue];
        if (numberOfFingers && numberOfTaps) {
            if (numberOfFingers>=2 && numberOfFingers<=4 && numberOfTaps >=2 && numberOfTaps<=8) {
                [[NSUserDefaults standardUserDefaults]setObject:numberOfTapsTextField.text forKey:kNumberOfTaps];
                [[NSUserDefaults standardUserDefaults]setObject:numberOfFingersTextField.text forKey:kNumberOfFingers];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[HUDManager shareHUDManager]showSuccess:NSLocalizedString(@"WorkNextTime", @"Sucess!It will work next time!")];
            }
            else{
                [[HUDManager shareHUDManager]showError:NSLocalizedString(@"Reasonable",nil)];
                return;
            }
        }
        else{//必须能够转化为interger，即文本框中必须填写的是数字
            [[HUDManager shareHUDManager]showError:NSLocalizedString(@"Numberic",nil)];
            return;
        }
    }

    [self cancelAndDiss:nil];
}

- (IBAction)cancelAndDiss:(id)sender {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self removeFromSuperview];
}

#pragma mark - UITextFiled Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length>1) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = @"";
    return YES;
}

@end
