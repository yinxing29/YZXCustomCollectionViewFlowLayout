//
//  YZXCoverViewViewController.m
//  YZXCollectionViewFlowLayout
//
//  Created by 尹星 on 2019/6/25.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "YZXCoverViewViewController.h"
#import "YZXCoverViewCollectionViewFlowLayout.h"

@interface YZXCoverViewViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView       *collectionView;

@end

@implementation YZXCoverViewViewController

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
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor orangeColor];
    return cell;
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        YZXCoverViewCollectionViewFlowLayout *flowLayout = [[YZXCoverViewCollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.view.frame.size.width - 120.0, self.view.bounds.size.height - 300);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 100, self.view.bounds.size.width, self.view.bounds.size.height - 200) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

#pragma mark - ------------------------------------------------------------------------------------

@end
