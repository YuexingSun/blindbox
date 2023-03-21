//
//  ZXHomeDetailsCommentsHeaderFooterView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXHomeDetailsCommentModel, ZXHomeDetailsCommentListModel;
@class ZXHomeDetailsCommentsHeaderFooterView;

@protocol ZXHomeDetailsCommentsHeaderFooterViewDelegate <NSObject>

//点击评论
- (void)zx_clickCommentView:(ZXHomeDetailsCommentsHeaderFooterView *)CommentView withCommentListModel:(ZXHomeDetailsCommentListModel *)commentListModel;

//长按删除或举报
- (void)zx_longClickCommentView:(ZXHomeDetailsCommentsHeaderFooterView *)CommentView withCommentListModel:(ZXHomeDetailsCommentListModel *)commentListModel;

@end

@interface ZXHomeDetailsCommentsHeaderFooterView : UITableViewHeaderFooterView

+ (NSString *)wg_cellIdentifier;

@property (nonatomic, weak) id <ZXHomeDetailsCommentsHeaderFooterViewDelegate> delegate;

- (void)zx_setCommentListModel:(ZXHomeDetailsCommentListModel *)commentListModel;



@end

NS_ASSUME_NONNULL_END
