//
//  HUDManager.h
//  2048Album
//
//  Created by Jzhang on 14-12-30.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HUDManagerDelegate <NSObject>

- (void)updateProgress:(float)progress;

@end

@interface HUDManager : NSObject

@property (nonatomic,assign) id<HUDManagerDelegate> delegate;

+ (HUDManager *)shareHUDManager;

- (void)hideHud;

- (void)showHud;
- (void)showWithStatus:(NSString *)status;
- (void)showSolidBackgroundWithStatus:(NSString *)status;

- (void)showProgressWithStatuLabel:(NSString *)statuStr;
- (void)updateProgress:(float)progress;

- (void)showSuccess:(NSString *)successStr;
- (void)showError:(NSString *)errorStr;
@end
