//
//  UIImage+Util.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/29.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

+ (UIImage*)imageWithSize:(NSString *)imageName withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;
    
    UIImage *image = [UIImage imageNamed:imageName];
    CGImageRef imageRef = image.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                destW,
                                                destH,
                                                CGImageGetBitsPerComponent(imageRef),
                                                4*destW,
                                                CGImageGetColorSpace(imageRef),
                                                (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *resultImage = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return resultImage;
}

@end
