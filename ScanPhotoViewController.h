//
//  ScanPhotoViewController.h
//  2048Album
//
//  Created by Jzhang on 14-12-2.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoInfo.h"
@interface ScanPhotoViewController : UICollectionViewController{
    
}

//@property (nonatomic, strong) AlbumName *album;

@property (nonatomic, assign) NSInteger comingWith;

@property (nonatomic, strong) NSMutableArray *datasourcesArray;

@property (nonatomic, assign) PickerType showType;

@end
