//
//  ZXHomeLocationDetailsViewController.h
//  ZXHY
//
//  Created by Bern Lin on 2022/2/28.
//

#import "WGBaseViewController.h"

@class  ZXHomeModel,ZXHomeListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZXHomeLocationDetailsViewController : WGBaseViewController

- (void)zx_setHomeListModel:(ZXHomeListModel *)listModel;

@end

NS_ASSUME_NONNULL_END
