//
//  ZXHomeDetailsBottomView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXHomeDetailsBottomView;
@class ZXHomeModel,ZXHomeListModel;

@protocol ZXHomeDetailsBottomViewDelegate <NSObject>

//评论按钮代理
- (void)zx_commentsDetailsBottomView:(ZXHomeDetailsBottomView *)detailsBottomView;

//讲两句代理
- (void)zx_remarkCommentsDetailsBottomView:(ZXHomeDetailsBottomView *)detailsBottomView;

@end

@interface ZXHomeDetailsBottomView : UIView

@property (nonatomic, weak) id <ZXHomeDetailsBottomViewDelegate> delegate;

- (void)zx_setListModel:(ZXHomeListModel *)listModel;

@end

NS_ASSUME_NONNULL_END
