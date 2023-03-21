//
//  WGGeneralSheetContainerView.h
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/12/3.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGBaseView.h"


NS_ASSUME_NONNULL_BEGIN

@class WGBaseView;

@interface WGGeneralSheetContainerView : WGBaseView

@property (nonatomic, strong) WGBaseView *wg_bgView;
@property (nonatomic, strong) UIButton *wg_customBgView;
@property (nonatomic, strong) UIView *wg_customView;
@property (nonatomic, assign) BOOL wg_isShowed;
@property (nonatomic, assign) BOOL wg_isForceDeviceWidth;

- (instancetype)initWithFrame:(CGRect)frame wg_customView:(UIView *)customView;

- (instancetype)initWithWg_customView:(UIView *)customView;

- (void)wg_showContainerViewInView:(UIView *)view;

- (void)wg_dismissContainerView;

@end

NS_ASSUME_NONNULL_END
