//
//  ZXHomeDetailsCommentsTableViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXHomeDetailsCommentModel, ZXHomeDetailsCommentListModel,ZXHomeDetailsCommentReplyListModel;

@class ZXHomeDetailsCommentsTableViewCell;

@protocol ZXHomeDetailsCommentsTableViewCellDelegate <NSObject>

//长按删除或举报
- (void)zx_longClickCommentCell:(ZXHomeDetailsCommentsTableViewCell *)commentCell withCommentListModel:(ZXHomeDetailsCommentReplyListModel *)replyListModel;

@end



@interface ZXHomeDetailsCommentsTableViewCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

@property (nonatomic, weak) id <ZXHomeDetailsCommentsTableViewCellDelegate> delegate;

- (void)zx_setCommentReplyListModel:(ZXHomeDetailsCommentReplyListModel *)replyListModel;

@end

NS_ASSUME_NONNULL_END
