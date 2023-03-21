//
//  UIViewController+WGNavigationView.h
//  WG_Common
//
//  Created by apple on 2021/6/2.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import "WGBaseViewController.h"
#import "WGNavigationView.h"
#import "WGBarButtonItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface WGBaseViewController (WGNavigationView)<WGNavigationViewDelegate>

@property (nonatomic, strong) WGNavigationView *navigationView;

@property (nonatomic, assign) BOOL showCustomerNavView;

/// 没有实现set方法
@property (nonatomic, strong) NSString *wg_mainTitle;

@property (nonatomic, strong) WGBarButtonItem *wg_backBarButtonItem;

@end

NS_ASSUME_NONNULL_END
