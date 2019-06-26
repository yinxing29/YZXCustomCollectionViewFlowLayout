//
//  YZXWaterfallFlowCollectionViewFlowLayout.h
//  YZXCollectionViewFlowLayout
//
//  Created by 尹星 on 2019/6/20.
//  Copyright © 2019 尹星. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZXWaterfallFlowCollectionViewFlowLayout;

typedef NS_ENUM(NSInteger, YZXWaterfallFlowCollectionViewSlidingDirection) {
    YZXWaterfallFlowCollectionViewSlidingDirectionWithVerticalSliding = 0, // 垂直滑动
    YZXWaterfallFlowCollectionViewSlidingDirectionWithHorizontalSliding,   // 水平滑动
};

@protocol YZXWaterfallFlowCollectionViewFlowLayoutDelegate <NSObject>

/**
 设置水平瀑布流还是垂直瀑布流

 @return YZXWaterfallFlowCollectionViewSlidingDirection
 */
- (YZXWaterfallFlowCollectionViewSlidingDirection)waterfallFlowSlidingDirection;

/**
 如果是垂直瀑布，就是一行显示的item个数，如果是水平b瀑布，就是一列显示的item个数

 @return 数量
 */
- (NSInteger)numberForLineToWaterfallFlow;

@optional
/**
 垂直瀑布流时，item的高度，如果未设置，则取UICollectionViewLayoutAttributes的frame.size.height，宽度由sectionInsert,minimumLineSpacing,numberForLineToWaterfallFlow等决定

 @param layout layout
 @param indexPath indexPath
 @return 高度
 */
- (CGFloat)layout:(YZXWaterfallFlowCollectionViewFlowLayout *)layout heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 水平瀑布流时，item的宽度，如果未设置，则取UICollectionViewLayoutAttributes的frame.size.width，高度由sectionInsert,minimumLineSpacing,numberForLineToWaterfallFlow等决定

 @param layout layout
 @param indexPath indexPath
 @return 宽度
 */
- (CGFloat)layout:(YZXWaterfallFlowCollectionViewFlowLayout *)layout widthForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface YZXWaterfallFlowCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<YZXWaterfallFlowCollectionViewFlowLayoutDelegate>       delegate;

/**
 当页面含有navigationbar，并且collectionView的初始contentOffset.y等于navigationbar的高度时，需要设置
 */
@property (nonatomic, assign) CGFloat                             navigationBarHeight;

@end

