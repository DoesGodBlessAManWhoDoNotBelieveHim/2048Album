//
//  GeocoderManager.h
//  2048Album
//
//  Created by Jzhang on 14-12-31.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeocoderManager : NSObject

+ (GeocoderManager *)sharedGeocoderManager;
- (void)beginGeo;

- (void)stop;
- (void)resume;

- (void)cancel;

@property (nonatomic, strong) NSOperationQueue *geoOperaQueue;


@end
