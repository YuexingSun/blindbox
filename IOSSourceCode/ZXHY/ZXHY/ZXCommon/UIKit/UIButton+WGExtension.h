//
//  UIButton+WGExtension.h
//  WG_Common
//
//  Created by apple on 2021/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WGImagePositionStyle) {
    /// 图片在左，文字在右
    WGImagePositionStyleDefault,
    /// 图片在右，文字在左
    WGImagePositionStyleRight,
    /// 图片在上，文字在下
    WGImagePositionStyleTop,
    /// 图片在下，文字在上
    WGImagePositionStyleBottom,
};

typedef void (^WGTouchedButtonBlock)(UIButton *button);

@interface UIButton (WGExtension)

/// 生成一个不带约束的UIButton
/// @param buttonType buttonType
+ (instancetype)wg_autolayoutButtonWithType:(UIButtonType)buttonType;

/// block回调点击事件
- (void)wg_addActionHandler:(WGTouchedButtonBlock)touchHandler;

/**
 *  设置图片与文字样式
 *
 *  @param imagePositionStyle     图片位置样式
 *  @param spacing                图片与文字之间的间距
 *  @param imagePositionBlock     在此 Block 中设置按钮的图片、文字以及 contentHorizontalAlignment 属性
 */
- (void)wg_setImagePosition:(WGImagePositionStyle)imagePositionStyle spacing:(CGFloat)spacing imagePositionBlock:(void (^)(UIButton *button))imagePositionBlock;
- (void)wg_setImagePosition:(WGImagePositionStyle)imagePositionStyle spacing:(CGFloat)spacing;

- (void)wg_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(nullable UIImage *)placeholder;

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)wg_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

#pragma mark - Chain

- (UIButton *(^)(CGFloat x))wg_x;
- (UIButton *(^)(CGFloat y))wg_y;
- (UIButton * (^)(CGFloat maxX))wg_maxX;
- (UIButton * (^)(CGFloat maxY))wg_maxY;
- (UIButton *(^)(CGFloat width))wg_width;
- (UIButton *(^)(CGFloat height))wg_height;
- (UIButton *(^)(UIColor *backgroundColor))wg_backgroundColor;
- (UIButton *(^)(CGRect frame))wg_frame;
- (UIButton * (^)(CGFloat centerX))wg_centerX;
- (UIButton * (^)(CGFloat centerY))wg_centerY;
- (UIButton * (^)(UIColor *borderColor))wg_borderColor;
- (UIButton * (^)(CGFloat radius))wg_cornerRaduis;

- (UIButton *(^)(UIColor *titleColor))wg_titleColor;
- (UIButton *(^)(UIColor *titleColor,UIControlState state))wg_titleColorState;
- (UIButton *(^)(NSString *title,UIControlState state))wg_titleState;
- (UIButton *(^)(CGFloat titleFontSize))wg_titleFontSize;
- (UIButton *(^)(CGFloat titleFontSize,UIFontWeight weight))wg_titleFont;
- (UIButton *(^)(UIImage *image))wg_image;
- (UIButton *(^)(UIImage *image))wg_backgroundImage;
- (UIButton *(^)(UIImage *,UIControlState))wg_backgroundImageState;
- (UIButton *(^)(UIImage *image,UIControlState state))wg_imageState;
- (UIButton *(^)(UIEdgeInsets titleInset))wg_titleInset;
- (UIButton *(^)(UIEdgeInsets imageInset))wg_imageInset;
- (UIButton *(^)(NSString *title))wg_title;
- (UIButton *(^)(WGImagePositionStyle positionStyle,CGFloat spacing))wg_positionStyle;
- (UIButton *)wg_disableAdjustsImageWhenHighlighted;
- (UIButton * _Nonnull (^)(UIColor *,UIControlState))wg_backgroundColorState;

@end

NS_ASSUME_NONNULL_END
