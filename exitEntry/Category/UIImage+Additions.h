//
//  UIImage+Additions.h
//  copybook
//
//  Created by Shingo Yabuki on 12-6-4.
//  Copyright (c) 2012年 c2y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Additions)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (UIImage *)scaleToSizeWithWidth:(CGFloat)width;
- (UIImage *)scaleToSize:(CGFloat)size;
- (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
- (UIImage *)boxblurImageWithBlur:(CGFloat)blur;
- (NSString *)htmlForBase64Encoding;

@end
