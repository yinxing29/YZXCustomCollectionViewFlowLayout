//
//  YZXAdditionalViewController.m
//  YZXCollectionViewFlowLayout
//
//  Created by 尹星 on 2019/6/20.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "YZXAdditionalViewController.h"
#import "YZXCollectionVIewFlowLayout.h"

@interface YZXAdditionalViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YZXCollectionViewFlowLayout>

@property (nonatomic, strong) UICollectionView       *collectionView;

@end

@implementation YZXAdditionalViewController

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
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 40;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
    return 20;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor purpleColor];
        [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
        label.text = [NSString stringWithFormat:@"%@%ld",@"test",indexPath.section];
        label.textColor = [UIColor yellowColor];
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor darkGrayColor];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    }else if (section == 1) {
        return UIEdgeInsetsMake(10.0, 10.0, 100.0, 10.0);
    }
    return UIEdgeInsetsMake(50.0, 10.0, 50.0, 10.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView yzx_layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    }else if (section == 1) {
        return UIEdgeInsetsMake(10.0, 10.0, 100.0, 10.0);
    }
    return UIEdgeInsetsMake(50.0, 10.0, 50.0, 10.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //    if (section == 1) {
    //        return CGSizeMake(50.0, 30.0);
    //    }
    return CGSizeMake(50.0, 50.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        YZXCollectionViewFlowLayout *flowLayout = [[YZXCollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(50.0, 50.0);
        flowLayout.delegate = self;
        flowLayout.navigationBarHeight = 88.0;
        //        flowLayout.headerReferenceSize = CGSizeMake(50.0, 50.0);
        //        flowLayout.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(40, 10.0, 40.0, 10.0);
    }
    return _collectionView;
}


#pragma mark - ------------------------------------------------------------------------------------


@end
