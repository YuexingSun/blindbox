//
//  ZXNavViewController+TravelManner.h
//  ZXHY
//
//  Created by Bern Lin on 2022/4/7.
//

#import "ZXNavViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXTerminalAnnotationView;

@interface ZXNavViewController (TravelManner)
<
AMapNaviDriveViewDelegate,
AMapNaviDriveManagerDelegate,
AMapNaviDriveDataRepresentable,
AMapNaviWalkViewDelegate,
AMapNaviWalkManagerDelegate,
AMapNaviWalkDataRepresentable,
MAMapViewDelegate
>

//数据模型
@property (nonatomic, strong) ZXOpenResultsModel  *openResultsModel;
@property (nonatomic, strong) ZXBlindBoxViewParentlistModel  *parentlistModel;

//起、终点 坐标
@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

//导航地图
@property (nonatomic, strong) MAMapView  *navMapView;






//驾车出行导航
- (void)zx_startDriveNav;

//步行出行导航
- (void)zx_startWalkNav;

// 计划路线并选择出行方式
- (void)zx_calculateRouteWithPlanrWithResultsModel:(ZXOpenResultsModel *)openResultsModel ParentlistModel:(ZXBlindBoxViewParentlistModel *)parentlistModel;

@end

NS_ASSUME_NONNULL_END
