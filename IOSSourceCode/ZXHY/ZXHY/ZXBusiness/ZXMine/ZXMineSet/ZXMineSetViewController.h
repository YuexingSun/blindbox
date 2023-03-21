//
//  ZXMineSetViewController.h
//  ZXHY
//
//  Created by Bern Mac on 9/23/21.
//

#import "WGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class  ZXMineModel;
@class  ZXMineUserProfileModel;

@interface ZXMineSetViewController : WGBaseViewController

//数据赋值
- (void)zx_setMineModel:(ZXMineModel *)mineModel UserProfileMdoel:(ZXMineUserProfileModel *)userProfileModel;

@end

NS_ASSUME_NONNULL_END
