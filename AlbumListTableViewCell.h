//
//  AlbumListTableViewCell.h
//  2048Album
//
//  Created by Jzhang on 14-11-3.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;

@property (strong, nonatomic) IBOutlet UILabel *albumNameLabel;
- (IBAction)doMoreAboutThisAlbum:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *doMore;
@property (strong, nonatomic) IBOutlet UIImageView *accessoryIV;
@end
