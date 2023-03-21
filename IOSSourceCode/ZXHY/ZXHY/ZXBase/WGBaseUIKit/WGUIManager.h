//
//  WGUIManager.h
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/10.
//  Copyright © 2020 apple. All rights reserved.
//


#import "WGBaseManager.h"
#import <UIKit/UIKit.h>
#import "WGBaseTabBarController.h"
#import "ZXBaseTabBarController.h"

@class MBProgressHUD;
@class UIWindow;
@class WGBaseNavigationController;
@class LOTAnimationView;
@interface WGUIManager : NSObject

@property (nonatomic, strong, readonly) MBProgressHUD *wg_progressHUD;
@property (nonatomic, strong, readonly) UILabel *wg_progressHUDLabel;
@property (nonatomic, strong, readonly) LOTAnimationView *wg_progressHUDImageView;

+ (instancetype)wg_sharedManager;


+ (UIWindow *)wg_window;

+ (void)wg_showHUD;

+ (void)wg_hideHUD;

+ (void)wg_hideHUDAfterDelay:(NSTimeInterval)delay;

+ (void)wg_hideHUDOperationSucceed;

+ (void)wg_hideHUDNetWorkError;

+ (void)wg_hideHUDNetWorkErrorWithText:(NSString *)text imageName:(NSString *)imageName;

+ (void)wg_hideHUDWithText:(NSString *)text;

+ (void)wg_hideHUDWithText:(NSString *)text afterDelay:(NSTimeInterval)delay;

//显示加载失败的的默认图，默认图的fram可以查看里面的方法实现，如果要自定义，请直接用WGEmptyView
+ (void)wg_showLoadFailWithBtnClickBlock:(void(^)(UIButton *button))block;
+ (void)wg_showLoadFailWithFrame:(CGRect)frame btnClickBlock:(void(^)(UIButton *button))block;

//获取当前TabBarController控制器
//+ (WGTabBarController *)wg_currentTabBarController;
//TODO: 修复
//+ (WGBaseTabBarController *)wg_currentTabBarController;
+ (ZXBaseTabBarController *)wg_currentTabBarController;

//获取当前导航控制器
+ (WGBaseNavigationController *)wg_currentIndexNavController;

+ (UIViewController *)wg_topViewController:(UIViewController *)rootViewController;

//获取当前顶层页面
+ (UIViewController *)wg_topViewController;

//获取当前导航控制器的的最上层页面
+ (UIViewController *)wg_currentIndexNavTopController;

//切换根视图控制器
+ (void)wg_switchRootController:(UIViewController *)controller;

@end
