//
//  HHNavigationController.m
//  FurGlassDemo
//
//  Created by 韩继宏 on 16/3/26.
//  Copyright © 2016年 hanjihong. All rights reserved.
//

#import "HHNavigationController.h"

@implementation HHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
