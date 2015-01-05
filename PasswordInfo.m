//
//  PasswordInfo.m
//  2048Album
//
//  Created by Jzhang on 14-12-23.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "PasswordInfo.h"

@implementation PasswordInfo
@synthesize password,question,answer,isMainPassword;

+ (void)initialize{
    [self removePropertyWithColumnNameArray:@[@"error"]];
}


@end
