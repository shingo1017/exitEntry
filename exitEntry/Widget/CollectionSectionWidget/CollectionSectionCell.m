//
//  CollectionSectionCell.m
//  Entlphone
//
//  Created by JinYing020036 on 15/10/21.
//  Copyright © 2015年 Shingo. All rights reserved.
//

#import "CollectionSectionCell.h"

@implementation CollectionSectionCell

- (void)setupSubviews {
    
    if (!_imageView) {

        float coverWidgetWidth = 90;
        float coverWidgetHeight = 130;
        if (IS_IPHONE_6P){
            coverWidgetWidth = 102;
            coverWidgetHeight = 145;
        }
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, coverWidgetWidth, coverWidgetHeight)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    
    if (!titleLabel) {
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.left, _imageView.bottom, _imageView.width, 42)];
        titleLabel.font = [UIFont systemFontOfSize:kFontSizeTitle];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = TITLE_COLOR;
        [self addSubview:titleLabel];
    }
}

- (void)setArticle:(Article *)article {
    
    _article = article;
    
    if (_article) {
        
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_article.imageUrl]];
        titleLabel.text = _article.title;
        titleLabel.attributedText = [titleLabel.text attributedStringWithFontSize:titleLabel.font.pointSize textColor:titleLabel.textColor];
//        titleLabel.height = [titleLabel.text heightOfAttributedText:titleLabel.attributedText width:titleLabel.width limitedHeight:floatByScale(50)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}

@end
