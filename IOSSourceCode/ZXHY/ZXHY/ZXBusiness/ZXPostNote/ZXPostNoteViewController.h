//
//  ZXPostNoteViewController.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/24.
//

#import "WGBaseViewController.h"

@class ZXHomeModel,ZXHomeListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZXPostNoteViewController : WGBaseViewController

//编辑进入
- (void)zx_editNoteWithHomeListModel:(ZXHomeListModel *)listModel;


@end

NS_ASSUME_NONNULL_END
