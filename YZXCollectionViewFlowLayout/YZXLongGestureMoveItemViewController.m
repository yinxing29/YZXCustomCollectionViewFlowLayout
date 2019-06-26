//
//  YZXLongGestureMoveItemViewController.m
//  YZXCollectionViewFlowLayout
//
//  Created by 尹星 on 2019/6/26.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "YZXLongGestureMoveItemViewController.h"

@interface YZXLongGestureMoveItemViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView       *collectionView;

@property (nonatomic, copy) NSArray                  *dataSource;

@property (nonatomic, strong) UIView                 *snapshotView;

@property (nonatomic, strong) NSIndexPath            *clickIndexPath;

@property (nonatomic, strong) NSIndexPath            *moveIndexPath;

@end

@implementation YZXLongGestureMoveItemViewController

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
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.dataSource = [array copy];
}

- (void)p_initView
{
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
    [self.collectionView addGestureRecognizer:longGesture];
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - 点击事件
- (void)longGesture:(UILongPressGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint currentPoint = [sender locationInView:self.collectionView];
            
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:currentPoint];
            self.clickIndexPath = indexPath;
            if (indexPath == nil) {
                return;
            }
            
            if (@available(iOS 9.0, *)) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            } else {
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
                self.snapshotView = [cell snapshotViewAfterScreenUpdates:YES];
                self.snapshotView.frame = cell.frame;
                [self.collectionView addSubview:self.snapshotView];
                
                cell.hidden = YES;
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.snapshotView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    self.snapshotView.center = currentPoint;
                }];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (@available(iOS 9.0, *)) {
                [self.collectionView updateInteractiveMovementTargetPosition:[sender locationInView:self.collectionView]];
            } else {
                CGPoint currentPoint = [sender locationInView:self.collectionView];
                
                self.snapshotView.center = currentPoint;
                
                for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
                    if ([self.collectionView indexPathForCell:cell].section == self.clickIndexPath.section && [self.collectionView indexPathForCell:cell].item == self.clickIndexPath.item) {
                        continue;
                    }
                    
                    // 计算中心距
                    CGFloat space = sqrtf(pow(self.snapshotView.center.x - cell.center.x, 2) + powf(self.snapshotView.center.y - cell.center.y, 2));
                    // 如果相交一半就移动
                    if (space <= self.snapshotView.bounds.size.width / 2) {
                        self.moveIndexPath = [self.collectionView indexPathForCell:cell];
                        //移动 会调用willMoveToIndexPath方法更新数据源
                        [self.collectionView moveItemAtIndexPath:self.clickIndexPath toIndexPath:self.moveIndexPath];
                        
                        // 修改数据源
                        NSMutableArray *array = [self.dataSource mutableCopy];
                        NSString *string = self.dataSource[self.clickIndexPath.item];
                        [array removeObject:string];
                        [array insertObject:string atIndex:self.moveIndexPath.item];
                        self.dataSource = [array copy];
                        
                        //设置移动后的起始indexPath
                        self.clickIndexPath = self.moveIndexPath;
                        break;
                    }
                }
            
                // 当手势超过collectionView范围，collectionView自动上滑，当滑到底部停止
                if (currentPoint.y >= self.collectionView.contentOffset.y + self.collectionView.bounds.size.height && currentPoint.y <= self.collectionView.contentSize.height) {
                    [self.collectionView setContentOffset:CGPointMake(0.0, self.collectionView.contentOffset.y + 10.0)];
                }else if (currentPoint.y <= self.collectionView.contentOffset.y && currentPoint.y >= 0) {// 当手势超过collectionView范围，collectionView自动下滑，当滑到顶部停止
                    [self.collectionView setContentOffset:CGPointMake(0.0, self.collectionView.contentOffset.y - 10.0)];
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (@available(iOS 9.0, *)) {
                [self.collectionView endInteractiveMovement];
            } else {
                // 手势结束和其他状态
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.clickIndexPath];
                // 结束动画过程中停止交互,防止出问题
                self.collectionView.userInteractionEnabled = NO;
                // 给截图视图一个动画移动到隐藏cell的新位置
                [UIView animateWithDuration:0.25 animations:^{
                    self.snapshotView.center = cell.center;
                    self.snapshotView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                } completion:^(BOOL finished) {
                    // 移除截图视图,显示隐藏的cell并开始交互
                    [self.snapshotView removeFromSuperview];
                    cell.hidden = NO;
                    self.collectionView.userInteractionEnabled = YES;
                }];
            }
        }
            break;
        default:
        {
            if (@available(iOS 9.0, *)) {
                [self.collectionView cancelInteractiveMovement];
            } else {
                
            }
        }
            break;
    }
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    label.text = self.dataSource[indexPath.row];
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
    
    cell.contentView.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableArray *array = [self.dataSource mutableCopy];
    NSString *string = self.dataSource[sourceIndexPath.item];
    [array removeObject:string];
    [array insertObject:string atIndex:destinationIndexPath.item];
    self.dataSource = [array copy];
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(100.0 ,100.0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 100, self.view.bounds.size.width, self.view.bounds.size.height - 200) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

#pragma mark - ------------------------------------------------------------------------------------

@end
