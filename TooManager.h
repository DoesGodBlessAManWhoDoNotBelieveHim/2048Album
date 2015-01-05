//
//  TooManager.h
//  2048Album
//
//  Created by Jzhang on 14-11-4.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    Alphabetical = 1,
    AlphabeticalReverse,
    Chronological,
    ChronologicalReverse,
}SortType;

@interface TooManager : NSObject

//+ (void)sortStringsArray:(NSMutableArray *)strArray with:(SortType)sortType;
+ (NSString *)stringFromDate:(NSDate *)date;

+ (BOOL)currentPasswordIsMainPassword;
@end
