//
//  CollectionSectionWidget.m
//  novel
//
//  Created by 尹楠 on 15/11/24.
//  Copyright © 2015年 Shingo. All rights reserved.
//

#import "CollectionSectionWidget.h"
#import "CollectionSectionCell.h"

@implementation CollectionSectionWidget

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
    
        self.backgroundColor = [UIColor whiteColor];
//        [self borderStyle];
        
        sectionHeaderWidget = (SectionHeaderWidget *)[UIView viewWithName:@"SectionHeaderWidget"];
        sectionHeaderWidget.frame = CGRectMake(0, 0, self.width, 50.0f);
        sectionHeaderWidget.rightButtonTitle = text(@"更多");
        sectionHeaderWidget.rightButtonEnabled = YES;
        [sectionHeaderWidget addRightButtonClickedHandler:self action:@selector(moreButtonClicked:)];
        [self addSubview:sectionHeaderWidget];
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50.0f, self.width, frame.size.height - 50.0f) collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[CollectionSectionCell class]forCellWithReuseIdentifier:@"CollectionSectionCell"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.scrollEnabled = NO;
        [self addSubview:collectionView];
    }
    
    return self;
}

- (void)moreButtonClicked:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(didClickedCollectionSectionWidgetMoreButton:)])
        [_delegate didClickedCollectionSectionWidgetMoreButton:self];
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    
    if (_title)
        sectionHeaderWidget.title = _title;
}

- (void)setArticles:(NSArray *)articles {
    
    _articles = articles;
    
    if (_articles) {
        
        [collectionView reloadData];
    }
}

- (void)reloadData {
    
    [collectionView reloadData];
}

- (CGFloat)suggestHeight {
    
    CGFloat height = 0.0f;
    if (_articles.count <= 3) {
        
        if (IS_IPHONE_6P)
            height = 187 + 15;
        else
            height = 172 + 15;
    }
    else {
        
        if (IS_IPHONE_6P)
            height = 187 * 2 + 15;
        else
            height = 172 * 2 + 15;
    }
    
    collectionView.top = 50.0f;
    collectionView.height = height;
    
    lineView.top = collectionView.top + height - 0.5f;
    
    return collectionView.top + height;
}

#pragma mark UICollectionViewDataSource method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _articles.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    if (IS_IPHONE_5)
        return 5.0f;
    else
        return floatByScale(10.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    if (IS_IPHONE_6P)
        size = CGSizeMake(102, 187);
    else
        size = CGSizeMake(90, 172);
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (IS_IPHONE_5)
        return UIEdgeInsetsMake(0, 15, 10, 15);
    else
        return UIEdgeInsetsMake(0, 28, 10, 27);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"CollectionSectionCell";
    CollectionSectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setupSubviews];
    
    Article *article = [_articles objectAtIndex:indexPath.row];
    cell.article = article;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    Article *article = [_articles objectAtIndex:indexPath.row];
    
    if (_delegate && [_delegate respondsToSelector:@selector(collectionSectionWidget:didClickedArticle:)])
        [_delegate collectionSectionWidget:self didClickedArticle:article];
}

@end

