//
//  UILabel+Extend.h
//  library
//
//  Created by Shingo on 13-8-2.
//  Copyright (c) 2013年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(Extend)

- (void)fitSize;
- (void)fitSizeWithHeightLimited:(CGFloat)heightLimited;
- (void)resetAttributedTextWithText:(NSString *)text range:(NSRange)range;
- (void)addAttributedText:(NSDictionary *)attributedTextDictionary;
- (void)addAttributedText:(NSDictionary *)attributedTextDictionary range:(NSRange)range;
- (void)addAttributedTextWithHighlightColor:(UIColor *)color betweenIndex:(NSInteger)startIndex andIndex:(NSInteger)lastIndex;
- (void)addAttributedTextWithFontName:(NSString*)fontName fontSize:(CGFloat)fontSize;
- (void)addAttributedTextWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize range:(NSRange)range;

@end
