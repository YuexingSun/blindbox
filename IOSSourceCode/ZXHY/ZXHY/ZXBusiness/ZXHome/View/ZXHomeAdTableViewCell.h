//
//  ZXHomeAdTableViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXHomeModel,ZXHomeListModel;

@interface ZXHomeAdTableViewCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

- (void)zx_setListModel:(ZXHomeListModel *)listModel;

@end

NS_ASSUME_NONNULL_END
