//
//  ZXOpenResultsCollectionViewCell.h
//  ZXHY
//
//  Created by Bern Mac on 10/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXOpenResultsModel,ZXOpenResultsCollectionViewCell;

@protocol ZXOpenResultsCollectionViewCellDelegate <NSObject>

//马上启程回调
- (void)OpenResultsCollectionViewCell:(ZXOpenResultsCollectionViewCell *)view OpenResultsModel:(ZXOpenResultsModel *)resultsModel;


@end

@interface ZXOpenResultsCollectionViewCell : UICollectionViewCell

+ (NSString *)wg_cellIdentifier;

@property (nonatomic, weak) id <ZXOpenResultsCollectionViewCellDelegate> delegate;

- (void)zx_setDataWithResultModel:(ZXOpenResultsModel *)resultsModel ForItemAtIndexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
