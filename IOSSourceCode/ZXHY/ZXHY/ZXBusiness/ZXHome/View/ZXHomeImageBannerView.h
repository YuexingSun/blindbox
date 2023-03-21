//
//  ZXHomeImageBannerView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXHomeModel,ZXHomeListModel;


typedef NS_ENUM(NSUInteger, ZXBannerType) {
    ZXBannerType_Home,
    ZXBannerType_Details,
};

@interface ZXHomeImageBannerView : UIView


- (instancetype)initWithFrame:(CGRect)frame withBannerType:(ZXBannerType)bannerType;

- (void)zx_setListModel:(ZXHomeListModel *)listModel;
@end

NS_ASSUME_NONNULL_END
