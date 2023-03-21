//
//  ZXTerminalAnnotationView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/3.
//

#import <AMapNaviKit/AMapNaviKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXOpenResultsModel;

@interface ZXTerminalAnnotationView : MAAnnotationView

//获取数据信息
- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel;

//道路信息
- (void)zx_updateNaviInfo:(AMapNaviInfo *)naviInfo;

@end

NS_ASSUME_NONNULL_END
