//
//  UILabel+Extend.m
//  library
//
//  Created by Shingo on 13-8-2.
//  Copyright (c) 2013年 Shingo. All rights reserved.
//

#import "UILabel+Extend.h"

@implementation UILabel(Extend)

- (void)fitSize {
    
    return [self fitSizeWithHeightLimited:0.0f];
}

- (void)fitSizeWithHeightLimited:(CGFloat)heightLimited {
    
    CGFloat height = 0.0f;
    if (heightLimited > 0.0f)
        height = [self.text heightOfTextWithWidth:self.frame.size.width height:heightLimited theFont:self.font];
    else
        height = [self.text heightOfTextWithWidth:self.frame.size.width theFont:self.font];
    
    self.height = height;
}

- (void)resetAttributedTextWithText:(NSString *)text range:(NSRange)range {
    
    NSAttributedString *attributedString = self.attributedText;
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]initWithAttributedString:attributedString];
    [mutableAttributedString beginEditing];
    [mutableAttributedString replaceCharactersInRange:range withString:text];
    [mutableAttributedString endEditing];
    self.attributedText = mutableAttributedString;
}

- (void)addAttributedText:(NSDictionary *)attributedTextDictionary {
    
    [self addAttributedText:attributedTextDictionary range:NSMakeRange(0, self.text.length)];
}

- (void)addAttributedText:(NSDictionary *)attributedTextDictionary range:(NSRange)range {
    
    NSAttributedString *attributedString = self.attributedText;
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]initWithAttributedString:attributedString];
    [mutableAttributedString beginEditing];
    [mutableAttributedString addAttributes:attributedTextDictionary range:range];
    [mutableAttributedString endEditing];
    self.attributedText = mutableAttributedString;
}

- (void)addAttributedTextWithFontName:(NSString*)fontName fontSize:(CGFloat)fontSize {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = TEXT_SPACING_FOR_LINE;
    NSDictionary *attributedString = @{ NSFontAttributeName:[UIFont fontWithName:fontName size:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
    [self addAttributedText:attributedString];
}

- (void)addAttributedTextWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize range:(NSRange)range {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = TEXT_SPACING_FOR_LINE;
    NSDictionary *attributedString = @{ NSFontAttributeName:[UIFont fontWithName:fontName size:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
    [self addAttributedText:attributedString range:range];
}

- (void)addAttributedTextWithHighlightColor:(UIColor *)color betweenIndex:(NSInteger)startIndex andIndex:(NSInteger)lastIndex {
    
    int length = self.text.length - lastIndex - startIndex;
    NSDictionary *attributedString = @{NSForegroundColorAttributeName:color};
    [self addAttributedText:attributedString range:NSMakeRange(startIndex, length)];
}

@end
