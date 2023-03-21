//
//  ZXBlindBoxFloatTagView.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/11.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CLLocation.h>

@class ZXBlindBoxFloatTagModel,ZXBlindBoxFloatTagView;

NS_ASSUME_NONNULL_BEGIN

@protocol ZXBlindBoxFloatTagViewDelegate <NSObject>

//选中Item cateId
- (void)zx_blindBoxFloatTagView:(ZXBlindBoxFloatTagView *)floatTagView didSelectItemAtCateId:(NSString *)cateId;

@end



@interface ZXBlindBoxFloatTagView : UIView

@property (nonatomic, weak) id <ZXBlindBoxFloatTagViewDelegate> delegate;

//传入位置坐标
- (void)zx_inputStartPoint:(CLLocationCoordinate2D)starPoint;

//暂停所有定时器
- (void)zx_pauseAllTimerRunloop;

//开始所有定时器
- (void)zx_resumeAllTimerRunloop;

@end

NS_ASSUME_NONNULL_END
