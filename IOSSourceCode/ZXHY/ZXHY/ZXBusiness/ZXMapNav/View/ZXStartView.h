//
//  ZXStartView.h
//  ZXHY
//
//  Created by Bern Mac on 8/26/21.
//

#import "WGBaseView.h"

typedef NS_ENUM(NSUInteger, ZXStartType) {
    ZXStartType_Info,
    ZXStartType_Point,
};

@class ZXOpenResultsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZXStartView : WGBaseView

- (void)zx_scores:(NSString *)scores WithType:(ZXStartType)startType;

@end

NS_ASSUME_NONNULL_END
