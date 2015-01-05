//
//  PhotoInfo.m
//  2048Album
//
//  Created by Jzhang on 14-11-4.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "PhotoInfo.h"

@implementation PhotoInfo
@synthesize name,image,date,latitude,altitude,locationName,longitude,thumnailImage,mainPassword;

+ (void)initialize{
    [self removePropertyWithColumnNameArray:@[@"error",@"image"]];
}

//+ (NSString *)getPrimaryKey{
//    return @"name";
//}

+ (NSArray *)getPrimaryKeyUnionArray{
    return @[@"name",@"mainPassword"];
}

-(NSString *)description{
    return [NSString stringWithFormat:@"name:%@\ndate:%@\nlatitude:%@\nlongitude:%@\naltitude:%@",name,date,latitude,longitude,altitude];
}

@end
