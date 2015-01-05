//
//  CellLabel.m
//  2048Album
//
//  Created by Jzhang on 14-10-15.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "CellLabel.h"

@implementation CellLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init{
    if (self = [super init]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont fontWithName:@"Marker Felt" size:20];
        
        self.backgroundColor = [UIColor lightGrayColor];
//        self.layer.cornerRadius = 5.0f;
//        self.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)doAnimations:(BOOL)animation{
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.font = [UIFont fontWithName:@"Marker Felt" size:30];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f delay:.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.font = [UIFont fontWithName:@"Marker Felt" size:20];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)setPlaceXY:(int)placeXY{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _placeXY = placeXY;
    CGRect frame = self.frame;
    frame.origin.x = (placeXY / 10 - 1) * (cellSpace + cellSize) + cellSpace + 10;
    frame.origin.y = (placeXY % 10 - 1) * (cellSpace + cellSize) + cellSpace + appDelegate.mapLocationY;
    self.frame = frame;
    //[self doAnimations:YES];
}

- (void)setNumber:(int)number{
    _number = number;
    [self setText:[NSString stringWithFormat:@"%i",number]];
    switch (number) { // 根据 number值设置不同的字体颜色
        case 2:
            self.textColor = [UIColor blackColor];
            break;
        case 4:
            self.textColor = [UIColor blueColor];
            break;
        case 8:
            self.textColor = [UIColor colorWithRed:255/255.0 green:215/255.0 blue:0 alpha:1];
            break;
        case 16:
            self.textColor = [UIColor whiteColor];
            break;
        case 32:
            self.textColor = [UIColor brownColor];
            break;
        case 64:
            self.textColor = [UIColor cyanColor];
            break;
        case 128:
            self.textColor = [UIColor orangeColor];
            break;
        case 256:
            self.textColor = [UIColor yellowColor];
            break;
        case 512:
            self.textColor = [UIColor magentaColor];
            break;
        case 1024:
            self.textColor = [UIColor purpleColor];
            break;
        case 2048:
            self.textColor = [UIColor redColor];
            break;
        default:
            
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
