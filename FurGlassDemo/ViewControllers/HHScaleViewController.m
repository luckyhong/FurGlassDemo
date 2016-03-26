//
//  HHScaleViewController.m
//  FurGlassDemo
//
//  Created by 韩继宏 on 16/3/26.
//  Copyright © 2016年 hanjihong. All rights reserved.
//

#import "HHScaleViewController.h"
#import "HHHideBarViewController.h"
#import "HHTransparentBarViewController.h"

@interface HHScaleViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HHScaleViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 1.头像视图
    [self createScaleHeadView];
    
    // 2.tableView
    [self.view addSubview:self.tableView];
    
    // 3.设置左右按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(goTransparentPage:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"navBar隐藏" style:UIBarButtonItemStyleDone target:self action:@selector(goHideBarPage:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置navigationBar的透明
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)goTransparentPage:(UIBarButtonItem *)btn {
    HHTransparentBarViewController *transBarVc = [[HHTransparentBarViewController alloc] init];
    [self.navigationController pushViewController:transBarVc animated:YES];
}

- (void)goHideBarPage:(UIBarButtonItem *)btn {
    HHHideBarViewController *hideBarVc = [[HHHideBarViewController alloc] init];
    [self.navigationController pushViewController:hideBarVc animated:YES];
}

#pragma mark - 创建缩放头像视图
- (void)createScaleHeadView {
    UIView *topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 78, 44)];
    topBackgroundView.backgroundColor = [UIColor clearColor];
    
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 78, 78)];
    _topImageView.backgroundColor = [UIColor whiteColor];
    _topImageView.layer.cornerRadius = _topImageView.bounds.size.width * 0.5;
    _topImageView.layer.masksToBounds = YES;
    _topImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _topImageView.image = [UIImage imageNamed:@"head"];
    [topBackgroundView addSubview:_topImageView];
    
    self.navigationItem.titleView = topBackgroundView;
}

#pragma mark - 创建tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

#pragma mark - 设置分割线顶头
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.backgroundColor = RandomColor;
    
    return cell;
}

#pragma mark - 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f========%f", scrollView.contentOffset.y, _tableView.contentInset.top);
    CGFloat offsetY = scrollView.contentOffset.y + _tableView.contentInset.top;
    NSLog(@"%f", offsetY);
    
    //!!!: 0.45为最重缩小beilv，offsetY为纵偏移量
    if (offsetY < 0 && offsetY >= -150) {
        _topImageView.transform = CGAffineTransformMakeScale(1 + offsetY/(-300), 1 + offsetY/(-300));
    } else if (offsetY >= 0 && offsetY <= 165) {
        _topImageView.transform = CGAffineTransformMakeScale(1 - offsetY/300, 1 - offsetY/300);
    } else if (offsetY > 165) {
        _topImageView.transform = CGAffineTransformMakeScale(0.45, 0.45);
    } else if (offsetY < -150) {
        _topImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }
    // 为了使缩放过程中位置相对保持,就是保持y的坐标为初始值
    CGRect frame = _topImageView.frame;
    frame.origin.y = 5;
    _topImageView.frame = frame;
}

#pragma mark - 随机色
//- (UIColor *)randomColor {
//    CGFloat r = arc4random_uniform(255);
//    CGFloat g = arc4random_uniform(255);
//    CGFloat b = arc4random_uniform(255);
//    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0];
//}
@end
