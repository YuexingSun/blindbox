//
//  AppDelegate+WCaGVendor.h
//  Yunhuoyouxuan
//
//  Created by Bern on 2020/10/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (WCaGVendor)

+ (AppDelegate *)wg_sharedDelegate;

#pragma mark - 高德地图
- (void)zx_initMap;

#pragma mark - 极光认证
- (void)zx_initCertification;

#pragma mark - 极光统计
- (void)zx_initStatistics;

@end

NS_ASSUME_NONNULL_END
