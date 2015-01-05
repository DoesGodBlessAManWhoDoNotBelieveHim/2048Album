//
//  CellLabel.h
//  2048Album
//
//  Created by Jzhang on 14-10-15.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellLabel : UILabel

@property (nonatomic, assign) int placeXY;

@property (nonatomic, assign) int number;

@property (nonatomic, assign) BOOL canBeMerged;

- (void)doAnimations:(BOOL)animation;

@end
