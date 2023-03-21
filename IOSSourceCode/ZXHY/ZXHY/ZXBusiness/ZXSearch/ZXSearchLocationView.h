//
//  ZXSearchLocationView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/31.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXSearchLocationView;

@protocol ZXSearchLocationViewDelegate <NSObject>

//关闭
- (void)zx_closeSearchLocationView:(ZXSearchLocationView *)locationView;

//选中的地理位置
- (void)zx_selectSearchLocationView:(ZXSearchLocationView *)locationView AMapPOI:(AMapPOI *)mapPOI;

@end

@interface ZXSearchLocationView : UIView

@property (nonatomic, weak) id <ZXSearchLocationViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame withCurrentCoordinate:(CLLocationCoordinate2D) currentCoordinate;
@end

NS_ASSUME_NONNULL_END
