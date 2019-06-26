//
//  YZXWaterfallFlowCollectionViewFlowLayout.m
//  YZXCollectionViewFlowLayout
//
//  Created by 尹星 on 2019/6/20.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "YZXWaterfallFlowCollectionViewFlowLayout.h"

@interface YZXWaterfallFlowCollectionViewFlowLayout ()

/**
 滑动方向
 */
@property (nonatomic, assign) YZXWaterfallFlowCollectionViewSlidingDirection       slidingDirection;

/**
 一行（垂直滑动）或者一列（水平滑动）的item个数
 */
@property (nonatomic, assign) NSInteger                                            numberOfRows;

/**
 item的width，垂直滑动时使用
 */
@property (nonatomic, assign) CGFloat                                              itemWidth;

/**
 item的height，水平滑动时使用
 */
@property (nonatomic, assign) CGFloat                                              itemHeight;

/**
 用于记录垂直滑动时，每列的底部高度
 */
@property (nonatomic, strong) NSMutableArray                                       *columnMaxYs;

/**
 用于记录水平滑动时，每行的最大长度
 */
@property (nonatomic, strong) NSMutableArray                                       *rowMaxXs;

/**
 用于记录被修改后的UICollectionViewLayoutAttributes信息
 */
@property (nonatomic, copy) NSArray <UICollectionViewLayoutAttributes *>           *layoutAllItemsAtt;

@end

@implementation YZXWaterfallFlowCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    // 垂直滑动
    if (self.slidingDirection == YZXWaterfallFlowCollectionViewSlidingDirectionWithVerticalSliding) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 计算collectionView显示内容的宽度
        CGFloat contentWidth = self.collectionView.frame.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
        // 根据一行显示的数量，计算固定宽度
        self.itemWidth = (contentWidth - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing * (self.numberOfRows - 1)) / (CGFloat)self.numberOfRows;
    }else {// 水平滑动
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 计算collectionView显示内容的高度
        CGFloat contentHeight = self.collectionView.frame.size.height - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom - self.navigationBarHeight;
        // 根据一行显示的数量，计算固定宽度
        self.itemHeight = (contentHeight - self.sectionInset.top - self.sectionInset.bottom - self.minimumLineSpacing * (self.numberOfRows - 1)) / (CGFloat)self.numberOfRows;
    }
    
    // 初始化每行或者列的item默认的起点
    for (int i = 0; i<self.numberOfRows; i++) {
        if (self.slidingDirection == YZXWaterfallFlowCollectionViewSlidingDirectionWithVerticalSliding) {
            self.columnMaxYs[i] = @(self.sectionInset.top);
        }else {
            self.rowMaxXs[i] = @(self.sectionInset.left);
        }
    }
    
    // 遍历，获取每个修改frame后的UICollectionViewLayoutAttributes信息
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<items; i++) {
        [array addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    self.layoutAllItemsAtt = [array copy];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in self.layoutAllItemsAtt) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [mutableArr addObject:attributes];
        }
    }
    // 返回修改后的布局信息
    return [mutableArr copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *obj = [super layoutAttributesForItemAtIndexPath:indexPath];
    // 垂直滑动
    if (self.slidingDirection == YZXWaterfallFlowCollectionViewSlidingDirectionWithVerticalSliding) {
        CGRect attFrame = obj.frame;
        // 取对应的列的origin.y最大值
        attFrame.origin.y = [self.columnMaxYs[obj.indexPath.item % self.numberOfRows] floatValue];
        // 从新设置origin.x
        attFrame.origin.x = self.sectionInset.left + (self.itemWidth + self.minimumInteritemSpacing) * (obj.indexPath.item % self.numberOfRows);
        // 设置宽度为计算得到的固定宽度
        attFrame.size.width = self.itemWidth;
        // 如果设置了高度，则取其高度，否则使用原始高度
        if (self->_delegate && [self->_delegate respondsToSelector:@selector(layout:heightForRowAtIndexPath:)]) {
            attFrame.size.height = [self->_delegate layout:self heightForRowAtIndexPath:obj.indexPath];
        }
        // 修改UICollectionViewLayoutAttributes的frame信息
        obj.frame = attFrame;
        
        // 修改对应列的origin.y的最大值为该列最后的一个item的orig.y+size.height(如果不是该列最后一个item，还需要添加其行间距)
        CGFloat columnHeight = 0.0;
        if (obj.indexPath.item + self.numberOfRows >= [self.collectionView numberOfItemsInSection:obj.indexPath.section]) {
            columnHeight = CGRectGetMaxY(attFrame);
        }else {
            columnHeight = CGRectGetMaxY(attFrame) + self.minimumLineSpacing;
        }
        self.columnMaxYs[obj.indexPath.item % self.numberOfRows] = @(columnHeight);
        return obj;
    }else {// 水平滑动
        CGRect attFrame = obj.frame;
        // 取对应的列的origin.x最大值
        attFrame.origin.x = [self.rowMaxXs[obj.indexPath.item % self.numberOfRows] floatValue];
        // 从新设置origin.y
        attFrame.origin.y = self.sectionInset.top + (self.itemHeight + self.minimumLineSpacing) * (obj.indexPath.item % self.numberOfRows);
        // 设置宽度为计算得到的固定高度
        attFrame.size.height = self.itemHeight;
        // 如果设置了宽度，则取其高度，否则使用原始宽度
        if (self->_delegate && [self->_delegate respondsToSelector:@selector(layout:widthForRowAtIndexPath:)]) {
            attFrame.size.width = [self->_delegate layout:self widthForRowAtIndexPath:obj.indexPath];
        }
        // 修改UICollectionViewLayoutAttributes的frame信息
        obj.frame = attFrame;
        
        // 修改对应行的origin.x的最大值为该列最后的一个item的orig.x+size.width(如果不是该列最后一个item，还需要添加其列间距)
        CGFloat rowWidth = 0.0;
        if (obj.indexPath.item + self.numberOfRows >= [self.collectionView numberOfItemsInSection:obj.indexPath.section]) {
            rowWidth = CGRectGetMaxX(attFrame);
        }else {
            rowWidth = CGRectGetMaxX(attFrame) + self.minimumInteritemSpacing;
        }
        self.rowMaxXs[obj.indexPath.item % self.numberOfRows] = @(rowWidth);
        return obj;
    }
}

- (CGSize)collectionViewContentSize
{
    /*
     修改collectionview的contentSize
     如果是垂直滑动，修改其height为所有列中最高的那个值
     如果是水平滑动，修改其width为所有行中最长的那个值
     */
    CGSize size = [super collectionViewContentSize];
    // 垂直滑动
    if (self.slidingDirection == YZXWaterfallFlowCollectionViewSlidingDirectionWithVerticalSliding) {
        __block CGFloat originY = [self.columnMaxYs[0] floatValue];
        [self.columnMaxYs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj floatValue] > originY) {
                originY = [obj floatValue];
            }
        }];
        size.height = originY + self.sectionInset.bottom;
    }else {// 水平滑动
        __block CGFloat originX = [self.rowMaxXs[0] floatValue];
        [self.rowMaxXs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj floatValue] > originX) {
                originX = [obj floatValue];
            }
        }];
        size.width = originX + self.sectionInset.right;
    }
    return size;
}

#pragma mark - getter
- (NSInteger)numberOfRows
{
    // 获取一行（垂直滑动）或者一列（水平滑动）的个数，默认为3
    if (_delegate && [_delegate respondsToSelector:@selector(numberForLineToWaterfallFlow)]) {
        return [_delegate numberForLineToWaterfallFlow];
    }else {
        return 3;
    }
}

- (YZXWaterfallFlowCollectionViewSlidingDirection)slidingDirection
{
    // 获取collectionView的滑动方向，默认垂直滑动
    if (_delegate && [_delegate respondsToSelector:@selector(waterfallFlowSlidingDirection)]) {
        return [_delegate waterfallFlowSlidingDirection];
    }else {
        return YZXWaterfallFlowCollectionViewSlidingDirectionWithVerticalSliding;
    }
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - 懒加载
- (NSMutableArray *)columnMaxYs
{
    if (!_columnMaxYs) {
        _columnMaxYs = [NSMutableArray array];
    }
    return _columnMaxYs;
}

- (NSMutableArray *)rowMaxXs
{
    if (!_rowMaxXs) {
        _rowMaxXs = [NSMutableArray array];
    }
    return _rowMaxXs;
}

#pragma mark - ------------------------------------------------------------------------------------

@end
