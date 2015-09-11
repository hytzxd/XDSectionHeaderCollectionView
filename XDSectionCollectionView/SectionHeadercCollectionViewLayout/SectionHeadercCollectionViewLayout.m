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
    
    //取得当前所显示的rect内所有的item信息
    NSMutableArray *attributes =[[super layoutAttributesForElementsInRect:rect] mutableCopy];
    UICollectionView * const cv =self.collectionView;
    CGPoint const contentOffset =cv.contentOffset;
    //missingSections 所有在区域内
    NSMutableIndexSet *missingSectionIndexSets = [NSMutableIndexSet indexSet];
    for(UICollectionViewLayoutAttributes *layoutAttributes in attributes){
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                continue;
            }
            [missingSectionIndexSets addIndex:layoutAttributes.indexPath.section];
        }
    }
    //遍历当前屏幕中没有header的section数组
    [missingSectionIndexSets enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
        //取到当前section中第一个item的indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        //获取当前section在正常情况下已经离开屏幕的header结构信息
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        //如果当前分区确实有因为离开屏幕而被系统回收的header
        if (attribute)[attributes addObject:attribute];
    }];
    
    //遍历现在屏幕上所有的item
    for(UICollectionViewLayoutAttributes *layoutAttributes in attributes){
         //如果是sectionHeader的属性我们将重新计算他的位置
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]){
            //获得当前sectionHeader所在的section
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];
            //firstObjectIndexPath 当前的第一个section的第一个item
            //lastObjectIndexPath  当前的第一个section的最后一个item
            NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:MAX(0,(numberOfItemsInSection - 1))
                                                                   inSection:section];
            UICollectionViewLayoutAttributes *firstObjectAttrs;
            UICollectionViewLayoutAttributes *lastObjectAttrs;
            //如果当前的section没有item那么他的attribute就是父类提供的因为他不会浮动啊
            if(numberOfItemsInSection > 0) {
                firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
            }else{
                firstObjectAttrs =
                [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                        atIndexPath:firstObjectIndexPath];
                lastObjectAttrs =
                [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                      atIndexPath:lastObjectIndexPath];
                if (lastObjectAttrs == nil)lastObjectAttrs = firstObjectAttrs;
            }
            //headerHeight 当前section的高 origin 就是我们要计算
            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
            CGPoint origin = layoutAttributes.frame.origin;
            /**
             *  重点来了
             *  我们来计算这个sectionheader的frame
             *  ------------------------------------------------------
             *
             *  首先让我考虑一下sectionHeader的几个位置
             *  1, 在当前section的第一个item之上（也就是sectionheader在屏幕中央时候的情况）
             *  他的origin y 可以表示为  当前的第一个item的frame.origin.y - headerHeight
             *  2, 在屏幕的最上边漂浮着那么他的表示就比较简单了
             *  contentOffset.y + cv.contentInset.top
             *  3, 在最后一个header的后边飘着 这种情况是 将要被推出屏幕是的样子
             *  CGRectGetMaxY(lastObjectAttrs.frame) - headerHeight
             *  --------------------------------------------------------
             *  三种情况很好考虑 但是现在到底是那种情况呢
             *  先来个简单的 1 和 2 我们选择最大的 要保证section是漂浮着的如果 sectionHeader在屏幕中间，那么他总是比1大
                如果将要出屏幕那么他总是比1小 所以我们选择最大的
             *  剩下的就好选了我们选择最小的，因为我们要保证header是随着最后一个出屏幕的
             */
            //在顶部的时候
            CGFloat topY = contentOffset.y + cv.contentInset.top;
            //正常情况下
            CGFloat normalY = CGRectGetMinY(firstObjectAttrs.frame) - headerHeight + self.sectionInset.top;
            CGFloat missingY = CGRectGetMaxY(lastObjectAttrs.frame) - headerHeight + self.sectionInset.bottom;
            origin.y = MIN(MAX(topY, normalY), missingY);
            //这个是为了让当前的突出以下，没别的意思
            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){
                                                .origin = origin,
                                                .size =layoutAttributes.frame.size
                                             };
            
        }
        
    }
    
    return [attributes copy];
    
}




-(BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

@end
