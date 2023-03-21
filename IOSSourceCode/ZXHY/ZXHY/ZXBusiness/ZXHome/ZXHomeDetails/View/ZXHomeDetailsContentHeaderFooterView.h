//
//  ZXHomeDetailsContentHeaderFooterView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXHomeModel,ZXHomeListModel;
@class ZXHomeDetailsContentHeaderFooterView;


@protocol ZXHomeDetailsContentHeaderFooterViewDelegate <NSObject>

//地理位置点击
- (void)zx_didLoactionDetailsContentView:(ZXHomeDetailsContentHeaderFooterView *)contentView withListModel:(ZXHomeListModel *)listModel;

@end



@interface ZXHomeDetailsContentHeaderFooterView : UITableViewHeaderFooterView

+ (NSString *)wg_cellIdentifier;

//协议
@property (nonatomic, weak) id <ZXHomeDetailsContentHeaderFooterViewDelegate> delegate;

//模型赋值
- (void)zx_setListModel:(ZXHomeListModel *)listModel;

//计算高度
+ (CGFloat)zx_heightWithListModel:(ZXHomeListModel *)listModel;

//Html转文本加行高
+ (NSMutableAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString;

@end

NS_ASSUME_NONNULL_END
