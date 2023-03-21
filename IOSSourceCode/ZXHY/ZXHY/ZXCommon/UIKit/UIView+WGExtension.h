//
//  UIView+WGExtension.h
//  WG_Common
//
//  Created by apple on 2021/4/29.
//

#import <UIKit/UIKit.h>

@interface UIView (WGExtension)

#pragma mark - frame

@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic,assign) CGSize  size;
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat maxX;
@property (nonatomic,assign) CGFloat right;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat maxY;
@property (nonatomic,assign) CGFloat bottom;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;

#pragma mark - Chain

+ (instancetype)instance;
- (UIView * (^)(CGFloat x))wg_x;
- (UIView * (^)(CGFloat y))wg_y;
- (UIView * (^)(CGFloat maxX))wg_maxX;
- (UIView * (^)(CGFloat maxY))wg_maxY;
- (UIView * (^)(CGFloat centerX))wg_centerX;
- (UIView * (^)(CGFloat centerY))wg_centerY;
- (UIView * (^)(CGFloat width))wg_width;
- (UIView * (^)(CGFloat height))wg_height;
- (UIView * (^)(CGRect frame))wg_frame;
- (UIView * (^)(UIColor *backgroundColor))wg_backgroundColor;
- (UIView * (^)(CGFloat radius))wg_cornerRaduis;

- (UIView * (^)(UIColor *borderColor))wg_borderColor;
- (UIView * (^)(UIColor *shadowColor))wg_shadowColor;
- (UIView * (^)(CGFloat shadowOpacity))wg_shadowOpacity;
- (UIView * (^)(CGSize shadowOffset))wg_shadowOffset;
- (UIView * (^)(CGFloat shadowRadius))wg_shadowRadius;

- (UIView * (^)(CGFloat x))wg_left;
- (UIView * (^)(CGFloat maxX))wg_right;
- (UIView * (^)(CGFloat y))wg_top;
- (UIView * (^)(CGFloat maxY))wg_bottom;

- (instancetype)wg_clipToBounds;
- (instancetype)wg_sizeToFit;
- (instancetype(^)(UIView *superView))wg_addTo;

#pragma mark - 圆角

- (void)wg_setBorderColor:(UIColor *)color borderWidth:(CGFloat)width;

- (void)wg_setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius color:(UIColor *)color;

- (void)wg_setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;

- (void)wg_setRoundedCornersWithRadius:(CGFloat)radius;

- (void)wg_setLayerRoundedCornersWithRadius:(CGFloat)radius;

- (void)wg_setBorderWithCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor type:(UIRectCorner)corners;

#pragma mark -渐变

/// 渐变色
- (void)wg_backgroundGradientColors:(NSArray <UIColor *> *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
/// 横向渐变
- (void)wg_backgroundGradientHorizontalColors:(NSArray <UIColor *> *)colors;

/// 竖直渐变
- (void)wg_backgroundGradientVerticalColors:(NSArray <UIColor *> *)colors;

#pragma mark - 点击手势

typedef void (^WGTouchBlock)(UITapGestureRecognizer *tap);

- (void)addTouchGusture:(WGTouchBlock)block;

#pragma mark - UIViewController

/// 找到自己的vc
- (UIViewController *)wg_viewController;

#pragma mark - Cell Identifier

+ (NSString *)defaultIdentifier;

#pragma mark - AutoLayout

/// 生成一个View，并且不让系统将frame转成约束
+ (instancetype)wg_autolayoutView;

/// 添加针对父View的X和Y坐标的中心居中约束
- (void)wg_centersToSuperView;

/// 添加约束
- (NSArray<NSLayoutConstraint *> *)wg_addConstraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(nullable NSDictionary<NSString *, id> *)metrics views:(NSDictionary<NSString *, id> *_Nonnull)views API_AVAILABLE(macos(10.7), ios(6.0), tvos(9.0));

/// 添加约束
- (NSLayoutConstraint* _Nonnull)wg_addConstraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c API_AVAILABLE(macos(10.7), ios(6.0), tvos(9.0));

@end
