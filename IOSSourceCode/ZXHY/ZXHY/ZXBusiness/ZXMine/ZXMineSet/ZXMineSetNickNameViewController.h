//
//  ZXMineSetNickNameViewController.h
//  ZXHY
//
//  Created by Bern Mac on 9/24/21.
//

#import "WGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class  ZXMineModel;
@class  ZXMineUserProfileModel;

@interface ZXMineSetNickNameViewController : WGBaseViewController

//数据赋值
- (void)zx_setMineModel:(ZXMineModel *)mineModel UserProfileMdoel:(ZXMineUserProfileModel *)userProfileModel;

@end

NS_ASSUME_NONNULL_END
