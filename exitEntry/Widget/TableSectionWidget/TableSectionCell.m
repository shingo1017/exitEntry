//
//  TableSectionCell.m
//  Entlphone
//
//  Created by JinYing020036 on 15/10/21.
//  Copyright © 2015年 Shingo. All rights reserved.
//

#import "TableSectionCell.h"

@implementation TableSectionCell

+ (CGFloat)suggestHeightWithArticle:(Article *)article showDateTime:(BOOL)showDateTime {
    
    CGFloat height = 12.0f;
    CGFloat width = 0;
    
    if (article.imageUrl.length > 0)
        width = SCREEN_WIDTH - 10 - 50 - 8 - 10;
    else
        width = SCREEN_WIDTH - 20;
    
    CGFloat titleHeight = [article.title heightOfAttributedText:[article.title attributedStringWithFontSize:kFontSizeTitle] width:width];
    if (article.imageUrl.length > 0 && !showDateTime && article.summary.length == 0 && titleHeight < 50) {
        
        //只有title且不高于图片高度时
        height += 50;
    }
    else {
        
        height += titleHeight;
        
        if (article.summary.length > 0) {
            
            height += 5;
            height += [article.summary heightOfAttributedText:[article.summary attributedStringWithFontSize:kFontSizeSummary] width:width];
        }
        
        if (showDateTime)
            height += 5 + 13;
        
        if (article.imageUrl.length > 0 && height < 10 + 50)
            height = 10 + 50;
    }
    
    height += 12.0f;
    
    return height;
}

- (void)setupSubviews {
    
    [self setupSubviewsWithWidth:SCREEN_WIDTH];
}

- (void)setupSubviewsWithWidth:(CGFloat)width {
    
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!_iconView) {
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.clipsToBounds = YES;
        [self addSubview:_iconView];
    }
    if (!nameLabel) {
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.top + 2, 0, 17)];
        nameLabel.font = [UIFont systemFontOfSize:kFontSizeTitle];
        nameLabel.numberOfLines = 2;
        nameLabel.textColor = TITLE_COLOR;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:nameLabel];
    }
    
    if (!summaryLabel) {
        
        summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.bottom + 5, 0, 40)];
        summaryLabel.numberOfLines = 2;
        summaryLabel.font = [UIFont systemFontOfSize:kFontSizeSummary];
        summaryLabel.textColor = SUMMARY_COLOR;
        summaryLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:summaryLabel];
    }
    
    if (!createDateLabel)
    {
        createDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, summaryLabel.bottom + 5, width - _iconView.width - 20, kFontSizeSummary)];
        createDateLabel.font = [UIFont systemFontOfSize:kFontSizeSummary];
        createDateLabel.textColor = SUMMARY_COLOR;
        createDateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:createDateLabel];
    }
}

- (void)setArticle:(Article *)article {
    
    _article = article;
    
    if (_article) {
        
        [_iconView sd_setImageWithURL:[NSURL URLWithString:_article.imageUrl]];
        nameLabel.attributedText = [_article.title attributedStringWithFontSize:nameLabel.font.pointSize textColor:nameLabel.textColor];
        summaryLabel.attributedText = [_article.summary attributedStringWithFontSize:summaryLabel.font.pointSize textColor:summaryLabel.textColor];
        createDateLabel.text = [_article.createDate longDateFormattedString];
        
        if (_article.imageUrl.length > 0) {
            
            nameLabel.left = _iconView.right + 8;
            nameLabel.width = SCREEN_WIDTH - _iconView.right - 8 - 10;
            summaryLabel.left = nameLabel.left;
            summaryLabel.width = nameLabel.width;
            createDateLabel.left = nameLabel.left;
        }
        else {
            
            nameLabel.left = _iconView.left;
            nameLabel.width = SCREEN_WIDTH - 20;
            summaryLabel.left = nameLabel.left;
            summaryLabel.width = nameLabel.width;
            createDateLabel.left = nameLabel.left;
        }
        
        nameLabel.height = [_article.title heightOfAttributedText:nameLabel.attributedText width:nameLabel.width];
        
        if (_article.imageUrl.length > 0 && !_showDateTime && _article.summary.length == 0 && nameLabel.height < _iconView.height) {
            
            //只有title且不高于图片高度时
            nameLabel.top = _iconView.top + (_iconView.height - nameLabel.height) / 2;
        }
        else {
            
            summaryLabel.top = nameLabel.bottom + 5.0f;
            
            if (_article.summary.length > 0) {
                
                if (IS_IPHONE_6P)
                    summaryLabel.height = [_article.summary textViewHeightWithAttributedString:summaryLabel.attributedText width:summaryLabel.width limitedHeight:floatByScale(38)];
                else
                    summaryLabel.height = [_article.summary textViewHeightWithAttributedString:summaryLabel.attributedText width:summaryLabel.width limitedHeight:38];
                
                createDateLabel.top = summaryLabel.bottom + 5;
            }
            else {
                
                summaryLabel.height = 0.0f;
                createDateLabel.top = summaryLabel.bottom;
            }
        }
        
        if (_showDateTime)
            createDateLabel.hidden = NO;
        else
            createDateLabel.hidden = YES;
    }
}

@end
