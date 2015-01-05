//
//  ImageCache.m
//  2048Album
//
//  Created by Jzhang on 14-12-18.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "ImageCache.h"

static ImageCache *imageCache = nil;
@implementation ImageCache

+ (instancetype)shareImageCache{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        imageCache = [[ImageCache alloc]init];
    });
    return imageCache;
}

@end
