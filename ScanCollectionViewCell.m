//
//  ScanCollectionViewCell.m
//  2048Album
//
//  Created by Jzhang on 14-12-2.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "ScanCollectionViewCell.h"

@implementation ScanCollectionViewCell
@synthesize scrollView,imageView;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        scrollView.maximumZoomScale = 2.5;
        scrollView.minimumZoomScale = 1.0f;
        scrollView.delegate = self;
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 310, self.bounds.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:scrollView];
        [scrollView addSubview:imageView];
        
        doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [doubleTap setNumberOfTouchesRequired:1];
        [scrollView addGestureRecognizer:doubleTap];
        
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        tap.numberOfTapsRequired = 1;
        [tap setNumberOfTouchesRequired:1];
        [scrollView addGestureRecognizer:tap];
        
        [tap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}
#pragma mark - UIScrollView Delegate  --- Return A View From Zoom
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView;
}
#pragma  mark - Zoom
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (scrollView.zoomScale == scrollView.maximumZoomScale) {
        // jump back to minimum scale
        [self updateZoomScaleWithGesture:gestureRecognizer newScale:scrollView.minimumZoomScale];
    }
    else {
        // double tap zooms in
        [self updateZoomScaleWithGesture:gestureRecognizer newScale:scrollView.maximumZoomScale];
    }
}

- (void)updateZoomScaleWithGesture:(UIGestureRecognizer *)gestureRecognizer newScale:(CGFloat)newScale {
    CGPoint center = [gestureRecognizer locationInView:gestureRecognizer.view];
    [self updateZoomScale:newScale withCenter:center];
}

- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center {
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:center ] ;
    [scrollView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    zoomRect.size.width = self.frame.size.width / scale;
    zoomRect.size.height = self.frame.size.height / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

#pragma mark - tap
- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    [self.delegate tapToHideToolBar:tapGestureRecognizer];
}

@end
