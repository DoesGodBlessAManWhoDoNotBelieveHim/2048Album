//
//  UIImage+Extension.m
//  2048Album
//
//  Created by Jzhang on 14-12-16.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (UIImage *)imageScaleAspectToMaxSize:(CGFloat)newSize {
    CGSize size = [self size];
    CGFloat ratio;
    if (size.width > size.height) {
        ratio = newSize / size.width;
    } else {
        ratio = newSize / size.height;
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)imageScaleAndCropToMaxSize:(CGSize)newSize {
    CGFloat largestSize = (newSize.width > newSize.height) ? newSize.width : newSize.height;
    CGSize imageSize = [self size];
    
    // Scale the image while mainting the aspect and making sure the
    // the scaled image is not smaller then the given new size. In
    // other words we calculate the aspect ratio using the largest
    // dimension from the new size and the small dimension from the
    // actual size.
    CGFloat ratio;
    if (imageSize.width > imageSize.height) {
        ratio = largestSize / imageSize.height;
    } else {
        ratio = largestSize / imageSize.width;
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, ratio * imageSize.width, ratio * imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Crop the image to the requested new size maintaining
    // the inner most parts of the image.
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    imageSize = [scaledImage size];
    if (imageSize.width < imageSize.height) {
        offsetY = (imageSize.height / 2) - (imageSize.width / 2);
    } else {
        offsetX = (imageSize.width / 2) - (imageSize.height / 2);
    }
    
    CGRect cropRect = CGRectMake(offsetX, offsetY,
                                 imageSize.width - (offsetX * 2),
                                 imageSize.height - (offsetY * 2));
    
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect([scaledImage CGImage], cropRect);
    UIImage *newImage = [UIImage imageWithCGImage:croppedImageRef];
    CGImageRelease(croppedImageRef);
    UIGraphicsEndImageContext();
    return newImage;
}


@end