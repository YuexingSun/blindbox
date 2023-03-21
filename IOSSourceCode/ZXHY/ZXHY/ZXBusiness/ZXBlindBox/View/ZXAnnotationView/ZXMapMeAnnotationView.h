//
//  ZXMapMeAnnotationView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/8.
//

#import <AMapNaviKit/AMapNaviKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CLHeading;
@class ZXBlindBoxViewModel;

@interface ZXMapMeAnnotationView : MAAnnotationView

///heading信息
@property (nonatomic, strong) CLHeading *heading;

//数据传入
- (void)zx_blindBoxViewModel:(ZXBlindBoxViewModel *)blindBoxViewModel;

@end

NS_ASSUME_NONNULL_END
