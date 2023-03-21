//
//  ZXHomeDetailsNumberOfRepliesHeaderFooterView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXHomeModel,ZXHomeListModel;
@class ZXHomeDetailsCommentModel, ZXHomeDetailsCommentListModel;



@interface ZXHomeDetailsNumberOfRepliesHeaderFooterView : UITableViewHeaderFooterView

+ (NSString *)wg_cellIdentifier;

- (void)zx_setDetailsCommentModel:(ZXHomeDetailsCommentModel *)commentModel;

@end

NS_ASSUME_NONNULL_END
