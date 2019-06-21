//
//  YZXWaterfallFlowViewController.m
//  YZXCollectionViewFlowLayout
//
//  Created by 尹星 on 2019/6/20.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "YZXWaterfallFlowViewController.h"
#import "YZXWaterfallFlowCollectionViewFlowLayout.h"

@interface YZXWaterfallFlowViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YZXWaterfallFlowCollectionViewFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView       *collectionView;

@end

@implementation YZXWaterfallFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self p_initView];
}

#pragma mark - 初始化
- (void)p_initView
{
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 200;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:(arc4random() % 255 + 1) / 255.0 green:(arc4random() % 255 + 1) / 255.0 blue:(arc4random() % 255 + 1) / 255.0 alpha:1.0];
    return cell;
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - <YZXWaterfallFlowCollectionViewFlowLayoutDelegate>
- (YZXWaterfallFlowCollectionViewSlidingDirection)waterfallFlowSlidingDirection
{
    return YZXWaterfallFlowCollectionViewSlidingDirectionWithHorizontalSliding;
}

- (NSInteger)numberForLineToWaterfallFlow
{
    return 3;
}

- (CGFloat)layout:(YZXWaterfallFlowCollectionViewFlowLayout *)layout heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 1) {
        return 80.0;
    }
    return 100;
}

- (CGFloat)layout:(YZXWaterfallFlowCollectionViewFlowLayout *)layout widthForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 1) {
        return 80.0;
    }
    return 100;
}

- (CGFloat)minimumLineSpacingForSection
{
    return 10.0;
}

- (CGFloat)minimumInteritemSpacingForSection
{
    return 30.0;
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        YZXWaterfallFlowCollectionViewFlowLayout *flowLayout = [[YZXWaterfallFlowCollectionViewFlowLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.sectionInset = UIEdgeInsetsMake(20.0, 10.0, 20.0, 10.0);
        flowLayout.minimumInteritemSpacing = 30.0;
        flowLayout.minimumLineSpacing = 10.0;
        flowLayout.navigationBarHeight = 88.0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 88.0 - 34.0) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

#pragma mark - ------------------------------------------------------------------------------------

@end
