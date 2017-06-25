//
//  HYCollectViewAlignedLayout.m
//  HYCollectionViewAlignedLayoutDemo
//
//  Created by 李思良 on 16/6/26.
//  Copyright © 2016年 lsl. All rights reserved.
//

#import "HYCollectViewAlignedLayout.h"


@interface HYCollectViewAlignedLayout ()


@end

@implementation HYCollectViewAlignedLayout


- (instancetype)initWithType:(HYCollectViewAlignType)type {
    if(self = [super init]) {
        _alignType = type;
    }
    return self;
}

#pragma mark - UICollectionViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
    
    for(int i = 0; i < [answer count]; i++) {
        
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        
        // 设置cell最大间距
        NSInteger maximumSpacing = 10;
        
        CGRect frame = currentLayoutAttributes.frame;
        frame.origin.x = self.collectionView.width - (currentLayoutAttributes.frame.size.width * (i + 1) + maximumSpacing * i);
        currentLayoutAttributes.frame = frame;
    }

    return answer;
}



- (NSArray *)getAttributesForLeft:(NSInteger)left right:(NSInteger) right offset:(CGFloat)offset originalAttributes:(NSArray *)originalAttributes {
    NSMutableArray *updatedAttributes = [NSMutableArray array];
    CGFloat currentOffset = offset;
    for(NSInteger i = left; i <= right; i ++) {
        UICollectionViewLayoutAttributes *attributes = originalAttributes[i];
        CGRect frame = attributes.frame;
        frame.origin.x = currentOffset;
        attributes.frame = frame;
        currentOffset += frame.size.width + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:attributes.indexPath.section];
        [updatedAttributes addObject:attributes];
    }
    return updatedAttributes;
}


- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIndex];
    } else {
        return self.minimumInteritemSpacing;
    }
}

- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)index
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    } else {
        return self.sectionInset;
    }
}


@end
