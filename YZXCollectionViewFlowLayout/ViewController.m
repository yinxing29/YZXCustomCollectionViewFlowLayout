//
//  ViewController.m
//  YZXCollectionViewFlowLayout
//
//  Created by 尹星 on 2019/6/19.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView       *tableView;

@property (nonatomic, copy) NSArray             *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_initData];
    [self p_initView];
}

#pragma mark - 初始化
- (void)p_initData
{
    self.dataSource = @[@{@"desc":@"附加视图（headerView，footerView，decroationView）",@"controller":@"YZXAdditionalViewController"},@{@"desc":@"瀑布流",@"controller":@"YZXWaterfallFlowViewController"}];
}

- (void)p_initView
{
    [self.view addSubview:self.tableView];
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = self.dataSource[indexPath.row][@"desc"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class vc = NSClassFromString(self.dataSource[indexPath.row][@"controller"]);
    [self.navigationController pushViewController:[vc new] animated:YES];
}

#pragma mark - ------------------------------------------------------------------------------------


#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50.0;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

#pragma mark - ------------------------------------------------------------------------------------

@end
