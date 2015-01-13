//
//  AppDelegate.m
//  2048Album
//
//  Created by Jzhang on 14-10-15.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MenuTableViewController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "GameNavigationViewController.h"

#import "AlbumNavigationViewController.h"

#import "IntroduceViewController.h"

@interface AppDelegate(){
    MMDrawerController * drawerController;
    GameNavigationViewController *centerNavigation;
    IntroduceViewController *introduceViewController;
    AlbumNavigationViewController *albumNavigationViewController;
    
    BOOL NOFirstLaunch;
}
@end

@implementation AppDelegate
@synthesize storyBoard/*,leveyTabBarController*/;

+ (LKDBHelper *)getUsingLKDBHelper{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* dbpath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/DB/album.db"];
        db = [[LKDBHelper alloc]initWithDBPath:dbpath];

    });
    return db;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@",NSHomeDirectory());
    NOFirstLaunch = YES;
    if (mainScreenSize.height==480.0f) {
        self.mapLocationY = 175.0f;
    }
    else{
        self.mapLocationY = 220.0f;
    }
    storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"AppNotFistLaunch"]) {
        NOFirstLaunch = NO;
        introduceViewController = [storyBoard instantiateViewControllerWithIdentifier:@"IntroduceViewController"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kEffectSoundEnable];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kBestScore];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AppNotFistLaunch"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kAlbumSortType];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[FileManager shareFileManager]createAlbumDirectoryWithPassword:@"123" isMainPassword:YES];
        [[FileManager shareFileManager]createAlbumDirectoryWithPassword:@"321" isMainPassword:NO];
    }
    
    centerNavigation = [storyBoard instantiateViewControllerWithIdentifier:@"CenterNavigationViewControlelr"];
    
    
    UINavigationController * leftNavigation = [storyBoard instantiateViewControllerWithIdentifier:@"MenuNavigationControlelr"];
    
    drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:centerNavigation
                                             leftDrawerViewController:leftNavigation
                                             rightDrawerViewController:nil];
    
    [drawerController setMaximumRightDrawerWidth:200.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController_, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController_, drawerSide, percentVisible);
         }
     }];
    if (introduceViewController) {
        [drawerController setCenterViewController:introduceViewController];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:drawerController];
    
#pragma mark - 
    
    [[FileManager shareFileManager]createGameResultImageFilePath];
    [[FileManager shareFileManager]createAlbumHomeAndBranchDirectory];
    
    albumNavigationViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AlbumNavigationViewController"];
    //[self.window setRootViewController:albumNavigationViewController];
    // Override point for customization after application launch.
 /*
    IntroduceViewController *intro = [storyBoard instantiateViewControllerWithIdentifier:@"IntroduceViewController"];
    [self.window setRootViewController:intro];
    */
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)show2048GameViewController{
    
    [drawerController.centerViewController dismissViewControllerAnimated:NO completion:nil];
    if ([drawerController.centerViewController isKindOfClass:[UINavigationController class]]&&((UINavigationController *)drawerController.centerViewController).viewControllers.count>1) {
        [(UINavigationController *)drawerController.centerViewController popViewControllerAnimated:NO];
    }
    
    [drawerController setCenterViewController:centerNavigation];

}
- (void)showAlbum{
    
    [drawerController setCenterViewController:albumNavigationViewController];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    if (drawerController.showMenu_ing) {
        [drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
    }
    [self show2048GameViewController];
    
    if ([GeocoderManager sharedGeocoderManager].geoOperaQueue.operations.count >0) {
        if ([[GeocoderManager sharedGeocoderManager].geoOperaQueue.operations[0] isExecuting]) {
            [[GeocoderManager sharedGeocoderManager]stop];
        }
    }

    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
}

@end
