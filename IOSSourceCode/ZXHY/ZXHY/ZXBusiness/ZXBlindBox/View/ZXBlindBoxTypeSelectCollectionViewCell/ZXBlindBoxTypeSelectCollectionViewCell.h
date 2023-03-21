//
//  ZXBlindBoxTypeSelectCollectionViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/23.
//

#import <UIKit/UIKit.h>

@class ZXOpenResultsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZXBlindBoxTypeSelectCollectionViewCell : UICollectionViewCell

+ (NSString *)wg_cellIdentifier;

- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel AtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
