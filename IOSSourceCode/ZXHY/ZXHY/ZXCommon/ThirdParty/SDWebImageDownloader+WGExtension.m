//
//  SDWebImageDownloader+WGExtension.m
//
//
//  Created by Arclin on 2018/6/12.
//

#import "SDWebImageDownloader+WGExtension.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

@implementation SDWebImageDownloader (WGExtension)

- (void)wg_downloadImageWithUrl:(NSURL *)imgUrl progress:(void (^)(NSInteger, NSInteger, NSURL * _Nullable))progress complete:(void (^)(UIImage *,NSData *))completeBlock
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *cacheKey = [manager cacheKeyForURL:imgUrl];
    UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheKey];
    NSData *thumbnailData = [[SDImageCache sharedImageCache] diskImageDataForKey:cacheKey];
    if(thumbnailImage){
        completeBlock(thumbnailImage,thumbnailData);
    }else {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:imgUrl options:0 progress:progress completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            [[[SDWebImageManager sharedManager] imageCache] storeImage:image imageData:data forKey:cacheKey cacheType:SDImageCacheTypeAll completion:nil];
            completeBlock(image, data);
        }];
    }
}

@end

@implementation NSObject (SDExtension)

//PNG格式的图片
- (CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

//GIF格式
- (CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

//JPG格式
- (CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}
@end

@implementation UIImageView (SDExtension)

- (CGSize)wg_setImageURL:(NSURL *)URL placeholderImage:(UIImage *)placehlder {
    
    if(URL == nil) return CGSizeZero;
    NSString* absoluteString = URL.absoluteString;
    //通过SDWebimage 查看图片是否已有缓存，如果有直接获取，如果没有，请求文件头
    if([[SDImageCache sharedImageCache] diskImageDataExistsWithKey:absoluteString]) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
        if(!image) {
            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:URL.absoluteString];
            image = [UIImage imageWithData:data];
        }
        if (image) {
            self.image = image;
            return image.size;
        }
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    CGSize size = CGSizeZero;
    //区分加载图片的类型
    if([pathExtendsion isEqualToString:@"png"]){
        size = [self downloadPNGImageSizeWithRequest:request];
    }else if([pathExtendsion isEqual:@"gif"]){
        size = [self downloadGIFImageSizeWithRequest:request];
    }else{
        size = [self downloadJPGImageSizeWithRequest:request];
    }
    [self sd_setImageWithURL:URL placeholderImage:placehlder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:URL.absoluteString toDisk:YES completion:^{
                
            }];
        }
    }];
    return size;
}

@end

@implementation UIButton (SDExtension)

- (CGSize)lm_setBackgroundImageURL:(NSURL *)URL state:(UIControlState)state {
    
    if(URL == nil) return CGSizeZero;
    NSString* absoluteString = URL.absoluteString;
    //通过SDWebimage 查看图片是否已有缓存，如果有直接获取，如果没有，请求文件头
    if([[SDImageCache sharedImageCache] diskImageDataExistsWithKey:absoluteString]) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
        if(!image) {
            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:URL.absoluteString];
            image = [UIImage imageWithData:data];
        }
        if (image) {
            [self setBackgroundImage:image forState:state];
            return image.size;
        }
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    CGSize size = CGSizeZero;
    
    //区分加载图片的类型
    if ([pathExtendsion isEqualToString:@"png"]) {
        size = [self downloadPNGImageSizeWithRequest:request];
    } else if([pathExtendsion isEqual:@"gif"]) {
        size = [self downloadGIFImageSizeWithRequest:request];
    } else {
        size = [self downloadJPGImageSizeWithRequest:request];
    }
    [self sd_setBackgroundImageWithURL:URL forState:state completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:URL.absoluteString toDisk:YES completion:^{
                
            }];
        }
    }];
    return size;
}

@end
