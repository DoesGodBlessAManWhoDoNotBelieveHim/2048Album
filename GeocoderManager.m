//
//  GeocoderManager.m
//  2048Album
//
//  Created by Jzhang on 14-12-31.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "GeocoderManager.h"

@interface GeocoderManager ()

@end

@implementation GeocoderManager

static GeocoderManager *sharedManager = nil;

+ (GeocoderManager *)sharedGeocoderManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[GeocoderManager alloc]init];
    });
    
    return sharedManager;
}

- (instancetype)init{
    if (self = [super init]) {
        self.geoOperaQueue = [[NSOperationQueue alloc]init];
        
    }
    return self;
}

- (void)beginGeo{
    LKDBHelper *globalHelper = [AppDelegate getUsingLKDBHelper];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    PhotoInfo *photo = [globalHelper searchSingle:[PhotoInfo class] where:@"(locationName is null OR locationName = '') and (latitude <> '')" orderBy:nil];
    if (photo) {
        [self.geoOperaQueue addOperationWithBlock:^{
            CLLocation *c=[[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[photo.latitude doubleValue] longitude:(CLLocationDegrees)[photo.longitude doubleValue]];
            CLGeocoder *revGeo = [[CLGeocoder alloc] init];
            [revGeo reverseGeocodeLocation:c completionHandler:^(NSArray *placemarks, NSError *error) {
                if (!error && placemarks.count>0) {
                    NSDictionary *addressDict = [placemarks[0] addressDictionary];
                    photo.locationName = [NSString stringWithFormat:@"%@%@",[addressDict objectForKey:@"City"],[[addressDict objectForKey:@"Street"] componentsSeparatedByString:@" "][0]];
                    [[FileManager shareFileManager]updatePhoto:photo byPassword:appDelegate.password];
                }
                
            }];
        }];
    }
}

- (void)stop{
    [self.geoOperaQueue setSuspended:YES];
}

- (void)resume{
    [self.geoOperaQueue setSuspended:NO];
}

- (void)cancel{
    [self.geoOperaQueue cancelAllOperations];
}

@end
