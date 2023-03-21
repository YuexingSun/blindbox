//
//  ZXopenResultsSelectCollectionViewCell.h
//  ZXHY
//
//  Created by Bern Mac on 8/31/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXOpenResultsModel;

@interface ZXopenResultsSelectCollectionViewCell : UICollectionViewCell

+ (NSString *)wg_cellIdentifier;

- (void)zx_setDataWithResultModel:(ZXOpenResultsModel *)resultsModel ForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
