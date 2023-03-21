//
//  ZXOpenBlindBoxViewController.h
//  ZXHY
//
//  Created by Bern Mac on 7/30/21.
//

#import "WGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXOpenBlindBoxViewController : WGBaseViewController

//获取问答数据
- (void)zx_reqApiGetBoxWithTypeId:(NSString *)typeId;

//获取盒子信息
- (void)zx_getBoxDataWithMood:(NSString *)mood Budget:(NSString *)budget Distance:(NSString *)distance QuestList:(NSMutableArray *)questList;

@end

NS_ASSUME_NONNULL_END
