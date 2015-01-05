//
//  IntroduceViewController.h
//  2048Album
//
//  Created by Jzhang on 14-12-9.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroduceViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *introcuceScroll;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
- (IBAction)closeAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@end
