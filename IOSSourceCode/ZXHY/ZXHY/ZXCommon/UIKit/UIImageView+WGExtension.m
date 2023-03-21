//
//  UIImageView+WGKit.m
//  Yunhuoyouxuan
//
//  Created by apple on 2020/8/21.
//  Copyright © 2020 apple. All rights reserved.
//

#import "UIImageView+WGExtension.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WGExtension.h"
#import "UIColor+WGExtension.h"

#import "WGImageNameConst.h"
#import <SDWebImageFLPlugin/SDFLAnimatedImage.h>

#import "UIKit+AFNetworking.h"
#import "AFImageDownloader.h"

@implementation UIImageView (WGExtension)

+ (instancetype)wg_autolayoutImageViewWithImage:(UIImage*)image {
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.translatesAutoresizingMaskIntoConstraints = NO;
    imgView.image = image;
    return imgView;
}

+ (instancetype)wg_autolayoutImageView {
    return [self wg_autolayoutImageViewWithImage:nil];
}

+ (UIImageView *)wg_imageViewWithImageNamed:(NSString *)imageNamed {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNamed]];
}

+ (instancetype)wg_goodsTypeWithFrame:(CGRect)frame;
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor = UIColor.whiteColor;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (void)wg_setImageWithURL:(NSURL *)url {
    [self wg_setImageWithURL:url placeholderImage:nil completed:nil];
}

- (void)wg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self wg_setImageWithURL:url placeholderImage:placeholder completed:nil];
}

- (void)wg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(WGWebImageOptions)options {
    [self wg_setImageWithURL:url placeholderImage:placeholder options:options completed:nil];
}

- (void)wg_setImageWithURL:(NSURL *)url completed:(WGWebImageCompletionBlock)completedBlock {
    [self wg_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, WGImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
           completedBlock(image,error,cacheType,imageURL);
        }
    }];
}

- (void)wg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(WGWebImageCompletionBlock)completedBlock {
    
    [self wg_setImageWithURL:url placeholderImage:placeholder options:WGWebImageLowPriority completed:^(UIImage *image, NSError *error, WGImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image,error,cacheType,imageURL);
        }
    }];
}

- (void)wg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(WGWebImageOptions)options completed:(WGWebImageCompletionBlock)completedBlock {
    [self wg_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:^(UIImage *image, NSError *error, WGImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image,error,cacheType,imageURL);
        }
    }];
}

- (void)wg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(WGWebImageOptions)options progress:(WGWebImageDownloaderProgressBlock)progressBlock completed:(WGWebImageCompletionBlock)completedBlock {
    
    if (!placeholder)
    {
        placeholder = [UIImage imageNamed:WGImgCommon_img_item_placeholder];
    } else {
        self.image = placeholder;
    }
    if (url.absoluteString.length == 0){
        if (completedBlock) {
            completedBlock(nil,[NSError errorWithDomain:@"cn.weeget" code:-999 userInfo:@{NSLocalizedDescriptionKey:@"图片链接为空"}],WGImageCacheTypeNone,nil);
        }
        return;
    }
    NSAssert([url.absoluteString hasPrefix:@"http"], @"图片地址不完整");
    [self sd_setImageWithURL:url placeholderImage:placeholder options:(SDWebImageOptions)options context:@{
        SDWebImageContextPredrawingEnabled : @(NO)
    } progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (progressBlock) {
            progressBlock(receivedSize,expectedSize);
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (completedBlock) {
            completedBlock(image,error,[self mapType:cacheType],imageURL);
        }
    }];

   
}

- (WGImageCacheType)mapType:(SDImageCacheType)type{
    WGImageCacheType cacheType = 0;
    if (type == SDImageCacheTypeNone) {
        cacheType = WGImageCacheTypeNone;
    }else if (type == SDImageCacheTypeDisk){
        cacheType = WGImageCacheTypeDisk;
    }else if (type == SDImageCacheTypeMemory){
        cacheType = WGImageCacheTypeMemory;
    }
    return cacheType;
}

//图片加载的样式，加载中用一张颜色（f8f8f8）的图作为加载中的标志，failImage指加载失败后展示的图片
- (void)wg_setImageWithURLString:(NSString *)urlString failImage:(UIImage *)failImage
{
    [self wg_setImageWithURLString:urlString loadingColor:[UIColor wg_colorWithHexString:@"#f8f8f8"] failImage:failImage];
}

//图片加载的样式，loadingColor指加载中，用一张颜色的图作为加载中的标志，failImage指加载失败后展示的图片
- (void)wg_setImageWithURLString:(NSString *)urlString loadingColor:(UIColor *)loadingColor failImage:(UIImage *)failImage
{
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage wg_imageWithColor:loadingColor size:self.frame.size] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            self.image = image;
        } else {
            self.image = failImage;
        }
    }];
}



#pragma mark - 图片加载替换 抛弃 SDWebimage 改用 AFNetworking （因为同时加载多张图片，内存溢出）


- (void)zx_setImageWithURL:(NSURL *)url{

    [self setImageWithURL:url];
}


- (void)zx_setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage{
    
    [self setImageWithURL:url placeholderImage:placeholderImage];
}


- (void)zx_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage failImage:(UIImage *)failImage{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
   
    WEAKSELF;
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        STRONGSELF;
        self.image = image;
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        STRONGSELF;
        self.image = failImage;
        
    }];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure{
    
    [self setImageWithURLRequest:urlRequest placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        success(request, response, image);
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        failure(request, response, error);
        
    }];
}

@end
