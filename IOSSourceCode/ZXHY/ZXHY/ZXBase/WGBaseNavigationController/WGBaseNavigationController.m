//
//  WGBaseNavigationController.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/7.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGBaseNavigationController.h"


@interface WGBaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation WGBaseNavigationController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // 删除系统自带的tabBarButton
    for (UIView *tabBar in self.tabBarController.tabBar.subviews) {
        if ([tabBar isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBar removeFromSuperview];
        }
    }
    
    //非根控制器
    if (self.childViewControllers.count > 1){
        [[AppDelegate wg_sharedDelegate].tabBarController hideTabBar];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //处理是不是首页跳转后隐藏自定义TabBar
    //根控制器
    if (self.childViewControllers.count == 1){
    
        [[AppDelegate wg_sharedDelegate].tabBarController showTabBar];
        
    }
    
    //非根控制器
    if (self.childViewControllers.count > 1){
        [[AppDelegate wg_sharedDelegate].tabBarController hideTabBar];

    }
}






@end
