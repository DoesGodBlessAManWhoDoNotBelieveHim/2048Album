//
//  GuideViewController.m
//  2048Album
//
//  Created by Jzhang on 14-10-21.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>

@end

@implementation GuideViewController
@synthesize guideScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.title = NSLocalizedString(@"GUIDE", nil);
    // Do any additional setup after loading the view.
    guideScrollView.contentSize = CGSizeMake(mainScreenSize.width * 3, mainScreenSize.height-64);
    guideScrollView.pagingEnabled = YES;
    guideScrollView.delegate = self;
    for (int i = 0; i < 3; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(mainScreenSize.width * i, 0, mainScreenSize.width, mainScreenSize.height)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide%i.png",i+1]]];
        [guideScrollView addSubview:imageView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x == 640) {
        NSLog(@"scrollViewDidScrollTOThree");
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"More" style:UIBarButtonItemStylePlain target:self action:@selector(gogogirl:)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)gogogirl:(id)sender{
    NSLog(@"gogogirl");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
