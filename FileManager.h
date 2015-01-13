//
//  FileManager.h
//  2048Album
//
//  Created by Jzhang on 14-10-31.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BestFiveImage.h"

#import "PhotoInfo.h"
#import "VideoInfo.h"

@protocol FileManagerDelegate
@required

@optional
// add
- (void)handleCreateAPassword:(NSString *)password Sucess:(BOOL)success alreadyExist:(BOOL)exist;//创建密码相册代理方法

- (void)handleCreateANewPhoto:(PhotoInfo *)photoInfo success:(BOOL)success alreadyExist:(BOOL)exist;//创建单张photo

- (void)handleCreatePhotosSuccess:(NSInteger)successCount failedCount:(NSInteger)failedCount;//创建多张photo时的代理，可返回成功和失败的张数

// delete
- (void)handleDeletePassword:(NSString *)password success:(BOOL)success;
- (void)handleDeletePhotoWithPasswordSuccessCount:(NSInteger)successCount failedCount:(NSInteger)failedCount;
- (void)handleDeleteAPhoto:(PhotoInfo *)photoInfo;

// search
- (void)handleSelectAllPasswrods:(NSArray *)albumsArray success:(BOOL)success;
- (void)handleSelectPhotos:(NSArray *)photos byPassword:(NSString *)password success:(BOOL)success;

// update
- (void)handleUpdatePhoto:(PhotoInfo *)photo success:(BOOL)success;
- (void)handleUpdateCurrentPassword:(NSString *)currentPassword newPassword:(NSString *)newPassword success:(BOOL)success error:(NSError*)error;

////////////////////////////////////////////////////////////////
- (void)handleCreateVideosSuccess:(NSInteger)successCount failedCount:(NSInteger)failedCount;//创建多个video时的代理，可返回成功和失败的个数
- (void)handleDeleteVideosWithPasswordSuccessCount:(NSInteger)successCount failedCount:(NSInteger)failedCount;
- (void)handleSelectVideos:(NSArray *)videos byPassword:(NSString *)password success:(BOOL)success;
- (void)handleUpdateVideo:(VideoInfo *)video success:(BOOL)success;
@end

@interface FileManager : NSObject{
    id<FileManagerDelegate> delegate;
}

@property (nonatomic, assign) id<FileManagerDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *thumnailImages;
@property (nonatomic, strong) NSMutableDictionary *fullSizeImages;

+ (FileManager *)shareFileManager;

- (void)createGameResultImageFilePath;

- (NSArray *)selectAllScoreImages;

- (int)selectHighestSocre;

- (int)selectLowestSocre;

- (BOOL)saveSocreImage:(BestFiveImage *)bestScoreImage;

- (BOOL)deleteLowestSocreImage;

- (int)countOfScoreImages;

#pragma mark - Album 
- (void)createAlbumHomeAndBranchDirectory;
#pragma mark --------------------------------
/** 根据所创密码创建文件夹 */
- (void)createAlbumDirectoryWithPassword:(NSString*)password isMainPassword:(BOOL)isMainPassword;
/**存储单张照片
 *  PhotoInfo:照片
 *  password:
 */
- (void)savePhoto:(PhotoInfo *)photoInfo withPassword:(NSString *)password;
/**存储多张照片
 *  photos:照片数组
 *  password:
 */
- (void)savePhotos:(NSArray *)photos  withPassword:(NSString *)password;

- (NSArray *)selectAllPassword;
/**
 *  根据密码查找photos
 *  password:密码
 */
- (void)selectPhotosWithPassword:(NSString *)password;

/** 根据密码删除该密码下的所有相册所有信息 */
- (void)deletePhotosByPassword:(NSString *)password;
/** 删除某一张或者某几张图片图片 */
- (void)deletePhotosByPassword:(NSString *)password photos:(NSArray *)photoInfos;
- (void)deleteAPhotoByPassword:(NSString *)password;

- (void)updatePhoto:(PhotoInfo *)photo byPassword:(NSString *)password;
- (void)updateCurrentPassword:(NSString *)currentPassword toNewPassword:(NSString *)newPassword;

#pragma mark - Movie
- (void)saveVideos:(NSArray *)videos withPassword:(NSString *)password;

- (void)saveVideo:(VideoInfo *)video withPassword:(NSString *)password;

- (void)selectVideosWithPassword:(NSString *)password;

- (void)deleteVideos:(NSArray *)videos byPassword:(NSString *)password;
- (void)updateVideo:(VideoInfo *)video byPassword:(NSString *)password;
@end
