//
//  WGBaseTabBar.h
//  Yunhuoyouxuan
//
//  Created by Bern on 2021/4/28.
//  Copyright © 2021 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGTabBarModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WGTabBarModel;
@class WGBaseTabBar;

@protocol WGBaseTabBarDelegate <NSObject>

- (void)wgtabBar:(WGBaseTabBar *)tabbar didSelectItem:(WGTabBarModel *)tabBarModel;

@end

@interface WGBaseTabBar : UIView

@property (nonatomic, strong) NSArray<WGTabBarModel *> *tabbarArray;
@property (nonatomic, weak)   id<WGBaseTabBarDelegate>  delegate;
@property (nonatomic, assign) WGTabBarType selectedTabType;

@end

NS_ASSUME_NONNULL_END
