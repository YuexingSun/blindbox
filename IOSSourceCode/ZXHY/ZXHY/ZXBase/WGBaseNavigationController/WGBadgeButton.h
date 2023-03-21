//
//  WGBadgeButton.h
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/11/16.
//  Copyright © 2020 apple. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@class WGBadgeView;

@interface WGBadgeButton : UIButton

@property (nonatomic, strong) WGBadgeView *wg_badgeView;
@property (nonatomic, strong) NSString *wg_badgeCount;
@property (nonatomic, assign) BOOL wg_isForBarButtonItem;

@end

NS_ASSUME_NONNULL_END
