//
//  BestFiveImage.m
//  2048Album
//
//  Created by Jzhang on 14-10-31.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "BestFiveImage.h"

@implementation BestFiveImage

@synthesize image,imageName;

- (NSString *)description{
    return [NSString stringWithFormat:@"{imageName:%@}",imageName];
}

@end
