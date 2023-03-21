//
//  WGGeneralAlertController.h
//  Yunhuoyouxuan
//
//  Created by admin on 2020/11/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WGGeneralAlertController : UIViewController

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;

@property (nonatomic, strong) UIFont *subTitleFont;
@property (nonatomic, strong) UIColor *subTitleColor;
@property (nonatomic, assign) NSTextAlignment subTitleTextAlignment;

@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, assign) NSTextAlignment messageTextAlignment;

@property (nonatomic, strong, readonly) UIButton *cancelBtn;
@property (nonatomic, strong, readonly) UIButton *submitBtn;

@property (nonatomic, strong, readonly) UIButton *closeBtn;

/** 自定义View弹框 */
- (instancetype)initWithCustomView:(UIView *)customView;

+ (instancetype)alertControllerWithCustomView:(UIView *)customView;

/** 比较传统弹框 */
- (instancetype)initWithTitleStr:(NSString *)titleStr
                     subTitleStr:(NSString *)subTitleStr
                      messageStr:(NSString *)messageStr;

+ (instancetype)alertControllerWithTitleStr:(NSString *)titleStr
                                subTitleStr:(NSString *)subTitleStr
                                 messageStr:(NSString *)messageStr;


/** 调用直接在当前控制器present显示 */
- (void)showToCurrentVc;

- (void)dissmisAlertVc;

- (void)dissmisAlertVcWithCompletion:(void(^)(void))completion;

@end
