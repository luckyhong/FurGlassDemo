//
//  HHTransparentBarViewController.m
//  FurGlassDemo
//
//  Created by 韩继宏 on 16/3/26.
//  Copyright © 2016年 hanjihong. All rights reserved.
//

#import "HHTransparentBarViewController.h"

@interface HHTransparentBarViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, assign) CGFloat topContentInset;
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic, assign) BOOL statusBarStyleControl;

@end

@implementation HHTransparentBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _statusBarStyleControl = NO;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // tableView
    [self.view addSubview:self.tableView];
    
    // 创建scale背景图
    [self createScaleImageView];
    
    // 创建头像视图
    [self createHeadView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    if (_alphaMemory == 0) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_alphaMemory < 1) {
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
        [UIView animateWithDuration:0.15 animations:^{
            [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.0];
        }];
    }
}

#pragma mark - 创建tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(64 + _topContentInset, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64 + _topContentInset, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

#pragma mark - 背景图
- (void)createScaleImageView {
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    _topImageView.backgroundColor = [UIColor whiteColor];
    _topImageView.image = [UIImage imageNamed:@"backImage"];
    [self.view insertSubview:_topImageView belowSubview:_tableView];
}

#pragma mark - 创建头像视图
- (void)createHeadView {
    _topContentInset = 136; // 136+64=200
    
    UIView *headBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _topContentInset)];
    headBgView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headBgView;
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.bounds = CGRectMake(0, 0, 64, 64);
    headImageView.center = CGPointMake(SCREEN_WIDTH/2.0, (_topContentInset - 64)/2.0);
    headImageView.backgroundColor = [UIColor whiteColor];
    headImageView.layer.cornerRadius = headImageView.bounds.size.width / 2.0;
    headImageView.layer.masksToBounds = YES;
    headImageView.image = [UIImage imageNamed:@"head"];
    [headBgView addSubview:headImageView];
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
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
    CGFloat offsetY = scrollView.contentOffset.y + _tableView.contentInset.top;
    NSLog(@"%lf=====%lf", offsetY, _topContentInset);
    
    if (offsetY > _topContentInset && offsetY <= _topContentInset * 2) { // 上滑
        _statusBarStyleControl = YES;
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        _alphaMemory = offsetY/(_topContentInset*2) >= 1 ? 1 : offsetY/(_topContentInset*2);
        NSLog(@"%f", _alphaMemory);
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
        
    } else if (offsetY <= _topContentInset) { // 初始值offsetY = 0 _topContentInset = 136
        _statusBarStyleControl = NO;
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        _alphaMemory = 0;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
    } else if (offsetY > _topContentInset * 2) {
        
        _alphaMemory = 1;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
    }
    if (offsetY < 0) { // 放大_topImageView
        _topImageView.transform = CGAffineTransformMakeScale(1 + offsetY/(-500), 1 + offsetY/(-500));
    }
    CGRect frame = _topImageView.frame;
    frame.origin.y = 0;
    _topImageView.frame = frame;
}

/*!
 *  @author 韩继宏, 16-03-26 17:03:39
 *
 *  preferredStatusBarStyle就是控制用来控制statusBar颜色或者说样式的，_statusBarStyleControl是自定义的一个用来动态控制的BOOL属性。prefersStatusBarHidden这个控制statusBar的显示隐藏，建议NO或直接默认不写，如果设置隐藏，视图会整体上移20，效果不太好，看具体需求
 */
#ifdef __IPHONE_7_0
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (_statusBarStyleControl) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
