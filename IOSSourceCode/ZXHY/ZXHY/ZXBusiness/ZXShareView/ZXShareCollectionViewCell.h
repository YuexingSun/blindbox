//
//  ZXShareCollectionViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/23.
//

#import "WGBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXShareCollectionViewCell : WGBaseCollectionViewCell

+ (NSString *)wg_cellIdentifier;


- (void)zx_typeImage:(UIImage *)img typeTitle:(NSString *)titStr;

@end

NS_ASSUME_NONNULL_END
