//
//  WGHeaderRefreshUtil.h
//  Yunhuoyouxuan
//
//  Created by 廖其进 on 2021/1/24.
//  Copyright © 2021 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshFooter+WGRefresh.h"
#import <MJRefresh.h>

typedef NS_ENUM(NSUInteger, WGCommonHeaderRefreshType) {
    WGCommonHeaderRefreshTypeRed,           //红色样式
    WGCommonHeaderRefreshTypeWhite,         //白色样式
};

NS_ASSUME_NONNULL_BEGIN

@interface WGCommonRefreshUtil : NSObject

/// 分类用的刷新控件
/// @param scrollView 滚动视图
/// @param target target
/// @param action action
+ (void)configSkipRefreshInScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action;

/// 普通刷新控件
/// @param scrollView 滚动视图
/// @param target target
/// @param action action
/// @param headerRefreshType 刷新控件样式
+ (void)configRefreshInScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action headerRefreshType:(WGCommonHeaderRefreshType)headerRefreshType;

/// 普通刷新控件
/// @param scrollView 滚动视图
/// @param target target
/// @param action action
/// @param headerRefreshType 刷新控件样式
/// @param transparent 是否透明
+ (void)configRefreshInScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action headerRefreshType:(WGCommonHeaderRefreshType)headerRefreshType transparent:(BOOL)transparent;

/// 普通刷新控件
/// @param scrollView 滚动视图
/// @param target target
/// @param action action
/// @param headerRefreshType 刷新控件样式
/// @param showLogo 是否有logo
+ (void)configRefreshInScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action headerRefreshType:(WGCommonHeaderRefreshType)headerRefreshType showLogo:(BOOL)showLogo;

/// 上拉加载控件
/// @param scrollView 滚动视图
/// @param target target
/// @param action action
+ (void)configLoadMoreInScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action;

/// 分类用的上拉加载控件
/// @param scrollView 滚动视图
/// @param target target
/// @param action action
+ (void)configLoadMoreSkipInScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
