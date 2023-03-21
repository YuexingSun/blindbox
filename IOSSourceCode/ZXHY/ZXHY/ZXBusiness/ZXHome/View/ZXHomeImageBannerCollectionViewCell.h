//
//  ZXHomeImageBannerCollectionViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXHomeImageBannerCollectionViewCell : UICollectionViewCell

+ (NSString *)wg_cellIdentifier;

@property (nonatomic, strong) UIImageView *bgView;

@end

NS_ASSUME_NONNULL_END
