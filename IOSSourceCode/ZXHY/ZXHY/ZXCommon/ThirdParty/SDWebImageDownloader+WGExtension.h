//
//  SDWebImageDownloader+WGExtension.h
//
//
//  Created by Arclin on 2018/6/12.
//

#import <SDWebImage/SDWebImageDownloader.h>

@interface SDWebImageDownloader (WGExtension)

- (void)wg_downloadImageWithUrl:(NSURL *)imgUrl progress:(void(^_Nullable)(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL))progress complete:(void(^)(UIImage *,NSData *))completeBlock;

@end

@interface NSObject (SDExtension)

@end

@interface UIImageView (SDExtension)

- (CGSize)wg_setImageURL:(NSURL *)URL placeholderImage:(UIImage *)placehlder;

@end

@interface UIButton (SDExtension)

- (CGSize)lm_setBackgroundImageURL:(NSURL *)URL state:(UIControlState)state;

@end
