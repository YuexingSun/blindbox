//
//  ZXMineBoxListViewController.h
//  ZXHY
//
//  Created by Bern Mac on 8/27/21.
//

#import "WGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMineBoxListViewController : WGBaseViewController

//(0、1、2、3)
//@"全部",@"已完成",@"已失效",@"待评价"
@property (nonatomic, assign) NSInteger vcType;



@end

NS_ASSUME_NONNULL_END
