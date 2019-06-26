//
//  YZXCoverViewCollectionViewFlowLayout.m
//  YZXCollectionViewFlowLayout
//
//  Created by 尹星 on 2019/6/25.
//  Copyright © 2019 尹星. All rights reserved.
//

/**
 参考链接：
 
 https://blog.csdn.net/u013410274/article/details/79925531
 */

#import "YZXCoverViewCollectionViewFlowLayout.h"

@implementation YZXCoverViewCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置contentInsert，保证第一个item在屏幕中间
    CGFloat margin = (self.collectionView.frame.size.width - self.itemSize.width) / 2.0;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, margin, 0, margin);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray <UICollectionViewLayoutAttributes *> *arr = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attributes in arr) {
        CGRect attFrame = attributes.frame;
        // item中心点在当前屏幕的位置
        CGFloat centerX = CGRectGetMidX(attFrame) - self.collectionView.contentOffset.x;
        // item位置与屏幕中心点的距离
        CGFloat distance = fabs(centerX - self.collectionView.bounds.size.width / 2.0);
        // 根据余弦函数计算缩放比例（屏幕中心点为原点，距离屏幕宽度的3/2为 pi/2）
        CGFloat scale = cos((M_PI_2 / (self.collectionView.bounds.size.width * 3.0 / 2.0 / distance)));
        // 缩放
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return arr;
}

// UICollectionView滑动结束后的偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 当前collectionView显示的内容rect
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;

    // 获取该rect中所有的UICollectionViewLayoutAttributes
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    
    // 屏幕中间的 x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2.0;
    
    CGFloat minDelta = MAXFLOAT;
    // 遍历当前屏幕中的UICollectionViewLayoutAttributes
    for (UICollectionViewLayoutAttributes *attributes in arr) {
        // 获取屏幕中的UICollectionViewLayoutAttributes哪个距离屏幕中间 x比较近
        if (ABS(minDelta) > ABS(attributes.center.x - centerX)) {
            minDelta = attributes.center.x - centerX;
        }
    }
    // 将距离中心点最近的UICollectionViewLayoutAttributes移动到屏幕中间，重新设置collectionView的偏移量
    proposedContentOffset.x += minDelta;
    
    return proposedContentOffset;
}

@end
