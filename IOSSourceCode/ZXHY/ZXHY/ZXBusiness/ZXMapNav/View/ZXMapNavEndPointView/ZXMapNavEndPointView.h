//
//  ZXMapNavEndPointView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/1.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@class ZXOpenResultsModel;
NS_ASSUME_NONNULL_BEGIN

@interface ZXMapNavEndPointView : UIView

//获取数据信息
- (void)zx_openResultslnglatModel:(ZXOpenResultsModel *)openResultsModel;
//道路信息
- (void)zx_updateNaviInfo:(AMapNaviInfo *)naviInfo;

@end

NS_ASSUME_NONNULL_END
