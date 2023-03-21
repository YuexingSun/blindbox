//
//  ZXHomeTopAdCollectionViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2022/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXHomeAdModel,ZXHomeTopAdModel;

@interface ZXHomeTopAdCollectionViewCell : UICollectionViewCell

+ (NSString *)wg_cellIdentifier;

- (void)zx_homeTopAdModel:(ZXHomeAdModel *)adModel;

@end

NS_ASSUME_NONNULL_END
