//
//  ZXHomeDetailsCommentsDisplayHeaderFooterView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXHomeDetailsCommentsDisplayHeaderFooterView;
@class ZXHomeDetailsCommentModel, ZXHomeDetailsCommentListModel,ZXHomeDetailsCommentReplyListModel;

@protocol ZXHomeDetailsCommentsDisplayHeaderFooterViewDelegate <NSObject>

//展示全部
- (void)zx_dispalyDisplayHeaderFooterView:(ZXHomeDetailsCommentsDisplayHeaderFooterView *)displayHeaderFooterView;


@end



@interface ZXHomeDetailsCommentsDisplayHeaderFooterView : UITableViewHeaderFooterView

+ (NSString *)wg_cellIdentifier;

@property (nonatomic, weak) id <ZXHomeDetailsCommentsDisplayHeaderFooterViewDelegate> delegate;

- (void)zx_setCommentListModel:(ZXHomeDetailsCommentListModel *)commentListModel;

@end

NS_ASSUME_NONNULL_END
