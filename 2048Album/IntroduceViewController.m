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
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, mainScreenSize.height/2.0-80, mainScreenSize.width, 150)];
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:18]];
        [label setTextColor:[UIColor redColor]];
        label.numberOfLines = 0;
        [iv addSubview:label];
        if (i==0) {
            [label setText:@"在游戏界面中，用2根手指连续点击3次，进入密码界面！"];
        }
        else if (i==1){
            [label setText:@"默认密码为：“123”和“321”\n默认密保为：“0”，答案为：“1”和“-1”，用于解决密码丢失等问题。当密码丢失及修改密保时，回答“1”，可重置密码，回答“2”，可重置密码并删除所有的文件！"];
        }
        else{
            [label setText:@"进入相册后，可自行修改进入相册手势及密码密保！"];
        }
        if (mainScreenSize.height == 480) {
            iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"4-%i.png",i+1]];
            
        }
        else if (mainScreenSize.height == 568){
            iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"5-%i.png",i+1]];
        }
        else{
            iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"6-%i.png",i+1]];
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
