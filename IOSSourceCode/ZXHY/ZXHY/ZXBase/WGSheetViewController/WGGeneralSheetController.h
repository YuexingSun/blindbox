//
//  WGGeneralSheetController.h
//  Yunhuoyouxuan
//
//  Created by admin on 2020/11/10.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGBaseViewController.h"

@protocol WGGeneralSheetControllerDelegate <NSObject>

/**
 *  弹窗关闭回调
 */
- (void)wg_closeGeneralSheetVcWithCustomView:(UIView *)customView;

@end

@interface WGGeneralSheetController : WGBaseViewController

/**
 * 是否移除spring阻尼动画，
 * 但是暂时仅适用于customView设置了frame，
 * 也就是customView设置了frame后默认有阻尼动画的
 */
@property (nonatomic, assign) BOOL removeSpringAnimation;

@property (nonatomic, weak) id<WGGeneralSheetControllerDelegate> delegate;

- (instancetype)initSheetControllerWithCustomView:(UIView *)customView;

+ (instancetype)sheetControllerWithCustomView:(UIView *)customView;

+ (void)dissmissCurrentAllSheetVcAnimated:(BOOL)animated completion:(void(^)(void))completion;

+ (void)dissmissCurrentSheetVcWithCustomView:(UIView *)customView
                                    animated:(BOOL)animated
                                  completion:(void(^)(void))completion;

- (void)dissmissSheetVc;

- (void)dissmisSheetVcCompletion:(void(^)(void))completion;

- (void)dissmisSheetVcAnimated:(BOOL)animated completion:(void(^)(void))completion;

/** 调用直接在当前控制器present显示 */
- (void)showToCurrentVc;

/**
 *  弹框只出现一次
 *  showViewClass：传入填充显示的view的class，便于判断当前是否已经展示了该一模一样的弹框
 */
- (void)showToCurrentVcOneWithShowViewClass:(Class)showViewClass;


//离开页面是否不删除子view
@property (nonatomic, assign) bool isNoRemove;

@end
