//
//  YZXCellLeftAlignedViewController.m
//  YZXCollectionViewFlowLayout
//
//  Created by 尹星 on 2019/6/27.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "YZXCellLeftAlignedViewController.h"
#import "YZXCellLeftAlignedCollectionViewFlowLayout.h"

@interface YZXCellLeftAlignedViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView       *collectionView;

@property (nonatomic, copy) NSArray                  *dataSource;

@end

@implementation YZXCellLeftAlignedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_initData];
    [self p_initView];
}

#pragma mark - 初始化
- (void)p_initData
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i<100; i++) {
        NSString *string = @"";
        for (int j = 0; j<i % 10 + 1; j++) {
            string = [string stringByAppendingFormat:@"%d",j];
        }
        [array addObject:string];
    }
    
    self.dataSource = [[NSArray alloc] initWithArray:[array copy] copyItems:YES];
}

- (void)p_initView
{
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSString *string = self.dataSource[indexPath.item];
    CGFloat width = [string boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.width;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width + 16.0, 40.0)];
    label.text = self.dataSource[indexPath.row];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
    
    cell.contentView.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        header.backgroundColor = [UIColor purpleColor];
        return header;
    }else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        footer.backgroundColor = [UIColor yellowColor];
        return footer;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 50.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 50.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = self.dataSource[indexPath.item];
    CGFloat width = [string boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.width;
    return CGSizeMake(width + 16.0, 40.0);
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        YZXCellLeftAlignedCollectionViewFlowLayout *flowLayout = [[YZXCellLeftAlignedCollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10.0;
        flowLayout.minimumLineSpacing = 10.0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 100, self.view.bounds.size.width, self.view.bounds.size.height - 200) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

#pragma mark - ------------------------------------------------------------------------------------

@end
