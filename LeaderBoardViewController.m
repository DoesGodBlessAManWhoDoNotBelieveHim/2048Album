//
//  LeaderBoardViewController.m
//  2048Album
//
//  Created by Jzhang on 14-10-21.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "LeaderBoardViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "FileManager.h"
#import "BestFiveImage.h"

@interface LeaderBoardViewController ()

@end

@implementation LeaderBoardViewController
@synthesize scoreScrollView,scoreImages;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.GameIsCenter = NO;
    self.mm_drawerController.GameBranch = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.title = NSLocalizedString(@"LeaderBoardTitle", nil);
    // Do any additional setup after loading the view.
    FileManager *shareFileManager = [FileManager shareFileManager];
    scoreImages = [shareFileManager selectAllScoreImages];
    
    scoreScrollView.scrollEnabled = YES;
    scoreScrollView.pagingEnabled = YES;
    scoreScrollView.contentSize = CGSizeMake(mainScreenSize.width * scoreImages.count, mainScreenSize.height-64);
    if (scoreImages && scoreImages.count > 0) {
        for (int i = 0; i < scoreImages.count; i ++) {
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenSize.width, mainScreenSize.height)];
            [scoreScrollView addSubview:contentView];
            BestFiveImage *bestImage = [scoreImages objectAtIndex:i];
            UILabel *scoreTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+mainScreenSize.width*i, 24, mainScreenSize.width-20, 22)];
            scoreTitleLabel.textAlignment = NSTextAlignmentCenter;
            switch (i) {
                case 0:
                    [scoreTitleLabel setText:NSLocalizedString(@"No.1", nil)];
                    break;
                case 1:
                    [scoreTitleLabel setText:NSLocalizedString(@"No.2", nil)];
                    break;
                case 2:
                    [scoreTitleLabel setText:NSLocalizedString(@"No.3", nil)];
                    break;
                case 3:
                    [scoreTitleLabel setText:NSLocalizedString(@"No.4", nil)];
                    break;
                default:
                    [scoreTitleLabel setText:NSLocalizedString(@"No.5", nil)];
                    break;
            }
            [contentView addSubview:scoreTitleLabel];
            
            // scoreLabel
            UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+mainScreenSize.width*i, 44, mainScreenSize.width-20, 20)];
            scoreLabel.textAlignment = NSTextAlignmentCenter;
            scoreLabel.text = [NSString stringWithFormat:@"%i",bestImage.score];
            [contentView addSubview:scoreLabel];
            
            // scoreImage
            UIImageView *scoreImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+mainScreenSize.width*i, 90, mainScreenSize.width-20, mainScreenSize.width-20)];
            [scoreImageView setImage:bestImage.image];
            [contentView addSubview:scoreImageView];
        }
    }
    
    
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
