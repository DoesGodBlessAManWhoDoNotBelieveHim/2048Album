//
//  LeaderBoardViewController.h
//  2048Album
//
//  Created by Jzhang on 14-10-21.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderBoardViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scoreScrollView;
@property (strong, nonatomic) NSArray *scoreImages;
@end
