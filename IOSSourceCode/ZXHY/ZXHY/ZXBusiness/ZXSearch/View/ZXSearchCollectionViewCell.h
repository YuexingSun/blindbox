//
//  ZXSearchCollectionViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSearchCollectionViewCell : UICollectionViewCell

+ (NSString *)wg_cellIdentifier;

- (void)zx_typeImage:(UIImage *)img typeTitle:(NSString *)titStr;

@end

NS_ASSUME_NONNULL_END
