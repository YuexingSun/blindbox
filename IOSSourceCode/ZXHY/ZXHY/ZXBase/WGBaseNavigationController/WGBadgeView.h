//
//  WGBadgeView.h
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

//未读view的层级
UIKIT_EXTERN const NSInteger WGTagBadgeView;

UIKIT_EXTERN const CGFloat WGNumBadgeSizeLength;

@interface WGBadgeView : WGBaseView

@property (nonatomic, strong) UIImageView *wg_bgImageView;
@property (nonatomic, strong) UILabel *wg_textLabel;
@property (nonatomic, strong) NSString *wg_text;
@property (nonatomic, assign) BOOL wg_isBigger;

- (void)wg_adjustFrameWithQuantity:(NSString *)quantity offsetY:(CGFloat)offsetY superViewFrame:(CGRect)superViewFrame isForBarButtonItem:(BOOL)isForBarButtonItem;

- (void)wg_adjustFrameWithQuantity:(NSString *)quantity offsetY:(CGFloat)offsetY superViewFrame:(CGRect)superViewFrame;

- (void)wg_adjustFrameWithQuantity:(NSString *)quantity offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY superViewFrame:(CGRect)superViewFrame isForBarButtonItem:(BOOL)isForBarButtonItem;

//- (void)wg_adjustFrameWithQuantity:(NSString *)quantity offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY superViewFrame:(CGRect)superViewFrame isForBarButtonItem:(BOOL)isForBarButtonItem;
//给底部添加未读View
- (void)wg_adjustSubView:(UITabBar *)tabbar index:(NSInteger)index num:(NSString *)num;
- (void)wg_setBagdeValues:(NSString *)values;

@end

NS_ASSUME_NONNULL_END
