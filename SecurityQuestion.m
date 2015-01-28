//
//  SecurityQuestion.m
//  2048Album
//
//  Created by Jzhang on 15-1-26.
//  Copyright (c) 2015年 hket.com. All rights reserved.
//

#import "SecurityQuestion.h"

@implementation SecurityQuestion
@synthesize question,answer1,answer2;

+(void)initialize{
    [self removePropertyWithColumnNameArray:@[@"error"]];
}

+ (NSString *)getPrimaryKey{
    return @"question";
}

+ (NSString *)getTableName{
    return @"SECURITY";
}


@end
