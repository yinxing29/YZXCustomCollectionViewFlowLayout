//
//  YZXCellLeftAlignedCollectionViewFlowLayout.m
//  YZXCollectionViewFlowLayout
//
//  Created by 尹星 on 2019/6/27.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "YZXCellLeftAlignedCollectionViewFlowLayout.h"

@interface YZXCellLeftAlignedCollectionViewFlowLayout ()

@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *>       *dataSource;

@property (nonatomic, strong) UICollectionViewLayoutAttributes                          *beforeCellAttributes;

@end

@implementation YZXCellLeftAlignedCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    // section个数
    NSInteger sections = [self.collectionView numberOfSections];
    // 所有indexPath数组
    NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray array];
    for (int i = 0; i<sections; i++) {
        NSInteger items = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j<items; j++) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:j inSection:i]];
        }
    }
    
    __block NSInteger section = indexPaths.firstObject.section;
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 添加header
        if (obj.section == 0) {
            [self.dataSource addObject:[super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:obj]];
            [self.dataSource addObject:[super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:obj]];
        }else if (section != obj.section) {
            [self.dataSource addObject:[super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:obj]];
            [self.dataSource addObject:[super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:obj]];
            section = obj.section;
        }
        [self.dataSource addObject:[self layoutAttributesForItemAtIndexPath:obj]];
    }];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    [self.dataSource enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, obj.frame)) {
            [array addObject:obj];
        }
    }];
    return [array copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect attFrame = attributes.frame;
    // 根据collectionView特性，当cell足够排满一排，就会自动在一行，所以只需要修改其x，让他们之间的间距为设置的minimumInteritemSpacing即可。
    if (attFrame.origin.x != self.sectionInset.left) {
        attFrame.origin.x = CGRectGetMaxX(self.beforeCellAttributes.frame) + self.minimumInteritemSpacing;
    }
    attributes.frame = attFrame;
    self.beforeCellAttributes = attributes;
    return attributes;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - ------------------------------------------------------------------------------------

@end
