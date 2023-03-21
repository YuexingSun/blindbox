//
//  UIImage+Scacle.h
//  amys
//
//  Created by 杨智晓 on 15/8/22.
//  Copyright (c) 2015年 swin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#define IMAGENAMED(NAME) [UIImage wg_imageNamed:NAME]

@interface UIImage (WGExtension)

+ (UIImage *)wg_imageNamed:(NSString *)imageNamed;

/// 修改图片尺寸
/// @param newSize 新尺寸
- (UIImage *)wg_scaledToSize:(CGSize)newSize;

+ (void)wg_saveImage:(UIImage *)tempImage withName:(NSString *)imageName inDocument:(NSString *)documentName;

+ (UIImage *)wg_getImageWithName:(NSString *)imageName;

/// create a round image with image's size and radius
+ (UIImage *)wg_createRoundedRectImage:(UIImage *)image withSize:(CGSize)size withRadius:(NSInteger)radius;

/**获取指定颜色和大小的图片*/
+ (UIImage *)wg_imageWithColor:(UIColor *)color;
+ (UIImage *)wg_imageWithColor:(UIColor *)color size:(CGSize)size;

/// webView截图
/// @param webView webView
+ (UIImage *)wg_imageRepresentationWithWebView:(WKWebView *)webView;

/**
 修正图片
 */
- (UIImage *)wg_fixOrientation;

/**
 图片旋转
 */
+ (UIImage *)wg_image:(UIImage *)image rotation:(UIImageOrientation)orientation;
/**
 图片旋转
 */
- (UIImage *)wg_imageWithOrientation:(UIImageOrientation)orientation;

/**
 压缩图片到指定大小data
 */
+ (NSData *)wg_scaleImage:(UIImage *)image toKb:(NSInteger)kb;
/**
 压缩图片到指定大小data
 */
- (NSData *)wg_imageDataToKb:(NSInteger)kb;

/**
 压缩图片到指定大小image
 */
+ (UIImage *)wg_compressedImage:(UIImage *)image toKb:(NSInteger)kb;

/// 压缩图片到指定大小image
/// @param kb 大小（kb）
- (UIImage *)wg_imageToKb:(NSInteger)kb;

/// 带透明度的图片
- (UIImage *)wg_imageWithAlpha:(CGFloat)alpha;

/**
 *  从图片中按指定的位置大小截取图片的一部分
 *  @param rect  CGRect rect 要截取的区域
 *  @return UIImage
 */
- (UIImage *)wg_imageInRect:(CGRect)rect;
    
// 查找导航栏下的横线
+ (nullable UIImageView *)wg_seekLineImageViewOn:(nullable UIView *)view;

@end
