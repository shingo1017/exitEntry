//
//  TableSectionCell.h
//  Entlphone
//
//  Created by JinYing020036 on 15/10/21.
//  Copyright © 2015年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface TableSectionCell : UITableViewCell {
    
    UILabel *nameLabel;
    UILabel *summaryLabel;
    UILabel *createDateLabel;
}

@property (nonatomic, retain) Article *article;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, assign) BOOL  showDateTime;
@property (nonatomic, retain) UIImageView *iconView;

+ (CGFloat)suggestHeightWithArticle:(Article *)article showDateTime:(BOOL)showDateTime;

- (void)setupSubviews;
- (void)setupSubviewsWithWidth:(CGFloat)width;

@end
