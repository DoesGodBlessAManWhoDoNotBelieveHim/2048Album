//
//  IntroduceViewController.m
//  2048Album
//
//  Created by Jzhang on 14-12-9.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "IntroduceViewController.h"
#import "SecurityViewController.h"

#define IntroduceImageCount 3

@interface IntroduceViewController ()

@end

@implementation IntroduceViewController
@synthesize introcuceScroll,pageControl,closeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    closeButton.hidden = YES;
    introcuceScroll.contentSize = CGSizeMake(mainScreenSize.width * IntroduceImageCount, mainScreenSize.height);
    introcuceScroll.pagingEnabled = YES;
    for (int i=0; i<IntroduceImageCount; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(i*mainScreenSize.width, 0, mainScreenSize.width, mainScreenSize.height)];
        if (mainScreenSize.height == 480) {
            iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"4-%i.png",i+1]];
        }
        else if (mainScreenSize.height == 568){
            iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"5-%i.png",i+1]];
        }
        
        [introcuceScroll addSubview:iv];
    }
    introcuceScroll.delegate = self;
}
- (IBAction)pageChanged:(id)sender {
    if (sender) {
        [introcuceScroll setContentOffset:CGPointMake(pageControl.currentPage*mainScreenSize.width, 0) animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x >= mainScreenSize.width * (IntroduceImageCount-1)) {
        closeButton.hidden = NO;
    }
    else{
        if (!closeButton.hidden) {
            closeButton.hidden = YES;
        }
    }
    pageControl.currentPage = (int)scrollView.contentOffset.x/mainScreenSize.width;
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == mainScreenSize.width * (IntroduceImageCount-1)) {
        closeButton.hidden = NO;
    }
    else{
        if (!closeButton.hidden) {
            closeButton.hidden = YES;
        }
    }
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeAction:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate show2048GameViewController];
    /*
    SecurityViewController *securityViewController = [[SecurityViewController alloc]initWithType:LockViewTypeCreate];
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:securityViewController];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];*/
}
@end
