//
//  AppDelegate.h
//  2048Album
//
//  Created by Jzhang on 14-10-15.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIStoryboard *storyBoard;

@property (nonatomic, copy) NSString *password;

//@property (strong, nonatomic) LeveyTabBarController *leveyTabBarController;

@property (strong, nonatomic) LLLockViewController *lockVc;//添加锁界面

//- (void)showLLLockViewController:(LLLockViewType)type;

- (void)show2048GameViewController;

- (void)showAlbum;

@property (nonatomic) float mapLocationY;

@end
