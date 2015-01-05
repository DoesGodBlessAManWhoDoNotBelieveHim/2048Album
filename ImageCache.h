//
//  ImageCache.h
//  2048Album
//
//  Created by Jzhang on 14-12-18.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSCache

+ (instancetype)shareImageCache;

@end
