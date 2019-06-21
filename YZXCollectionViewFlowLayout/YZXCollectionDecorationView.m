//
//  YZXCollectionDecorationView.m
//  YZXCollectionViewFlowLayout
//
//  Created by 尹星 on 2019/6/19.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "YZXCollectionDecorationView.h"

@interface YZXCollectionDecorationView ()

@property (nonatomic, strong) UILabel       *label;

@end

@implementation YZXCollectionDecorationView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor brownColor];
        self.layer.cornerRadius = 10.0;
        self.clipsToBounds = YES;
        
        [self addSubview:self.label];
    }
    return self;
}

#pragma mark - 懒加载
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.text = @"我是decroationView";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:15.0];
    }
    return _label;
}

#pragma mark - ------------------------------------------------------------------------------------

@end
