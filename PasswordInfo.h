//
//  PasswordInfo.h
//  2048Album
//
//  Created by Jzhang on 14-12-23.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordInfo : NSObject

@property (nonatomic, copy) NSString *password;

//@property (nonatomic, copy) NSString *question;
//
//@property (nonatomic, copy) NSString *answer;

@property (nonatomic, assign) BOOL isMainPassword;

@end
