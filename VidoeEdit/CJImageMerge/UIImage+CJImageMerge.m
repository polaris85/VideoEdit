//
//  UIImage+CJImageMerge.m
//  CJImageMerge
//
//  Created by Jeremy on 15/04/13.
//  Copyright (c) 2013 chaufourier. All rights reserved.
//

#import "UIImage+CJImageMerge.h"

@implementation UIImage (CJImageMerge)

+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage imagesize:(CGSize)size{
    CGImageRef firstImageRef = firstImage.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
 
    CGSize mergedSize = CGSizeMake(firstWidth, firstHeight);

    UIGraphicsBeginImageContext(mergedSize);

    [firstImage drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    [secondImage drawInRect:CGRectMake(300, 0, 536, 640)];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

@end
