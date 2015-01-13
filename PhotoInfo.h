//
//  PhotoInfo.h
//  2048Album
//
//  Created by Jzhang on 14-11-4.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoInfo : NSObject

/**
 * 照片名称
 */
@property (nonatomic, copy) NSString *name;

/**
 * image
 */
@property (nonatomic, strong) UIImage *image;

/**
 * image Directory
 */
@property (nonatomic, strong) NSString *imagePath;

/**
 * image
 */
@property (nonatomic, strong) UIImage *thumnailImage;

/**
 * 拍照日期
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
 * 存储图片 key
 */
@property (nonatomic, copy) NSString *cacheImageKey;

/**
 * 所在相册位置
 */
//@property (nonatomic, copy) NSString *albumName;

/**
 * 所在相册位置
 */
@property (nonatomic) BOOL mainPassword;

- (NSString *)description;

@end
