//
//  ThumnailViewController.h
//  2048Album
//
//  Created by Jzhang on 14-12-19.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThumnailViewController : UIViewController<FileManagerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBarBtn;
- (IBAction)showMenu:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBarBtn;
- (IBAction)editAction:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentControlValueChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UICollectionView *contentCollectionView;

@end
