//
//  ZXReachedNumView.h
//  ZXHY
//
//  Created by Bern Mac on 8/26/21.
//

#import "WGBaseView.h"

@class ZXOpenResultsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZXReachedNumView : WGBaseView

//适配旧版导航结果页面
- (void)zx_resultsheaderViewOpenResultsModel:(ZXOpenResultsModel *)openResultsModel;

//适配绿色导航结果页面
- (void)zx_fitGreenViewOpenResultsModel:(ZXOpenResultsModel *)openResultsModel;

//适配绿色导航结果页面
- (void)zx_homeDetailsViewWithImageUrlList:(NSMutableArray *)imgList;


@end

NS_ASSUME_NONNULL_END
