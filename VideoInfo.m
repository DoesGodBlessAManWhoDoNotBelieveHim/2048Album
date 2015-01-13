//
//  VideoInfo.m
//  2048Album
//
//  Created by Jzhang on 15-1-4.
//  Copyright (c) 2015年 hket.com. All rights reserved.
//

#import "VideoInfo.h"

@implementation VideoInfo

@synthesize imagePath,locationName,description,date,path,name,altitude,latitude,longitude,thumnailImage,mainPassword;

+ (void)initialize{
    [self removePropertyWithColumnNameArray:@[@"error"]];
}

//+ (NSString *)getPrimaryKey{
//    return @"name";
//}


+ (NSString *)getTableName{
    return @"VIDEO";
}

+ (NSArray *)getPrimaryKeyUnionArray{
    return @[@"name",@"mainPassword"];
}

-(NSString *)description{
    return [NSString stringWithFormat:@"name:%@\ndate:%@\nlatitude:%@\nlongitude:%@\naltitude:%@",name,date,latitude,longitude,altitude];
}


@end
