//
//  SectionHeadercCollectionViewLayout.m
//  XDSectionCollectionView
//
//  Created by 张旭东 on 15/9/9.
//  Copyright (c) 2015年 张旭东. All rights reserved.
//

#import "SectionHeadercCollectionViewLayout.h"

@implementation SectionHeadercCollectionViewLayout

-(NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    
   
    NSMutableArray *attributes =[[super layoutAttributesForElementsInRect:rect] mutableCopy];
    UICollectionView * const cv =self.collectionView;
    CGPoint const contentOffset =cv.contentOffset;
    
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for(UICollectionViewLayoutAttributes *layoutAttributes in attributes){
        if (layoutAttributes.representedElementCategory ==  UICollectionElementCategoryCell) {
            if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                continue;
            }
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    
    
//    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
//        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
//        if (layoutAttributes != nil)  [attributes addObject:layoutAttributes];
//    }];
    
//    NSPredicate *sectionPredicate = [NSPredicate predicateWithFormat:@"representedElementCategory == 0 and representedElementKind != 'UICollectionElementKindSectionHeader'"];
//    NSArray *sections = [attributes  filteredArrayUsingPredicate:sectionPredicate];

    
    for(UICollectionViewLayoutAttributes *layoutAttributes in attributes){
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];
            
            NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1))inSection:section];
            
            UICollectionViewLayoutAttributes *firstObjectAttrs;
            UICollectionViewLayoutAttributes *lastObjectAttrs;
            
            if(numberOfItemsInSection > 0) {
                
                firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
                
            } else{
                
                firstObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                       atIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                      atIndexPath:lastObjectIndexPath];
                if (lastObjectAttrs == nil){
                    lastObjectAttrs = firstObjectAttrs;
                }
                
            }
            
            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
            CGPoint origin = layoutAttributes.frame.origin;

            origin.y =MIN(MAX(contentOffset.y + cv.contentInset.top,
                              (CGRectGetMinY(firstObjectAttrs.frame) -headerHeight)
                              ),
                          (CGRectGetMaxY(lastObjectAttrs.frame) - headerHeight)
                          );
            
            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){
                .origin = origin,
                .size =layoutAttributes.frame.size
            };
            
        }
        
    }
    
    return attributes;
    
}




-(BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    
    return YES;
    
}

@end
