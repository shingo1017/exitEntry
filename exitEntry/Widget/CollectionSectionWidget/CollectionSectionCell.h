//
//  CollectionSectionCell.h
//  Entlphone
//
//  Created by JinYing020036 on 15/10/21.
//  Copyright © 2015年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface CollectionSectionCell : UICollectionViewCell {
    
    UILabel *titleLabel;
}

@property (nonatomic, retain) Article *article;
@property (nonatomic, retain) UIImageView *imageView;

- (void)setupSubviews;

@end
