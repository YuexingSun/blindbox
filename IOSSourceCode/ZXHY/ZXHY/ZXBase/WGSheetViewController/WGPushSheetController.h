//
//  WGPushSheetController.h
//  Yunhuoyouxuan
//
//  Created by liaoqijin on 2021/4/15.
//  Copyright © 2021 apple. All rights reserved.
//

#import "WGBaseViewController.h"

@protocol WGPushSheetControllerDelegate <NSObject>

/**
 *  弹窗关闭回调
 */
- (void)wg_closePushSheetVcWithCustomView:(UIView *_Nullable)customView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WGPushSheetController : WGBaseViewController

/** 点击遮罩区是否同时dissMiss所有presented的VC */
@property (nonatomic, assign) BOOL wg_beyondTouchDissmisAllVc;
/** VC展示的背景颜色 */
@property (nonatomic, strong) UIColor *sheetVcBackgroundColor;
/** 是否需要左边边缘拖拽手势返回，但是暂时仅适用于customView设置了frame */
@property (nonatomic, assign) BOOL isCanPanEdgeDragBack;

@property (nonatomic, weak) id<WGPushSheetControllerDelegate> delegate;

- (instancetype)initSheetControllerWithCustomView:(UIView *)customView;

+ (instancetype)sheetControllerWithCustomView:(UIView *)customView;

+ (void)dissmissCurrentAllSheetVcAnimated:(BOOL)animated completion:(nullable void(^)(void))completion;

+ (void)dissmissCurrentSheetVcWithCustomView:(UIView *)customView
                                    animated:(BOOL)animated
                                  completion:(nullable void(^)(void))completion;

- (void)dissmissSheetVc;

- (void)dissmisSheetVcCompletion:(nullable void(^)(void))completion;

- (void)dissmisSheetVcAnimated:(BOOL)animated completion:(nullable void(^)(void))completion;

- (void)dissmisSheetVcToBottomAnimated:(BOOL)animated completion:(nullable void(^)(void))completion;

/** 调用直接在当前控制器present显示 */
- (void)showToCurrentVc;

/**
 *  弹框只出现一次
 *  showViewClass：传入填充显示的view的class，便于判断当前是否已经展示了该一模一样的弹框
 */
- (void)showToCurrentVcOneWithShowViewClass:(Class)showViewClass;

@end

NS_ASSUME_NONNULL_END
