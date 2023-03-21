//
//  ZXMapNavDetailsView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/1.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXOpenResultsModel,ZXBlindBoxViewParentlistModel,AMapNaviCommonObj;

@interface ZXMapNavDetailsView : UIView



//数据
- (void)zx_openResultslnglatModel:(ZXOpenResultsModel *)openResultsModel ParentlistModel:(ZXBlindBoxViewParentlistModel *)parentlistModel;

//道路信息
- (void)zx_updateNaviInfo:(AMapNaviInfo *)naviInfo;

//转向图
- (void)zx_setTurnIconImage:(UIImage  *)turnIconImage;

@end

NS_ASSUME_NONNULL_END
