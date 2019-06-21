//
//  YZXCollectionViewFlowLayout.m
//  YZXCollectionViewFlowLayout
//
//  Created by 尹星 on 2019/6/19.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "YZXCollectionViewFlowLayout.h"
#import "YZXCollectionDecorationView.h"
#import "ViewController.h"

static NSString *const kYZXDECORATIONVIEW = @"yzx_decoration_view";

@interface YZXCollectionViewFlowLayout ()

@end

@implementation YZXCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    // 注册DecorationView
    [self registerClass:[YZXCollectionDecorationView class] forDecorationViewOfKind:kYZXDECORATIONVIEW];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    // 当滑动collectionview时，重新布局
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    // 设置DecorationView的frame
    if (elementKind == kYZXDECORATIONVIEW) {
        // 获取对应section的items
        NSInteger items = [self.collectionView numberOfItemsInSection:indexPath.section];
        CGRect decorationViewRect = CGRectZero;
        UIEdgeInsets insert = [self p_returenSectionInsetWithSection:indexPath.section];
        if (items > 0) {
            // 获取每个section的第一个item的布局信息
            UICollectionViewLayoutAttributes *firstItemAtt = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]];
            // 获取每个section的最后一个item的布局信息
            UICollectionViewLayoutAttributes *lastItemAtt = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:items - 1 inSection:indexPath.section]];
            decorationViewRect = CGRectMake(0.0, firstItemAtt.frame.origin.y - insert.top, self.collectionView.frame.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right, lastItemAtt.frame.origin.y + lastItemAtt.frame.size.height - firstItemAtt.frame.origin.y + insert.top + insert.bottom);
        }else {
            UICollectionViewLayoutAttributes *headerViewAtts = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
            decorationViewRect = CGRectMake(0.0, headerViewAtts.frame.origin.y + headerViewAtts.frame.size.height, self.collectionView.frame.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right, insert.bottom + insert.top);
        }
        // 初始化背景view的布局信息
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kYZXDECORATIONVIEW withIndexPath:indexPath];
        // 设置背景view的frame
        attributes.frame = decorationViewRect;
        // 设置层级
        attributes.zIndex -= 1;
        return attributes;
        return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
    }
    return nil;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 获取collectionview所有控件的布局信息（cell，header，footer，decroationView(如果存在的话)）
    NSArray <UICollectionViewLayoutAttributes *> *arr = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray <UICollectionViewLayoutAttributes *> *mutArr = [arr mutableCopy];

    // 获取collectionview的setion的数量
    NSInteger sections = [self.collectionView numberOfSections];
    
    //创建存索引的数组，无符号（正整数），无序（不能通过下标取值），不可重复（重复的话会自动过滤）
    NSMutableIndexSet *noneHeaderSections = [NSMutableIndexSet indexSet];
    //遍历mutArr，得到一个当前屏幕中所有的section数组
    for (UICollectionViewLayoutAttributes *attributes in mutArr) {
        //如果当前的元素分类是一个cell，将cell所在的分区section加入数组，重复的话会自动过滤
        if (attributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            [noneHeaderSections addIndex:attributes.indexPath.section];
        }
    }

    //遍历mutArr，将当前屏幕中拥有的header的section从数组中移除，得到一个当前屏幕中没有header的section数组
    //正常情况下，随着手指往上移，header脱离屏幕会被系统回收而cell尚在，也会触发该方法
    for (UICollectionViewLayoutAttributes *attributes in mutArr) {
        //如果当前的元素是一个header，将header所在的section从数组中移除
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [noneHeaderSections removeIndex:attributes.indexPath.section];
        }
    }
    
    //遍历当前屏幕中没有header的section数组
    [noneHeaderSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
        
        //取到当前section中第一个item的indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        //获取当前section在正常情况下已经离开屏幕的header结构信息
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        //如果当前分区确实有因为离开屏幕而被系统回收的header
        if (attributes) {
            // 将该header结构信息重新加入到superArray中去
            [mutArr addObject:attributes];
        }
    }];
    
    // 遍历所有控件布局信息
    for (UICollectionViewLayoutAttributes *attributes in mutArr) {
        // 如果该控件布局信息属于header的
        if (attributes.representedElementKind == UICollectionElementKindSectionHeader) {
            NSInteger section = attributes.indexPath.section;
            CGRect headerViewFrame = attributes.frame;
            // 获取该section中所有的item数量
            NSInteger items = [self.collectionView numberOfItemsInSection:section];
            // 获取section的insert
            UIEdgeInsets insert = [self p_returenSectionInsetWithSection:section];
            // 第一个indexPath和最后一个secondIndexPath
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *secondIndexPath = [NSIndexPath indexPathForItem:items - 1 inSection:section];
            // 获取该section最后一个item
            UICollectionViewLayoutAttributes *firstItemAtts, *lastItemsAtts;
            if (items > 0) {
                firstItemAtts = [self layoutAttributesForItemAtIndexPath:firstIndexPath];
                lastItemsAtts = [self layoutAttributesForItemAtIndexPath:secondIndexPath];
            }else {
                firstItemAtts = [[UICollectionViewLayoutAttributes alloc] init];
                firstItemAtts.frame = CGRectMake(0.0, CGRectGetMaxY(headerViewFrame) + insert.top, CGFLOAT_MIN, CGFLOAT_MIN);
                lastItemsAtts = firstItemAtts;
            }

            // 判断collectionview的偏移量和headerView顶部的位置大小，谁大就将其设置为headerView的origin.y
            CGFloat maxY = MAX(self.collectionView.contentOffset.y + self.navigationBarHeight, headerViewFrame.origin.y);
            // 判断headerView的origin.y是否达到section内容大小的最大值 - headerView的高度的位置，取其小，将headerView固定到该位置
            headerViewFrame.origin.y = MIN(maxY, CGRectGetMaxY(lastItemsAtts.frame) + insert.bottom - headerViewFrame.size.height);
            
            attributes.frame = headerViewFrame;
            
            attributes.zIndex = 3;
        }
    }
    
    // 添加DecorationView
    if (sections == 0) {
        return arr;
    }
    
    for (int i = 0; i<sections; i++) {
        UICollectionViewLayoutAttributes *decorationViewAtts = [self layoutAttributesForDecorationViewOfKind:kYZXDECORATIONVIEW atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        if (decorationViewAtts && CGRectIntersectsRect(rect, decorationViewAtts.frame)) {
            [mutArr addObject:decorationViewAtts];
        }
    }
    
    return [mutArr copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if (elementKind == UICollectionElementKindSectionHeader) {
        UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
        return attributes;
    }
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}

// 获取设置的每个section的insert，如果没有设置则取
- (UIEdgeInsets)p_returenSectionInsetWithSection:(NSInteger)section
{
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:yzx_layout:insetForSectionAtIndex:)]) {
        return [_delegate collectionView:self.collectionView yzx_layout:self insetForSectionAtIndex:section];
    }else {
        return self.sectionInset;
    }
}

@end
