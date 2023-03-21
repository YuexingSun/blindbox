//
//  ZXOpenResultsViewController.h
//  ZXHY
//
//  Created by Bern Mac on 7/30/21.
//

#import "WGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXOpenResultsViewController : WGBaseViewController

//获取盒子信息
- (void)zx_getBlindBox:(NSDictionary *)resultDic;


//进行中数据传入
- (void)zx_getBeingBox:(NSString *)boxid;

@end

NS_ASSUME_NONNULL_END
