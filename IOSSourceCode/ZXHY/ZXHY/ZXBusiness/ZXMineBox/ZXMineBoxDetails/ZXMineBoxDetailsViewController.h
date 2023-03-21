//
//  ZXMineBoxDetailsViewController.h
//  ZXHY
//
//  Created by Bern Mac on 8/30/21.
//

#import "WGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXOpenResultsModel;

@interface ZXMineBoxDetailsViewController : WGBaseViewController

//获取盲盒信息
- (void)ZX_ReqApiGetBoxDetail:(ZXOpenResultsModel *)resultsModel;

@end

NS_ASSUME_NONNULL_END
