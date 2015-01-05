//
//  HUDManager.m
//  2048Album
//
//  Created by Jzhang on 14-12-30.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "HUDManager.h"

#import "KVNProgress.h"

@interface HUDManager ()

@property (nonatomic, assign)BOOL   fullScreen;

@end

@implementation HUDManager
static HUDManager *hudManager = nil;
+ (HUDManager *)shareHUDManager{
    @synchronized(self) {
        if (hudManager == nil){
            hudManager = [[HUDManager alloc] init];
            [hudManager setupBaseKVNProgressUI];
            hudManager.fullScreen = NO;
        }
    }
    return hudManager;
}

#pragma mark - UI

- (void)setupBaseKVNProgressUI
{
    // See the documentation of all appearance propoerties
    [KVNProgress appearance].statusColor = [UIColor darkGrayColor];
    [KVNProgress appearance].statusFont = [UIFont systemFontOfSize:17.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor clearColor];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithWhite:0.9f alpha:0.9f];
    [KVNProgress appearance].backgroundTintColor = [UIColor whiteColor];
    [KVNProgress appearance].successColor = [UIColor darkGrayColor];
    [KVNProgress appearance].errorColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleSize = 75.0f;
    [KVNProgress appearance].lineWidth = 2.0f;
}

- (void)setupCustomKVNProgressUI
{
    // See the documentation of all appearance propoerties
    [KVNProgress appearance].statusColor = [UIColor whiteColor];
    [KVNProgress appearance].statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor whiteColor];
    [KVNProgress appearance].circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.9f];
    [KVNProgress appearance].backgroundTintColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:1.0f];
    [KVNProgress appearance].successColor = [UIColor whiteColor];
    [KVNProgress appearance].errorColor = [UIColor whiteColor];
    [KVNProgress appearance].circleSize = 110.0f;
    [KVNProgress appearance].lineWidth = 1.0f;
}

#pragma mark - Predefined HUD's
- (void)hideHud{
    [KVNProgress dismiss];
}

- (void)showHud{
    if (hudManager.fullScreen) {
        [KVNProgress showWithParameters:@{KVNProgressViewParameterFullScreen: @(YES)}];
    }
    else{
        [KVNProgress show];
    }
}

- (void)showSolidBackgroundWithStatus:(NSString *)status{
    [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus: status,
                                      KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
                                      KVNProgressViewParameterFullScreen: @(hudManager.fullScreen)}];
}

- (void)showWithStatus:(NSString *)status{
    if (hudManager.fullScreen) {
        [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus: status,
                                          KVNProgressViewParameterFullScreen: @(YES)}];
    }
    else{
        [KVNProgress showWithStatus:status];
    }
}

- (void)showProgressWithStatuLabel:(NSString *)statuStr{
    if (hudManager.fullScreen) {
        [KVNProgress showProgress:0.0f parameters:@{KVNProgressViewParameterStatus: statuStr,KVNProgressViewParameterFullScreen: @(YES)}];
    }
    else{
        [KVNProgress showProgress:0.0f
                           status:statuStr];
    }
    //[self updateProgress:(float)progress];
}

- (void)updateProgress:(float)progress{
    [KVNProgress updateProgress:0.3f
                       animated:YES];
}

- (void)showSuccess:(NSString *)successStr{
    if (hudManager.fullScreen) {
        [KVNProgress showSuccessWithParameters:@{KVNProgressViewParameterStatus: successStr,
                                                 KVNProgressViewParameterFullScreen: @(YES)}];
    }
    else{
        [KVNProgress showSuccessWithStatus:successStr];
    }
}

- (void)showError:(NSString *)errorStr{
    if (hudManager.fullScreen) {
        [KVNProgress showErrorWithParameters:@{KVNProgressViewParameterStatus: errorStr,
                                               KVNProgressViewParameterFullScreen: @(YES)}];
    } else {
        [KVNProgress showErrorWithStatus:errorStr];
    }
}

@end
