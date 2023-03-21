//
//  WGNavigationView.h
//  Yunhuoyouxuan
//
//  Created by Apple on 2020/12/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WGBadgeButton;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WGNavigationViewType) {
    WGNavigationViewType_Default,
    WGNavigationViewType_Red,
};

@class WGNavigationView;

@protocol WGNavigationViewDelegate <NSObject>

@optional
- (void)navigationViewBackBtnClick:(WGNavigationView *)navigationView;
- (void)navigationViewRightBtnClick:(WGNavigationView *)navigationView btnTag:(NSInteger)btnTag;
@end

@interface WGNavigationView : UIView

@property (nonatomic, strong) UIView *leftView;//左边按钮群
@property (nonatomic, strong) UIView *centerView;//中间标题
@property (nonatomic, strong) UIView *rightView;//右边按钮群

@property (nonatomic, assign) WGNavigationViewType type;

@property (nonatomic, weak) id<WGNavigationViewDelegate> delegate;

//是否可以返回
- (void)wg_setIsBack:(BOOL)isBack;

//设置返回按钮的图片
- (void)wg_setBackBtnImageName:(NSString *)imageName;

//设置title
- (void)wg_setTitle:(NSString *)title;
//设置标题颜色
- (void)wg_setTitleColor:(UIColor *)color;

//添加和修改右边按钮的文字，颜色
- (void)wg_setRightBtnWithText:(nullable NSString *)text textColor:(nullable UIColor *)color btnTag:(NSInteger)btnTag;
//添加和修改右边按钮的图片
- (void)wg_setRightBtnWithNormalImageName:(nullable NSString *)normalImageName highlightedImageName:(nullable NSString *)highlightedImageName selectedImageName:(nullable NSString *)selectedImageName btnTag:(NSInteger)btnTag;
//设置自定义中间View
- (void)wg_setCenterView:(UIView *)centerView;
//设置右边按钮的红点数
- (void)wg_setRightBtnBadgeCount:(NSString *)badgeCount btnTag:(NSInteger)btnTag;
//清除右边全部btn
- (void)wg_clearAllRightBtn;

//获取某个btn
- (UIButton *)wg_getRightBtnWithBtnTag:(NSInteger)btnTag;



@end

NS_ASSUME_NONNULL_END
