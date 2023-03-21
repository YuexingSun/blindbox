//
//  ZXBaseTabBarController.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBaseTabBarController : UITabBarController

//跳转到指定页
- (void)changeToSelectedIndex:(WGTabBarType)selectedIndex;

- (void)hideTabBar;

- (void)showTabBar;

- (CGFloat)zx_tabBarHeight;

@end

NS_ASSUME_NONNULL_END
