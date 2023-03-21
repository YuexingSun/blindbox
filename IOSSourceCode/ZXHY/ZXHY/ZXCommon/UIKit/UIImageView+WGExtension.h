//
//  UIImageView+WGKit.h
//  Yunhuoyouxuan
//
//  Created by apple on 2020/8/21.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, WGWebImageOptions) {
    WGWebImageRetryFailed = 1 << 0,
    WGWebImageLowPriority = 1 << 1,
    WGWebImageProgressiveLoad = 1 << 2,
    WGWebImageRefreshCached = 1 << 3,
    WGWebImageContinueInBackground = 1 << 4,
    WGWebImageHandleCookies = 1 << 5,
    WGWebImageAllowInvalidSSLCertificates = 1 << 6,
    WGWebImageHighPriority = 1 << 7,
    WGWebImageDelayPlaceholder = 1 << 8,
    WGWebImageTransformAnimatedImage = 1 << 9,
    WGWebImageAvoidAutoSetImage = 1 << 10,
    WGWebImageScaleDownLargeImages = 1 << 11,
    WGWebImageQueryMemoryData = 1 << 12,
    WGWebImageQueryMemoryDataSync = 1 << 13,
    WGWebImageQueryDiskDataSync = 1 << 14,
    WGWebImageFromCacheOnly = 1 << 15,
    WGWebImageFromLoaderOnly = 1 << 16,
    WGWebImageForceTransition = 1 << 17,
    WGWebImageAvoidDecodeImage = 1 << 18,
    WGWebImageDecodeFirstFrameOnly = 1 << 19,
    WGWebImagePreloadAllFrames = 1 << 20,
    WGWebImageMatchAnimatedImageClass = 1 << 21,
    WGWebImageWaitStoreCache = 1 << 22,
    WGWebImageTransformVectorImage = 1 << 23
};

typedef NS_ENUM(NSInteger, WGImageCacheType) {
    WGImageCacheTypeNone,
    WGImageCacheTypeDisk,
    WGImageCacheTypeMemory
};

typedef void(^WGWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);


typedef void(^WGWebImageCompletionBlock)(UIImage *image, NSError *error, WGImageCacheType cacheType, NSURL *imageURL);

typedef void(^WGWebImageCompletionWithFinishedBlock)(UIImage *image, NSError *error, WGImageCacheType cacheType, BOOL finished, NSURL *imageURL);

typedef NSString *(^WGWebImageCacheKeyFilterBlock)(NSURL *url);

@interface UIImageView (WGExtension)

/// 生成一个不自动添加约束的UIImageView
+ (instancetype)wg_autolayoutImageViewWithImage:(UIImage*)image;

/// 生成一个不自动添加约束的UIImageView
+ (instancetype)wg_autolayoutImageView;

/// 用图片名实例化UIImageView
+ (UIImageView *)wg_imageViewWithImageNamed:(NSString *)imageNamed;

+ (instancetype)wg_goodsTypeWithFrame:(CGRect)frame;

- (void)wg_setImageWithURL:(NSURL *)url;

- (void)wg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)wg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(WGWebImageOptions)options;

- (void)wg_setImageWithURL:(NSURL *)url completed:(WGWebImageCompletionBlock)completedBlock;

- (void)wg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(WGWebImageCompletionBlock)completedBlock;

- (void)wg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(WGWebImageOptions)options completed:(WGWebImageCompletionBlock)completedBlock;

- (void)wg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(WGWebImageOptions)options progress:(WGWebImageDownloaderProgressBlock)progressBlock completed:(WGWebImageCompletionBlock)completedBlock;

//图片加载的样式，加载中用一张颜色（f8f8f8）的图作为加载中的标志，failImage指加载失败后展示的图片
- (void)wg_setImageWithURLString:(NSString *)urlString failImage:(UIImage *)failImage;
//图片加载的样式，loadingColor指加载中，用一张颜色的图作为加载中的标志，failImage指加载失败后展示的图片
- (void)wg_setImageWithURLString:(NSString *)urlString loadingColor:(UIColor *)loadingColor failImage:(UIImage *)failImage;


#pragma mark - 图片加载替换 抛弃 SDWebimage 改用 AFNetworking （因为同时加载多张图片，内存溢出）
- (void)zx_setImageWithURL:(NSURL *)url;


- (void)zx_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholderImage;

- (void)zx_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage failImage:(UIImage *)failImage;


- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure;

@end
