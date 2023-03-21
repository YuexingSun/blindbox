//
//  ZXMapNavManager.h
//  ZXHY
//
//  Created by Bern Mac on 8/17/21.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

#import <MapKit/MKMapItem.h>//用于苹果自带地图

#import <MapKit/MKTypes.h>//用于苹果自带地图

#import <AMapNaviKit/AMapNaviKit.h>//高德地图导航
#import <AMapLocationKit/AMapLocationKit.h>//高德地图定位

NS_ASSUME_NONNULL_BEGIN

@interface ZXMapNavManager : NSObject


/**

*跳转到已经安装的地图

*@param coord 目标位置

*@param currentCoord 当前位置

*@return sheetAction

*/

+ (UIAlertController *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)coord currentLocation:(CLLocationCoordinate2D)currentCoord;



/**
*跳转到地理位置权限设置
*/
+ (void)zx_openLocationPermissions;


@end

NS_ASSUME_NONNULL_END
