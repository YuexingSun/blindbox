//
//  UIButton+WGExtension.m
//  WG_Common
//
//  Created by apple on 2021/4/29.
//

#import "UIButton+WGExtension.h"
#import "UIImage+WGExtension.h"
#import "UIColor+WGExtension.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <objc/runtime.h>

static const void *wg_UIButtonBlockKey = &wg_UIButtonBlockKey;

@implementation UIButton (WGExtension)

+ (instancetype)wg_autolayoutButtonWithType:(UIButtonType)buttonType {
    UIButton *button = [UIButton buttonWithType:buttonType];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    return button;
}

- (void)wg_addActionHandler:(WGTouchedButtonBlock)touchHandler {
    objc_setAssociatedObject(self, wg_UIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(wg_blockActionTouched:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)wg_blockActionTouched:(UIButton *)btn {
    WGTouchedButtonBlock block = objc_getAssociatedObject(self, wg_UIButtonBlockKey);
    if (block) {
        block(btn);
    }
}

- (void)wg_setImagePosition:(WGImagePositionStyle)postion spacing:(CGFloat)spacing {
    [self wg_setImagePosition:postion spacing:spacing imagePositionBlock:nil];
}

- (void)wg_setImagePosition:(WGImagePositionStyle)imagePositionStyle spacing:(CGFloat)spacing imagePositionBlock:(void (^)(UIButton *button))imagePositionBlock {
    
    if(imagePositionBlock){
        imagePositionBlock(self);
    }
    
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    switch (imagePositionStyle) {
        case WGImagePositionStyleDefault:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case WGImagePositionStyleRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
            break;
            
        case WGImagePositionStyleTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;
            
        case WGImagePositionStyleBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
}

- (void)wg_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder];
}

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)wg_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIImage wg_imageWithColor:backgroundColor] forState:state];
}

#pragma mark - Chain

- (UIButton *(^)(NSString *))wg_title
{
    return ^UIButton *(NSString *title) {
        [self setTitle:title forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton *(^)(UIColor *titleColor))wg_titleColor
{
    return ^UIButton*(UIColor *titleColor) {
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton *(^)(UIColor *titleColor,UIControlState state))wg_titleColorState
{
    return ^UIButton*(UIColor *titleColor,UIControlState state) {
        [self setTitleColor:titleColor forState:state];
        return self;
    };
}

- (UIButton *(^)(NSString *title,UIControlState state))wg_titleState
{
    return ^UIButton*(NSString *title,UIControlState state) {
        [self setTitle:title forState:state];
        return self;
    };
}

- (UIButton *(^)(CGFloat titleFontSize))wg_titleFontSize
{
    return ^UIButton*(CGFloat titleFontSize) {
        self.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
        return self;
    };
}

- (UIButton *(^)(CGFloat titleFont,UIFontWeight weight))wg_titleFont
{
    return ^UIButton*(CGFloat titleFontSize,UIFontWeight weight) {
        self.titleLabel.font = [UIFont systemFontOfSize:titleFontSize weight:weight];
        return self;
    };
}

- (UIButton *(^)(UIImage *image))wg_image
{
    return ^UIButton*(UIImage *image) {
        [self setImage:image forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton *(^)(UIImage *image,UIControlState state))wg_imageState
{
    return ^UIButton*(UIImage *image,UIControlState state) {
        [self setImage:image forState:state];
        return self;
    };
}

- (UIButton *(^)(UIEdgeInsets titleInset))wg_titleInset
{
    return ^UIButton*(UIEdgeInsets titleInset) {
        self.titleEdgeInsets = titleInset;
        return self;
    };
}

- (UIButton *(^)(UIImage *))wg_backgroundImage
{
    return ^UIButton*(UIImage *image) {
        [self setBackgroundImage:image forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton *(^)(UIImage *,UIControlState))wg_backgroundImageState
{
    return ^UIButton*(UIImage *image,UIControlState state) {
        [self setBackgroundImage:image forState:state];
        return self;
    };
}

- (UIButton *(^)(UIEdgeInsets imageInset))wg_imageInset
{
    return ^UIButton *(UIEdgeInsets inset) {
        self.imageEdgeInsets = inset;
        return self;
    };
}

- (UIButton * _Nonnull (^)(WGImagePositionStyle,CGFloat))wg_positionStyle
{
    return ^UIButton *(WGImagePositionStyle positionStyle,CGFloat spacing) {
        [self wg_setImagePosition:positionStyle spacing:spacing];
        return self;
    };
}

- (UIButton * _Nonnull (^)(UIColor *,UIControlState))wg_backgroundColorState
{
    return ^UIButton *(UIColor * color,UIControlState state) {
        [self setBackgroundImage:[UIImage wg_imageWithColor:color size:self.frame.size] forState:state];
        return self;
    };
}

- (UIButton *)wg_disableAdjustsImageWhenHighlighted {
    self.adjustsImageWhenHighlighted = NO;
    return self;
}

@end
