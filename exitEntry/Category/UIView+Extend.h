//
//  UIView+Extend.h
//  library
//
//  Created by Shingo on 13-8-2.
//  Copyright (c) 2013年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView(Extend)

- (UIViewController *)viewController;

+ (UIView *)viewWithName:(NSString *)name;
- (void)clearBorderStyle;
- (void)searchContainerStyle;
- (void)heavyborderStyle;
- (void)lightBorderStyle;
- (void)borderStyle;
- (void)borderStyleWithColor:(UIColor *)color;
- (void)cornerRadiusStyle;
- (void)cornerRadiusStyleWithValue:(CGFloat)value;
- (void)roundStyle;
- (void)roundHeightStyle;
- (void)shadow;
- (UIColor *)colorAtPosition:(UIImage *)image position:(CGPoint)position;
- (UIColor *)colorAtPosition:(CGPoint)position;
- (UIColor *)getRGBPixelColorAtPoint:(CGPoint)point image:(UIImage *)image;
- (UIColor *)getRGBPixelColorAtPoint:(CGPoint)point;
- (CGSize)fitSize;
- (UIImage *)screenshot;
- (id)initWithScaledFrame:(CGRect)frame;
- (void)lineDockTopWithColor:(UIColor *)color;
- (void)lineDockBottomWithColor:(UIColor *)color;
- (void)lineDockLeftWithColor:(UIColor *)color;
- (void)lineDockRightWithColor:(UIColor *)color;

@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

@end
