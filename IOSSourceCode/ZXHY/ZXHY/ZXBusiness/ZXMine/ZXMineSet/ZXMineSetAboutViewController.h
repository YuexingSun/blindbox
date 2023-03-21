//
//  ZXMineSetAboutViewController.h
//  ZXHY
//
//  Created by Bern Mac on 9/27/21.
//

#import "WGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXMineModel;

@interface ZXMineSetAboutViewController : WGBaseViewController


//数据赋值
- (void)zx_setMineModel:(ZXMineModel *)mineModel;

@end

NS_ASSUME_NONNULL_END
