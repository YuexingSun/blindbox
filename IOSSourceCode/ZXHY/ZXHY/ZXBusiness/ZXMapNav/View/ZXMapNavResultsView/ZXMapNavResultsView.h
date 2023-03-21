//
//  ZXMapNavResultsView.h
//  ZXHY
//
//  Created by Bern Mac on 8/9/21.
//

#import "WGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXOpenResultsModel;
@class ZXMapNavResultsView;

@protocol ZXMapNavResultsViewDelegate <NSObject>

//我知道了 或 取消 响应
- (void)closeResultsView:(ZXMapNavResultsView *)resultsView;


@end


@interface ZXMapNavResultsView : WGBaseView

@property (nonatomic, weak) id <ZXMapNavResultsViewDelegate> delegate;

//传入数据
- (void)zx_openResultslnglatModel:(ZXOpenResultsModel *)openResultsModel IsFirst:(BOOL)isFirst;


@end

NS_ASSUME_NONNULL_END
