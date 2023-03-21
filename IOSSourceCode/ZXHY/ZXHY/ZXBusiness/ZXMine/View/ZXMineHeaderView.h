//
//  ZXMineHeaderView.h
//  ZXHY
//
//  Created by Bern Mac on 8/27/21.
//

#import "WGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXMineModel;
@class ZXMineUserProfileModel;

@interface ZXMineHeaderView : WGBaseView

//数据赋值
- (void)zx_dataWithMineModel:(ZXMineModel *)mineModel;

@end

NS_ASSUME_NONNULL_END
