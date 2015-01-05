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
    self.title = @"只保存前五项纪录";
    // Do any additional setup after loading the view.
    FileManager *shareFileManager = [FileManager shareFileManager];
    scoreImages = [shareFileManager selectAllScoreImages];
    
    scoreScrollView.scrollEnabled = YES;
    scoreScrollView.pagingEnabled = YES;
    scoreScrollView.contentSize = CGSizeMake(scoreScrollView.frame.size.width * scoreImages.count, scoreScrollView.frame.size.height-64);
    if (scoreImages && scoreImages.count > 0) {
        for (int i = 0; i < scoreImages.count; i ++) {
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scoreScrollView.bounds.size.width, scoreScrollView.bounds.size.height)];
            [scoreScrollView addSubview:contentView];
            BestFiveImage *bestImage = [scoreImages objectAtIndex:i];
            UILabel *scoreTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+320*i, 24, 300, 20)];
            scoreTitleLabel.textAlignment = NSTextAlignmentCenter;
            switch (i) {
                case 0:
                    [scoreTitleLabel setText:@"最高："];
                    break;
                case 1:
                    [scoreTitleLabel setText:@"第二："];
                    break;
                case 2:
                    [scoreTitleLabel setText:@"第三："];
                    break;
                case 3:
                    [scoreTitleLabel setText:@"第四："];
                    break;
                default:
                    [scoreTitleLabel setText:@"第五："];
                    break;
            }
            [contentView addSubview:scoreTitleLabel];
            
            // scoreLabel
            UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+320*i, 44, 300, 20)];
            scoreLabel.textAlignment = NSTextAlignmentCenter;
            scoreLabel.text = [NSString stringWithFormat:@"%i",bestImage.score];
            [contentView addSubview:scoreLabel];
            
            // scoreImage
            UIImageView *scoreImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+320*i, 90, 300, 300)];
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
