//
//  ZXHomeDetailsViewController.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import "WGBaseViewController.h"

@class ZXHomeModel,ZXHomeListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZXHomeDetailsViewController : WGBaseViewController

//首页进入直接带入数据
- (void)zx_setListModel:(ZXHomeListModel *)listModel;

//根据id进入
- (void)zx_setTypeIdToRequest:(NSString *)typeId;

@end

NS_ASSUME_NONNULL_END
