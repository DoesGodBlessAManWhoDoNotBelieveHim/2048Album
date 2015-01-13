//
//  VideoInfo.h
//  2048Album
//
//  Created by Jzhang on 15-1-4.
//  Copyright (c) 2015年 hket.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoInfo : NSObject

/**
 * 视频名称
 */
@property (nonatomic, copy) NSString *name;

/**
 * video Directory
 */
@property (nonatomic, strong) NSString *path;

/**
 * image Directory
 */
@property (nonatomic, strong) NSString *imagePath;

/**
 * thumnailImage
 */
@property (nonatomic, strong) UIImage *thumnailImage;

/**
 * 录像日期
 */
@property (nonatomic, copy) NSString *date;
/**
 * 根据经纬度转化来的城市地点名称
 */
@property (nonatomic, copy) NSString *locationName;

/**
 * 纬度
 */
@property (nonatomic, copy) NSString *latitude;
/**
 * 经度
 */
@property (nonatomic, copy) NSString *longitude;
/**
 * 海拔
 */
@property (nonatomic, copy) NSString *altitude;

/**
 * 所在相册位置
 */
@property (nonatomic) BOOL mainPassword;

- (NSString *)description;

@end
