//
//  ZXBaseTabBar.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WGTabBarModel,ZXBaseTabBar;


@protocol ZXBaseTabBarDelegate <NSObject>

- (void)zxtabBar:(ZXBaseTabBar *)tabbar didSelectItem:(WGTabBarModel *)tabBarModel;

@end

@interface ZXBaseTabBar : UIView

@property (nonatomic, weak)   id<ZXBaseTabBarDelegate>  delegate;
@property (nonatomic, assign) WGTabBarType selectedTabType;
//按钮旋转
- (void)zx_tabBoxAnimation;
@end

NS_ASSUME_NONNULL_END
