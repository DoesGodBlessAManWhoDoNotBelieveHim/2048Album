//
//  ScanCollectionViewCell.h
//  2048Album
//
//  Created by Jzhang on 14-12-2.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanCollectionViewCellDelegate <NSObject>

- (void)tapToHideToolBar:(UITapGestureRecognizer *)tap;

@end

@interface ScanCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>{
    UITapGestureRecognizer *doubleTap;
    UITapGestureRecognizer *tap;
}

@property (strong,nonatomic) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) NSInteger tagIndex;

@property (nonatomic, assign) id<ScanCollectionViewCellDelegate>delegate;

@end
