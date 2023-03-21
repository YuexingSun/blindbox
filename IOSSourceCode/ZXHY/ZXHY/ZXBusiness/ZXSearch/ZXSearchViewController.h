//
//  ZXSearchViewController.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/20.
//

#import "WGBaseViewController.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSearchViewController : WGBaseViewController

//当前经纬度
@property(nonatomic,assign) CLLocationCoordinate2D currentCoordinate;

@end

NS_ASSUME_NONNULL_END
