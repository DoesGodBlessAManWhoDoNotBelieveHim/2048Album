//
//  FileManager.m
//  2048Album
//
//  Created by Jzhang on 14-10-31.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "FileManager.h"

#import "ALAsset+AGIPC.h"

#import <CoreLocation/CoreLocation.h>

#import "PasswordInfo.h"

#import "GeocoderManager.h"

#define kAlbum @"Album"
#define kVideo @"Video"

@interface FileManager (){
    NSString *scoreImageFileDirectory;
}

- (NSArray *)selectAllScores;

@property (nonatomic, copy) NSString *scoreImageFileDirectory;

@property (nonatomic, copy) NSString *rootDirectory;

@end

static FileManager *fileManager = nil;
@implementation FileManager
@synthesize scoreImageFileDirectory;

@synthesize thumnailImages,fullSizeImages;

+ (FileManager *)shareFileManager{
    @synchronized(self) {
        if (fileManager == nil){
            //NSLog(@"rebuild the PlaceManager");
            fileManager = [[FileManager alloc] init];
            fileManager.rootDirectory = [NSHomeDirectory() stringByAppendingString:@"/Documents/Secret"];
            // Game - Socre
            fileManager.scoreImageFileDirectory = [NSHomeDirectory() stringByAppendingString:@"/Documents/game/leaderboard"];
        }
    }
    return fileManager;
}
#pragma mark - Score Leaderboard
- (void)createGameResultImageFilePath{
    NSFileManager *nsFileManager = [NSFileManager defaultManager];
    BOOL success = NO;
    NSError *error = nil;
    if(![nsFileManager fileExistsAtPath:scoreImageFileDirectory]){
       success = [nsFileManager createDirectoryAtPath:scoreImageFileDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (!success) {
            NSLog(@"scoreImage文件夹创建失败。原因是：%@",error);
        }
    }
}


// 所有的score图片
- (NSArray *)selectAllScoreImages{
    NSMutableArray *bestImagesArray = [[NSMutableArray alloc]init];
    NSFileManager *nsFileManager = [NSFileManager defaultManager];
    if ([nsFileManager fileExistsAtPath:scoreImageFileDirectory]) {
        NSArray *bestSocreImagesNames = [nsFileManager subpathsAtPath:scoreImageFileDirectory];
        if (bestSocreImagesNames && bestSocreImagesNames.count > 0) {
            for (int i = 0; i < bestSocreImagesNames.count; i ++) {
                BestFiveImage *tempImage = [[BestFiveImage alloc]init];
                tempImage.imageName = bestSocreImagesNames[i];
                NSArray *score_suffix = [bestSocreImagesNames[i] componentsSeparatedByString:@"."];
                tempImage.score = [score_suffix[0] intValue];
                tempImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",scoreImageFileDirectory,bestSocreImagesNames[i]]];
                [bestImagesArray addObject:tempImage];
                tempImage = nil;
            }
            [self sortBestImages:bestImagesArray];
        }
    }
    return bestImagesArray;
}

- (void)sortBestImages:(NSMutableArray *)bestImagesArray{
    for (int j = 0; j < bestImagesArray.count-1; j ++) {
        for (int i = 0; i < bestImagesArray.count - j-1; i ++) {
            if ([bestImagesArray[i]score] < [bestImagesArray[i+1]score]) {
                [bestImagesArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
            }
        }
    }
}

// 所有的分数
- (NSArray *)selectAllScores{
    NSMutableArray *bestScoresArray = [[NSMutableArray alloc]init];
    NSFileManager *nsFileManager = [NSFileManager defaultManager];
    if ([nsFileManager fileExistsAtPath:scoreImageFileDirectory]){
        NSArray *bestSocreImagesNames = [nsFileManager subpathsAtPath:scoreImageFileDirectory];
        if (bestSocreImagesNames && bestSocreImagesNames.count > 0) {
            for (NSString *subStr in bestSocreImagesNames) {
                NSArray *tempArray = [subStr componentsSeparatedByString:@"."];
                [bestScoresArray addObject:tempArray[0]];
            }
        }
    }
    return bestScoresArray;
}

- (int)countOfScoreImages{
    NSFileManager *nsFileManager = [NSFileManager defaultManager];
    NSArray *bestSocreImagesNames = [nsFileManager subpathsAtPath:scoreImageFileDirectory];
    if (bestSocreImagesNames) {
        return  (int)bestSocreImagesNames.count;
    }
    return 0;
}

// 最高分
- (int)selectHighestSocre{
    NSArray *bestScoresArray = [NSArray arrayWithArray:[fileManager selectAllScores]];
    int tempHighestSocre = 0;
    if (bestScoresArray && bestScoresArray.count > 0) {
        tempHighestSocre = [bestScoresArray[0] intValue];
        for (int i = 1; i < bestScoresArray.count; i++) {
            if (tempHighestSocre < [bestScoresArray[i] intValue]) {
                tempHighestSocre = [bestScoresArray[i] intValue];
            }
        }
    }
    return tempHighestSocre;
}

//最低分
- (int)selectLowestSocre{
    NSArray *bestScoresArray = [NSArray arrayWithArray:[fileManager selectAllScores]];
    int tempLowestSocre = 0;
    if (bestScoresArray && bestScoresArray.count > 0) {
        tempLowestSocre = [bestScoresArray[0] intValue];
        for (int i = 1; i < bestScoresArray.count; i++) {
            if (tempLowestSocre > [bestScoresArray[i] intValue]) {
                tempLowestSocre = [bestScoresArray[i] intValue];
            }
        }
    }
    return tempLowestSocre;
}

//删除最低
- (BOOL)deleteLowestSocreImage{
    int lowestScore = [self selectLowestSocre];
    NSString *lowestSocreImagePath = [NSString stringWithFormat:@"%@/%i.image",self.scoreImageFileDirectory,lowestScore];
    NSFileManager *nsFileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL success = [nsFileManager removeItemAtPath:lowestSocreImagePath error:&error];
    if (success) {
        NSLog(@"delete lowest score image success");
    }
    else{
        NSLog(@"delete lowest score image failed:%@",error);
    }
    return success;
}

// 存储图片
- (BOOL)saveSocreImage:(BestFiveImage *)bestScoreImage{
    NSData *imageData = UIImageJPEGRepresentation(bestScoreImage.image, 0.5);
    NSString *lowestSocreImagePath = [NSString stringWithFormat:@"%@/%i.image",self.scoreImageFileDirectory,bestScoreImage.score];
    NSLog(@"lowestSocreImagePath:%@",lowestSocreImagePath);
    NSFileManager *nsFileManager = [NSFileManager defaultManager];
    BOOL success = [nsFileManager createFileAtPath:lowestSocreImagePath contents:imageData attributes:nil];
    if (success) {
        NSLog(@"图片存储成功");
    }
    else{
        NSLog(@"图片存储失败");
    }
    return success;
}

#pragma mark - Album ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void)createAlbumHomeAndBranchDirectory{
    NSFileManager *nsFileManager = [NSFileManager defaultManager];
    BOOL success = NO;  NSError *error = nil;
    if(![nsFileManager fileExistsAtPath:self.rootDirectory]){
        success = [nsFileManager createDirectoryAtPath:self.rootDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (!success) {
            NSLog(@"photoFileDirectory文件夹创建失败。原因是：%@",error);
        }
    }
}
#pragma mark - *************************************************************** *************************************************************** *************************************************************** *************************************************************** ***************************************************************
- (void)createAlbumDirectoryWithPassword:(NSString *)password isMainPassword:(BOOL)isMainPassword{
//    NSFileManager *defaultManger = [NSFileManager defaultManager];
//    NSString *passwordDirectory = [NSString stringWithFormat:@"%@/%@",fileManager.rootDirectory,password];
    LKDBHelper *globalHelper = [AppDelegate getUsingLKDBHelper];
    if (isMainPassword) {//主密码
        PasswordInfo *mainPassword = [[PasswordInfo alloc]init];
        mainPassword.password = password;
        mainPassword.isMainPassword = YES;
        mainPassword.question = @"123";
        mainPassword.answer = @"123";
        BOOL success = [globalHelper insertToDB:mainPassword];
        if (success) {
            [self createAlbumDirectoryWithPassword:password];
        }
    }
    else{//伪密码
        PasswordInfo *pseudoPassword = [[PasswordInfo alloc]init];
        pseudoPassword.password = password;
        pseudoPassword.isMainPassword = NO;

        BOOL success = [globalHelper insertToDB:pseudoPassword];
        if (success) {
            [self createAlbumDirectoryWithPassword:password];
        }

        
        /*
        NSArray *passwords = [globalHelper search:[PasswordInfo class] where:nil orderBy:nil offset:0 count:0];
        for (PasswordInfo *tempPassword in passwords) {// 2
            if ([tempPassword.password isEqualToString:password]) {
                if (tempPassword.isMainPassword) {
                    [self.delegate handleCreateAPassword:password Sucess:NO alreadyExist:YES];//已存在此密码为主密码
                    return;
                }
                else{//和主密码不同
                    [defaultManger removeItemAtPath:passwordDirectory error:nil];
                    BOOL success = [globalHelper deleteToDB:tempPassword];
                }
            }
        }
        PasswordInfo *mainPassword = [[PasswordInfo alloc]init];
        mainPassword.password = password;
        BOOL success = [globalHelper insertToDB:mainPassword];
        if (success) {
            [self createAlbumDirectoryWithPassword:password];
            [self.delegate handleCreateAPassword:password Sucess:YES alreadyExist:NO];
        }
         */
    }
}

- (void)createAlbumDirectoryWithPassword:(NSString *)password{
    NSFileManager *defaultManger = [NSFileManager defaultManager];
    NSString *passwordDirectory = [NSString stringWithFormat:@"%@/%@",fileManager.rootDirectory,password];
    
    [defaultManger createDirectoryAtPath:passwordDirectory withIntermediateDirectories:YES attributes:nil error:nil];//创建密码文件夹
    
    [defaultManger createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",passwordDirectory,kAlbum] withIntermediateDirectories:YES attributes:nil error:nil];//创建相册文件夹
    [defaultManger createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",passwordDirectory,kVideo] withIntermediateDirectories:YES attributes:nil error:nil];//创建视频文件夹
}

- (void)savePhoto:(PhotoInfo *)photoInfo withPassword:(NSString *)password{
    NSFileManager *defaultManger = [NSFileManager defaultManager];
    LKDBHelper *globalHelper = [AppDelegate getUsingLKDBHelper];
    [globalHelper search:nil column:nil where:nil orderBy:nil offset:0 count:0];
    NSString *photoDirectory = [NSString stringWithFormat:@"%@/%@/%@",self.rootDirectory,password,kAlbum];
    BOOL success = NO;
    
    if ([defaultManger fileExistsAtPath:photoDirectory isDirectory:nil]) {
        NSArray *allDateDirectories = [defaultManger contentsOfDirectoryAtPath:photoDirectory error:nil];//检查是否某个时期的图片文件夹
        for (NSString *dateStr in allDateDirectories) {
            if ([dateStr isEqualToString:@".DS_Store"]) {
                continue;
            }
            
            if ([photoInfo.date isEqualToString:dateStr]) {
                NSString *photoPath = [NSString stringWithFormat:@"%@/%@/%@",photoDirectory,dateStr,photoInfo.name];
                if (![defaultManger fileExistsAtPath:photoPath]) {
                    if ([photoInfo.name hasSuffix:@"png"] || [photoInfo.name hasSuffix:@"PNG"]) {
                        success = [UIImagePNGRepresentation(photoInfo.image) writeToFile:photoPath atomically:NO];
                    }
                    else{
                        success = [UIImageJPEGRepresentation(photoInfo.image, 0.75) writeToFile:photoPath atomically:NO];
                    }
                    if (success) {
                        success = [globalHelper insertToDB:photoInfo];
                        if (success) {
                            [self.delegate handleCreateANewPhoto:photoInfo success:success alreadyExist:NO];
                        }
                    }
                }
            }
        }
    }
}

- (void)savePhotos:(NSArray *)photos withPassword:(NSString *)password{
    NSFileManager *nsFileManager = [NSFileManager defaultManager];
    LKDBHelper *dbhelper = [AppDelegate getUsingLKDBHelper];
    BOOL success = NO;
    NSInteger successCount = 0;
    PasswordInfo *passwordInfo = [dbhelper searchSingle:[PasswordInfo class] where:@"isMainPassword='1'" orderBy:nil];
    BOOL mainPassword= NO;
    if ([passwordInfo.password isEqualToString:password]) {
        mainPassword = YES;
    }
    for (ALAsset *tempAsset in photos) {
        @autoreleasepool {
            PhotoInfo *tempPhoto = [[PhotoInfo alloc]init];
            tempPhoto.mainPassword = mainPassword;
            
            ALAssetRepresentation *assetRep = [tempAsset defaultRepresentation];
            //name
            NSString *name = assetRep.filename;
            tempPhoto.name = name;
            
            //tempPhoto.cacheImageKey = name;
            
            //date
            NSString *createDate = [TooManager stringFromDate:[tempAsset valueForProperty:ALAssetPropertyDate]];
            tempPhoto.date = createDate;
            
            //image
            UIImageOrientation orientation = (UIImageOrientation)[assetRep orientation];
            //CGImageRef orginImageRef = nil;
            UIImage *image = [UIImage imageWithCGImage:[assetRep fullResolutionImage] scale:1.0f orientation:orientation];
            
            // thumnail image
            tempPhoto.thumnailImage = [UIImage imageWithCGImage:tempAsset.thumbnail];
            // 地理位置等信息
            CLLocation* wgs84Location = [tempAsset valueForProperty:ALAssetPropertyLocation];
            if (wgs84Location) {//判断是否在拍照时有开启定位，只有在开启了定位才能得到地理信息
                //纬度
                tempPhoto.latitude = [NSString stringWithFormat:@"%f",wgs84Location.coordinate.latitude];
                //经度
                tempPhoto.longitude = [NSString stringWithFormat:@"%f",wgs84Location.coordinate.longitude];
                //海拔
                tempPhoto.altitude = [NSString stringWithFormat:@"%f",wgs84Location.horizontalAccuracy];
            }
            
            NSString *imageDateDirectory = [NSString stringWithFormat:@"%@/%@/%@/%@",self.rootDirectory,password,kAlbum,createDate];
            if (![nsFileManager fileExistsAtPath:imageDateDirectory]){//根据照片的创建日期查找某个相册下这一时期的文件夹是否存在。若不存在，则创建。
                [nsFileManager createDirectoryAtPath:imageDateDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",imageDateDirectory,name];
            if (![nsFileManager fileExistsAtPath:imagePath]){// 判断该照片是否存在，不存在则存储
                
                NSData *imageData= nil;
                NSString *extension = [name pathExtension];
                if ([extension isEqualToString:@"png"] || [extension isEqualToString:@"PNG"]) {
                    imageData = UIImagePNGRepresentation(image);
                }
                else{
                    imageData = UIImageJPEGRepresentation(image, 0.75);
                }
                
                success = [imageData writeToFile:imagePath atomically:NO];
                
                if (success) {//大图存储成功
                    tempPhoto.imagePath = imagePath;
                    success = [dbhelper insertToDB:tempPhoto];
                    if (success) {//数据库存储成功
                        successCount ++;
                    }
                }
            }
        }
        
    }
    [self.delegate handleCreatePhotosSuccess:successCount failedCount:(photos.count - successCount)];
}

- (void)deletePhotosByPassword:(NSString *)password{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if([defaultManager removeItemAtPath:password error:nil]){
        [self.delegate handleDeletePassword:password success:YES];
    }
}

- (void)deletePhotosByPassword:(NSString *)password photos:(NSArray *)photoInfos{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    LKDBHelper *dbhelper = [AppDelegate getUsingLKDBHelper];
    NSInteger successCount = 0;
    for (PhotoInfo *tempPhoto in photoInfos) {
        NSString *photoPath = [NSString stringWithFormat:@"%@/%@/Album/%@/%@",self.rootDirectory,password,tempPhoto.date,tempPhoto.name];
        BOOL success = [defaultManager removeItemAtPath:photoPath error:nil];
        if (success) {
            if ([dbhelper deleteToDB:tempPhoto]) {
                successCount ++;
            }
        }
    }
    [self.delegate handleDeletePhotoWithPasswordSuccessCount:successCount failedCount:(photoInfos.count - successCount)];
}

- (void)updatePhoto:(PhotoInfo *)photo byPassword:(NSString *)password{
    LKDBHelper *globalHelper = [AppDelegate getUsingLKDBHelper];
    if ([globalHelper updateToDB:photo where:nil]) {
        //[self.delegate handleUpdatePhoto:photo success:YES];
        [[GeocoderManager sharedGeocoderManager]cancel];
        [[GeocoderManager sharedGeocoderManager]beginGeo:PickerTypePhotos];
    }
}

- (void)updateCurrentPassword:(NSString *)currentPassword toNewPassword:(NSString *)newPassword{
    NSFileManager *defaultMangaer = [NSFileManager defaultManager];
    LKDBHelper *globalHelper = [AppDelegate getUsingLKDBHelper];
    NSError *error = nil;
    BOOL success = [defaultMangaer moveItemAtPath:[NSString stringWithFormat:@"%@/%@",self.rootDirectory,currentPassword] toPath:[NSString stringWithFormat:@"%@/%@",self.rootDirectory,newPassword] error:&error];
    if (success) {
        success =[globalHelper updateToDB:[PasswordInfo class] set:[NSString stringWithFormat:@"password=%@",newPassword] where:[NSString stringWithFormat:@"password=%@",currentPassword]];
    }
    [self.delegate handleUpdateCurrentPassword:currentPassword newPassword:newPassword success:success error:error];
}

- (void)selectPhotosWithPassword:(NSString *)password{
    NSMutableArray *messagePhotosArray = [NSMutableArray array];
    LKDBHelper *globalHelper = [AppDelegate getUsingLKDBHelper];
    
    NSString *albumDirectory = [NSString stringWithFormat:@"%@/%@/Album",self.rootDirectory,password];
    PasswordInfo *passwordInfo = [globalHelper searchSingle:[PasswordInfo class] where:@"isMainPassword='0'" orderBy:nil];
    BOOL mainPassword = NO;
    if (![passwordInfo.password isEqualToString:password]) {
        mainPassword = YES;
    }
    BOOL isDirectory=NO;
    NSFileManager *nsFileManager = [NSFileManager defaultManager];
    if ([nsFileManager fileExistsAtPath:albumDirectory isDirectory:&isDirectory]&&isDirectory) {
        NSArray *allDirectories = [nsFileManager contentsOfDirectoryAtPath:albumDirectory error:nil];//检查是否某个时期的图片文件夹
        if (allDirectories.count>0) {//相册下没有相片
        
            for (NSString *date in allDirectories) {
                if ([date isEqualToString:@".DS_Store"]) {
                    continue;
                }
                @autoreleasepool {
                    NSString *photosDirectory = [NSString stringWithFormat:@"%@/%@",albumDirectory,date];
                    
                    if ([nsFileManager fileExistsAtPath:photosDirectory isDirectory:&isDirectory]&&isDirectory) {//日期文件夹
                        NSMutableArray *photosArray = [NSMutableArray array];
                        for (NSString *photoName in [nsFileManager contentsOfDirectoryAtPath:photosDirectory error:nil]) {//循环某个时期下的图的个数
                            
                            if ([photoName isEqualToString:@".DS_Store"]) {
                                continue;
                            }
                            
                            NSString *photoPath = [NSString stringWithFormat:@"%@/%@",photosDirectory,photoName];
                            PhotoInfo *photoInfo = [globalHelper searchSingle:[PhotoInfo class] where:[NSString stringWithFormat:@"name='%@' AND mainPassword=%i",photoName,mainPassword?1:0] orderBy:nil];
                            
                            
                            if (photoInfo) {
                                NSLog(@"photoPath:%@\nimagePath:%@",photoPath,photoInfo.imagePath);
                                photoInfo.imagePath = photoPath;
                                /*
                                if ([shareImageCache objectForKey:photoInfo.cacheImageKey]) {
                                    photoInfo.image = [shareImageCache objectForKey:photoInfo.cacheImageKey];
                                }
                                else{
                                    photoInfo.image = [UIImage imageWithContentsOfFile:photoPath];
                                    [shareImageCache setObject:photoInfo.image forKey:photoInfo.cacheImageKey];
                                }
                                 */
                                /*if (![shareImageCache objectForKey:photoInfo.cacheImageKey]) {
                                    [shareImageCache setObject:photoPath forKey:photoInfo.cacheImageKey];
                                }*/
                                [photosArray addObject:photoInfo];
                                photoInfo = nil;
                            }
                            
                        }
                        if (photosArray.count>0) {
                            [messagePhotosArray addObject:photosArray];
                            photosArray = nil;
                        }
                    }

                }
                
            }
        }
    }
    [fileManager.delegate handleSelectPhotos:messagePhotosArray byPassword:password success:YES];
}

#pragma mark - Movie ----------------------------------------------------------------------------------------

- (void)saveVideos:(NSArray *)videos withPassword:(NSString *)password{
    NSFileManager *nsFileManager = [NSFileManager defaultManager];
    LKDBHelper *dbhelper = [AppDelegate getUsingLKDBHelper];
    BOOL success = NO;
    NSInteger successCount = 0;
    PasswordInfo *passwordInfo = [dbhelper searchSingle:[PasswordInfo class] where:@"isMainPassword='1'" orderBy:nil];
    BOOL mainPassword= NO;
    if ([passwordInfo.password isEqualToString:password]) {
        mainPassword = YES;
    }
    for (ALAsset *tempAsset in videos) {
        @autoreleasepool {
            VideoInfo *tempVideo = [[VideoInfo alloc]init];
            tempVideo.mainPassword = mainPassword;
            
            ALAssetRepresentation *assetRep = [tempAsset defaultRepresentation];
            //name
            NSString *name = assetRep.filename;
            tempVideo.name = name;
            
            NSString *imageName = [[name componentsSeparatedByString:@"."] objectAtIndex:0];
            imageName = [imageName stringByAppendingString:@".JPG"];
            
            
            //tempVideo.path = name;
            
            //date
            NSString *createDate = [TooManager stringFromDate:[tempAsset valueForProperty:ALAssetPropertyDate]];
            tempVideo.date = createDate;
            
            // thumnail image
            tempVideo.thumnailImage = [UIImage imageWithCGImage:tempAsset.thumbnail];
            // 地理位置等信息
            CLLocation* wgs84Location = [tempAsset valueForProperty:ALAssetPropertyLocation];
            if (wgs84Location) {//判断是否在拍照时有开启定位，只有在开启了定位才能得到地理信息
                //纬度
                tempVideo.latitude = [NSString stringWithFormat:@"%f",wgs84Location.coordinate.latitude];
                //经度
                tempVideo.longitude = [NSString stringWithFormat:@"%f",wgs84Location.coordinate.longitude];
                //海拔
                tempVideo.altitude = [NSString stringWithFormat:@"%f",wgs84Location.horizontalAccuracy];
            }
            
            NSString *videoDateDirectory = [NSString stringWithFormat:@"%@/%@/%@/%@",self.rootDirectory,password,kVideo,createDate];
            if (![nsFileManager fileExistsAtPath:videoDateDirectory]){//根据照片的创建日期查找某个相册下这一时期的文件夹是否存在。若不存在，则创建。
                [nsFileManager createDirectoryAtPath:videoDateDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            NSString *videoPath = [NSString stringWithFormat:@"%@/%@",videoDateDirectory,name];
            
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",videoDateDirectory,imageName];
            if (![nsFileManager fileExistsAtPath:imagePath]){// 判断该视频是否存在，不存在则存储
                @autoreleasepool {
                    //image
                    UIImageOrientation orientation = (UIImageOrientation)[assetRep orientation];
                    //CGImageRef orginImageRef = nil;
                    UIImage *image = [UIImage imageWithCGImage:[assetRep fullResolutionImage] scale:1.0f orientation:orientation];
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
                    success = [nsFileManager createFileAtPath:imagePath contents:imageData attributes:nil];
                }
                
                if (success) {
                    success = [nsFileManager createFileAtPath:videoPath contents:nil attributes:nil];
                }
                
                NSFileHandle *writingHandle = [NSFileHandle fileHandleForWritingAtPath:videoPath];
                int bufferSize = 1024;
                uint8_t buffer[bufferSize];
                unsigned long long read = 0,length = 0;
                @autoreleasepool {
//                    int n = 0;
                    for (;read < assetRep.size;)
                    {
//                        if (n % 10 == 0)
//                        {
//                            
//                        }
                        length = [assetRep getBytes:buffer fromOffset:read length:bufferSize error:nil];
                        read += length;
                        NSData *fileData = [NSData dataWithBytes:(const void *)buffer length:(NSUInteger)length];
                        [writingHandle writeData:fileData];
//                        n++;
                    }
                    [writingHandle closeFile];
                }
                tempVideo.path = videoPath;
                tempVideo.imagePath = imagePath;
                
                success = [dbhelper insertToDB:tempVideo];
                if (success) {//数据库存储成功
                    successCount ++;
                }
            }
        }
        
    }
    [self.delegate handleCreateVideosSuccess:successCount failedCount:(videos.count - successCount)];
}

- (void)saveVideo:(VideoInfo *)video withPassword:(NSString *)password{
    
}

- (void)selectVideosWithPassword:(NSString *)password{
    NSMutableArray *messageVideosArray = [NSMutableArray array];
    LKDBHelper *globalHelper = [AppDelegate getUsingLKDBHelper];
    //ImageCache *shareImageCache = [ImageCache shareImageCache];
    
    NSString *videoDirectory = [NSString stringWithFormat:@"%@/%@/Video",self.rootDirectory,password];
    PasswordInfo *passwordInfo = [globalHelper searchSingle:[PasswordInfo class] where:@"isMainPassword='0'" orderBy:nil];
    BOOL mainPassword = NO;
    if (![passwordInfo.password isEqualToString:password]) {
        mainPassword = YES;
    }
    BOOL isDirectory=NO;
    NSFileManager *nsFileManager = [NSFileManager defaultManager];
    if ([nsFileManager fileExistsAtPath:videoDirectory isDirectory:&isDirectory]&&isDirectory) {
        NSArray *allDirectories = [nsFileManager contentsOfDirectoryAtPath:videoDirectory error:nil];//检查是否某个时期的视频文件夹
        if (allDirectories.count>0) {//文件夹下没有视频
            
            for (NSString *date in allDirectories) {
                if ([date isEqualToString:@".DS_Store"]) {
                    continue;
                }
                @autoreleasepool {
                    NSString *videosDirectory = [NSString stringWithFormat:@"%@/%@",videoDirectory,date];
                    
                    if ([nsFileManager fileExistsAtPath:videosDirectory isDirectory:&isDirectory]&&isDirectory) {//日期文件夹
                        NSMutableArray *videosArray = [NSMutableArray array];
                        for (NSString *photoName in [nsFileManager contentsOfDirectoryAtPath:videosDirectory error:nil]) {//循环某个时期下的图的个数
                            
                            if ([photoName isEqualToString:@".DS_Store"]) {
                                continue;
                            }
                            
                            NSString *videoPath = [NSString stringWithFormat:@"%@/%@",videosDirectory,photoName];
                            
                            VideoInfo *videoInfo = [globalHelper searchSingle:[VideoInfo class] where:[NSString stringWithFormat:@"name='%@' AND mainPassword=%i",photoName,mainPassword?1:0] orderBy:nil];
                            
                            
                            if (videoInfo) {
                                /*
                                 if ([shareImageCache objectForKey:photoInfo.cacheImageKey]) {
                                 photoInfo.image = [shareImageCache objectForKey:photoInfo.cacheImageKey];
                                 }
                                 else{
                                 photoInfo.image = [UIImage imageWithContentsOfFile:photoPath];
                                 [shareImageCache setObject:photoInfo.image forKey:photoInfo.cacheImageKey];
                                 }
                                 */
//                                if (![shareImageCache objectForKey:photoInfo.cacheImageKey]) {
//                                    [shareImageCache setObject:photoPath forKey:photoInfo.cacheImageKey];
//                                }
                                videoInfo.path = videoPath;
                                NSString *imagePath = [[videoPath componentsSeparatedByString:@"."] objectAtIndex:0];
                                imagePath = [imagePath stringByAppendingString:@".JPG"];
                                videoInfo.imagePath = imagePath;
                                [videosArray addObject:videoInfo];
                                videoInfo = nil;
                            }
                            
                        }
                        if (videosArray.count>0) {
                            [messageVideosArray addObject:videosArray];
                            videosArray = nil;
                        }
                    }
                    
                }
                
            }
        }
    }
    [fileManager.delegate handleSelectVideos:messageVideosArray byPassword:password success:YES];
}

- (void)deleteVideos:(NSArray *)videos byPassword:(NSString *)password{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    LKDBHelper *dbhelper = [AppDelegate getUsingLKDBHelper];
    NSInteger successCount = 0;
    for (VideoInfo *tempVideo in videos) {
       // NSString *videoPath = [NSString stringWithFormat:@"%@/%@/Video/%@/%@",self.rootDirectory,password,tempVideo.date,tempVideo.name];
        NSString *videoPath = tempVideo.path;
        NSString *imagePath = tempVideo.imagePath;
        
        BOOL success = [defaultManager removeItemAtPath:videoPath error:nil];
        if (success) {
            success = [defaultManager removeItemAtPath:imagePath error:nil];
            if (success) {
                if ([dbhelper deleteToDB:tempVideo]) {
                    successCount ++;
                }
            }
        }
    }
    [self.delegate handleDeleteVideosWithPasswordSuccessCount:successCount failedCount:videos.count - successCount];
}
- (void)updateVideo:(VideoInfo *)video byPassword:(NSString *)password{
    LKDBHelper *globalHelper = [AppDelegate getUsingLKDBHelper];
    if ([globalHelper updateToDB:video where:nil]) {
        //[self.delegate handleUpdatePhoto:photo success:YES];
        [[GeocoderManager sharedGeocoderManager]cancel];
        [[GeocoderManager sharedGeocoderManager]beginGeo:PickerTypeVideos];
    }
}


@end
