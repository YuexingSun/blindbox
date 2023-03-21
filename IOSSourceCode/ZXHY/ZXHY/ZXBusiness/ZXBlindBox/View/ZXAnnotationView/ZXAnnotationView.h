//
//  ZXAnnotationView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/26.
//

#import <AMapNaviKit/AMapNaviKit.h>
#import "ZXOpenResultsModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZXAnnotationView : MAAnnotationView



- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel;

@end

NS_ASSUME_NONNULL_END
