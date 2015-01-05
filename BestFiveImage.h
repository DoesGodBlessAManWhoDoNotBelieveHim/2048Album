//
//  BestFiveImage.h
//  2048Album
//
//  Created by Jzhang on 14-10-31.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BestFiveImage : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy)     NSString *imageName;

@property (nonatomic, assign)  int  score;

- (NSString *)description;

@end
