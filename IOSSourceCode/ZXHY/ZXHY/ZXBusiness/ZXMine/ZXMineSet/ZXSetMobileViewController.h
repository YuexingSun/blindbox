//
//  ZXSetMobileViewController.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/4.
//

#import "WGBaseViewController.h"

@class ZXMineModel, ZXMineUserProfileModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZXSetMobileViewController : WGBaseViewController

- (void)zx_setMineModel:(ZXMineModel *)mineModel UserProfileMdoel:(ZXMineUserProfileModel *)userProfileModel;

@end

NS_ASSUME_NONNULL_END
