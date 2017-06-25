//
//  CollectionSectionWidget.h
//  novel
//
//  Created by 尹楠 on 15/11/24.
//  Copyright © 2015年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderWidget.h"
#import "Article.h"

@protocol CollectionSectionWidgetDelegate;

@interface CollectionSectionWidget : UIView <UICollectionViewDataSource, UICollectionViewDelegate> {
    
    SectionHeaderWidget *sectionHeaderWidget;
    UICollectionView *collectionView;
    UIView *lineView;
}

@property (nonatomic, weak) id<CollectionSectionWidgetDelegate> delegate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSArray *articles;

- (CGFloat)suggestHeight;
- (void)reloadData;

@end

@protocol CollectionSectionWidgetDelegate <NSObject>

@optional

- (void)didClickedCollectionSectionWidgetMoreButton:(CollectionSectionWidget *)collectionSectionWidget;
- (void)collectionSectionWidget:(CollectionSectionWidget *)collectionSectionWidget didClickedArticle:(Article *)article;

@end
