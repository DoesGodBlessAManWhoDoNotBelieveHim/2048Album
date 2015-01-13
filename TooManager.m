//
//  SortManager.m
//  2048Album
//
//  Created by Jzhang on 14-11-4.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "TooManager.h"
#import "PasswordInfo.h"

@implementation TooManager

//+ (void)sortStringsArray:(NSMutableArray *)strArray with:(SortType)sortType{
//    if (!strArray || strArray.count == 0) {
//        return;
//    }
//    switch (sortType) {
//        case Alphabetical:{//字母顺序
//            
//            for (int j=0; j<strArray.count - 1; j++) {
//                for (int i = 0; i < strArray.count - 1 - j; i++) {
//                    if (NSOrderedDescending == [[strArray[i] nickName] compare:[strArray[i+1] nickName]]) {
//                        [strArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
//                    }
//                }
//            }
//             
//            /*
//            NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nickName" ascending:YES]];
//            [strArray sortUsingDescriptors:sortDescriptors];
//             */
//        }
//            break;
//        case AlphabeticalReverse:{//字母反序
//            for (int j=0; j<strArray.count - 1; j++) {
//                for (int i = 0; i < strArray.count - 1 - j; i++) {
//                    if (NSOrderedAscending == [[strArray[i] nickName] compare:[strArray[i+1] nickName]]) {
//                        [strArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
//                    }
//                }
//            }
//        }
//            break;
//        case Chronological:{// 按时间顺序
//            for (int j=0; j<strArray.count - 1; j++) {
//                for (int i = 0; i < strArray.count - 1 - j; i++) {
//                    /*
//                    NSString *str1 =[[[strArray[i] createTime] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
//                    NSString *str2 = [[[strArray[i+1] createTime] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
//                    if ([str1 integerValue] > [str2 integerValue]) {
//                        [strArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
//                    }
//                    */
//                    //或者
//                    NSString *str1 = [strArray[i] createTime];
//                    NSString *str2 = [strArray[i+1] createTime];
//                    if (NSOrderedDescending == [str1 compare:str2]) {
//                        [strArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
//                    }
//                    else{
//                        NSLog(@"str1 < str2");
//                    }
//                     
//                }
//            }
//        }
//            break;
//        case ChronologicalReverse:{// 按时间反序
//            for (int j=0; j<strArray.count - 1; j++) {
//                for (int i = 0; i < strArray.count - 1 - j; i++) {
//                     /*
//                    NSString *str1 =[[[strArray[i] createTime] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
//                    NSString *str2 = [[[strArray[i+1] createTime] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
//                    if ([str1 integerValue] < [str2 integerValue]) {
//                        [strArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
//                    }
//                   */
//                    //或者
//                    NSString *str1 = [strArray[i] createTime];
//                    NSString *str2 = [strArray[i+1] createTime];
//                    if (NSOrderedAscending == [str1 compare:str2]) {
//                        [strArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
//                    }
//                    else{
//                        NSLog(@"str1 > str2");
//                    }
//
//                }
//            }
//        }
//        default:
//            break;
//    }
//}

+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateformatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateformatter setDateFormat:@"yyyyMMdd"];
     return [dateformatter stringFromDate:date];
}

+ (BOOL)currentPasswordIsMainPassword{
    
    LKDBHelper *dbhelper = [AppDelegate getUsingLKDBHelper];
    PasswordInfo *password = [dbhelper searchSingle:[PasswordInfo class] where:[NSString stringWithFormat:@"isMainPassword=%@",[NSNumber numberWithBool:YES]] orderBy:nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([password.password isEqualToString:appDelegate.password]) {
        return YES;
    }
    return NO;
}

@end
