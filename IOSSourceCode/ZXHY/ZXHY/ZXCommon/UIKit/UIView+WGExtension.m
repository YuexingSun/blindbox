//
//  UIView+WGExtension.m
//  WG_Common
//
//  Created by apple on 2021/4/29.
//

#import "UIView+WGExtension.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static char wg_touchGestureKey;

@implementation UIView (WGExtension)

#pragma mark - frame

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    self.x = left;
}

- (CGFloat)left {
    return self.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    self.y = top;
}

- (CGFloat)top {
    return self.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxX:(CGFloat)maxX {
    CGRect frame = self.frame;
    frame.origin.x = maxX - frame.size.width;
    self.frame = frame;
}

- (CGFloat)right {
    return self.maxX;
}

- (void)setRight:(CGFloat)right {
    self.maxX = right;
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setMaxY:(CGFloat)maxY {
    CGRect frame = self.frame;
    frame.origin.y = maxY - frame.size.height;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.maxY;
}

- (void)setBottom:(CGFloat)bottom {
    self.maxY = bottom;
}

#pragma mark - Chain

+ (instancetype)instance
{
    return [[self alloc] init];
}

- (UIView * (^)(CGFloat x))wg_x
{
    return ^UIView *(CGFloat x) {
        self.x = x;
        return self;
    };
}

- (UIView * (^)(CGFloat x))wg_left {
    return ^UIView *(CGFloat x) {
        self.x = x;
        return self;
    };
}

- (UIView * (^)(CGFloat y))wg_y {
    return ^UIView *(CGFloat y) {
        self.y = y;
        return self;
    };
}

- (UIView * (^)(CGFloat y))wg_top {
    return ^UIView *(CGFloat y) {
        self.y = y;
        return self;
    };
}

- (UIView *(^)(CGFloat))wg_maxX
{
    return ^UIView *(CGFloat maxX) {
        self.x = maxX - self.width;
        return self;
    };
}

- (UIView * (^)(CGFloat maxX))wg_right {
    return ^UIView *(CGFloat maxX) {
        self.x = maxX - self.width;
        return self;
    };
}

- (UIView *(^)(CGFloat))wg_maxY
{
    return ^UIView *(CGFloat maxY) {
        self.y = maxY - self.height;
        return self;
    };
}

- (UIView * (^)(CGFloat maxX))wg_bottom {
    return ^UIView *(CGFloat maxY) {
        self.y = maxY - self.height;
        return self;
    };
}

- (UIView *(^)(CGFloat))wg_centerX
{
    return ^UIView *(CGFloat centerX) {
        self.centerX = centerX;
        return self;
    };
}

- (UIView *(^)(CGFloat))wg_centerY
{
    return ^UIView *(CGFloat centerY) {
        self.centerY = centerY;
        return self;
    };
}

- (UIView * (^)(CGFloat width))wg_width {
    return ^UIView *(CGFloat width) {
        self.width = width;
        return self;
    };
}
- (UIView * (^)(CGFloat height))wg_height {
    return ^UIView *(CGFloat height) {
        self.height = height;
        return self;
    };
}
- (UIView * (^)(CGRect frame))wg_frame {
    return ^UIView *(CGRect frame) {
        self.frame = frame;
        return self;
    };
}

- (UIView * (^)(UIColor *))wg_backgroundColor
{
    return ^UIView *(UIColor *backgoundColor) {
        self.backgroundColor = backgoundColor;
        return self;
    };
}

- (UIView * (^)(CGFloat radius))wg_cornerRaduis
{
    return ^UIView *(CGFloat raduis) {
        self.layer.cornerRadius = raduis;
        return self;
    };
}

- (UIView * (^)(UIColor *borderColor))wg_borderColor
{
    return ^UIView *(UIColor *borderColor) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = borderColor.CGColor;
        return self;
    };
}

- (UIView * (^)(UIColor *shadowColor))wg_shadowColor
{
    return ^UIView *(UIColor *shadowColor) {
        self.layer.shadowColor = shadowColor.CGColor;
        return self;
    };
}

- (UIView * (^)(CGFloat shadowOpacity))wg_shadowOpacity
{
    return ^UIView *(CGFloat shadowOpacity) {
        self.layer.shadowOpacity = shadowOpacity;
        return self;
    };
}

- (UIView * (^)(CGSize shadowOffset))wg_shadowOffset
{
    return ^UIView *(CGSize shadowOffset) {
        self.layer.shadowOffset = shadowOffset;
        return self;
    };
}

- (UIView * (^)(CGFloat shadowRadius))wg_shadowRadius
{
    return ^UIView *(CGFloat shadowRadius) {
        self.layer.shadowRadius = shadowRadius;
        return self;
    };
}

- (instancetype)wg_clipToBounds
{
    self.clipsToBounds = YES;
    return self;
}

- (instancetype)wg_sizeToFit
{
    [self sizeToFit];
    return self;
}

- (instancetype (^)(UIView *))wg_addTo
{
    return ^(UIView *superView) {
        [superView addSubview:self];
        return self;
    };
}

#pragma mark - 圆角

- (void)wg_setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius color:(UIColor *)color
{
    CGRect rect = self.bounds;
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    if (color)
    {
        maskLayer.strokeColor = color.CGColor;
    }
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
}

- (void)wg_setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
    [self wg_setRoundedCorners:corners radius:radius color:nil];
}

- (void)wg_setRoundedCornersWithRadius:(CGFloat)radius
{
    [self wg_setRoundedCorners:UIRectCornerAllCorners radius:radius];
}

- (void)wg_setBorderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

- (void)wg_setLayerRoundedCornersWithRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

//指定圆角，有边框
- (void)wg_setBorderWithCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor type:(UIRectCorner)corners
{
    //    UIRectCorner type = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    
    CGRect rect = CGRectMake(borderWidth/2.0, borderWidth/2.0, CGRectGetWidth(self.frame)-borderWidth, CGRectGetHeight(self.frame) -borderWidth);
    CGSize radii = CGSizeMake(cornerRadius, borderWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = borderColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = borderWidth;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    [self.layer addSublayer:shapeLayer];
    
    CGRect clipRect = CGRectMake(0, 0, CGRectGetWidth(self.frame) - 1, CGRectGetHeight(self.frame) - 1);
    CGSize clipRadii = CGSizeMake(cornerRadius, borderWidth);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:clipRect byRoundingCorners:corners cornerRadii:clipRadii];
    
    CAShapeLayer *clipLayer = [CAShapeLayer layer];
    clipLayer.strokeColor = borderColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    clipLayer.lineWidth = 1;
    clipLayer.lineJoin = kCALineJoinRound;
    clipLayer.lineCap = kCALineCapRound;
    clipLayer.path = clipPath.CGPath;
    
    self.layer.mask = clipLayer;
}
#pragma mark - 渐变

/// 渐变色
- (void)wg_backgroundGradientColors:(NSArray <UIColor *> *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    NSMutableArray *gradientLayers = [NSMutableArray array];
    for (CALayer *subLayer in self.layer.sublayers) {
        if ([subLayer isKindOfClass:CAGradientLayer.class]) {
            [gradientLayers addObject:subLayer];
        }
    }
    for (CALayer *subLayer in gradientLayers) {
        [subLayer removeFromSuperlayer];
    }
    
    [gradientLayers removeAllObjects];
    
    NSMutableArray * gradientColors = [[NSMutableArray alloc] init];
    for (int i = 0; i < colors.count; i ++) {
        id color = [colors objectAtIndex:i];
        if ([color isKindOfClass:[UIColor class]]) {
            UIColor * readColor = (UIColor *)color;
            CGColorRef targetColor = readColor.CGColor;
            [gradientColors addObject:(__bridge id)targetColor];
        } else {
            [gradientColors addObject:(id)color];
        }
    }
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = startPoint;
    gradient.endPoint = endPoint;
    gradient.frame = self.bounds;
    gradient.colors = gradientColors;
    [self.layer insertSublayer:gradient atIndex:0];
}

/// 横向渐变
- (void)wg_backgroundGradientHorizontalColors:(NSArray <UIColor *> *)colors {
    [self wg_backgroundGradientColors:colors gradientStartPoint:CGPointMake(0.0f, 0.5f) endPoint:CGPointMake(1.0f, 0.5f)];
}

///竖直渐变
- (void)wg_backgroundGradientVerticalColors:(NSArray <UIColor *> *)colors {
    [self wg_backgroundGradientColors:colors gradientStartPoint:CGPointMake(0.5f, 0.0f) endPoint:CGPointMake(0.5f, 1.0f)];
}

#pragma mark - 点击手势

- (void)wg_actionTap:(UITapGestureRecognizer *)tap {
    WGTouchBlock block = objc_getAssociatedObject(self, &wg_touchGestureKey);
    if (block) block(tap);
}

- (void)addTouchGusture:(WGTouchBlock)block {
    
    self.userInteractionEnabled =YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wg_actionTap:)];
    
    [self addGestureRecognizer:tap];
    objc_setAssociatedObject(self, &wg_touchGestureKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - UIViewController

- (UIViewController *)wg_viewController {
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - Cell Identifier

+ (NSString *)defaultIdentifier {
    return NSStringFromClass(self.class);
}

#pragma mark - AutoLayout

+ (instancetype)wg_autolayoutView {
    UIView *view = [[self alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (void)wg_centersToSuperView {
    [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor].active = [self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor].active = YES;
}

- (NSArray<NSLayoutConstraint *> *)wg_addConstraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(nullable NSDictionary<NSString *, id> *)metrics views:(NSDictionary<NSString *, id> *)views API_AVAILABLE(macos(10.7), ios(6.0), tvos(9.0)) {
    NSArray<NSLayoutConstraint*>* constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:opts metrics:metrics views:views];
    [self addConstraints:constraints];
    return constraints;
}

- (NSLayoutConstraint*)wg_addConstraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c API_AVAILABLE(macos(10.7), ios(6.0), tvos(9.0)) {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view1 attribute:attr1 relatedBy:relation toItem:view2 attribute:attr2 multiplier:multiplier constant:c];
    [self addConstraint:constraint];
    return constraint;
}

@end
