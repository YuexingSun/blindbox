//
//  ZXHomeImageBannerPageControl.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXHomeImageBannerPageControl : UIPageControl

@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIImage *inactiveImage;
@property (nonatomic, assign) CGSize currentImageSize;
@property (nonatomic, assign) CGSize inactiveImageSize;

@end

NS_ASSUME_NONNULL_END
