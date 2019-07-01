//
//  YZXCollectionViewFlowLayout.h
//  YZXCollectionViewFlowLayout
//
//  Created by 尹星 on 2019/6/19.
//  Copyright © 2019 尹星. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZXCollectionViewDelegateFlowLayout <NSObject>

/**
 用于获取通过代理设置section的insert

 @param collectionView self.collectionView
 @param collectionViewLayout self
 @param section indexPath.section
 @return sectionInsert
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView yzx_layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

@end

@interface YZXCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<YZXCollectionViewDelegateFlowLayout>       delegate;

/**
 当页面含有navigationbar，并且collectionView的初始contentOffset.y等于navigationbar的高度时，需要设置
 */
@property (nonatomic, assign) CGFloat                             navigationBarHeight;

@end
