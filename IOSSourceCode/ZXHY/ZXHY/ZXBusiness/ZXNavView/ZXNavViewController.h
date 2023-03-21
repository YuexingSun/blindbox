//
//  ZXNavViewController.h
//  ZXHY
//
//  Created by Bern Lin on 2022/4/7.
//

#import "WGBaseViewController.h"
#import "ZXOpenResultsModel.h"
#import "ZXBlindBoxViewModel.h"
#import "ZXMapNavManager.h"

@class ZXBlindBoxViewParentlistModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZXNavViewController : WGBaseViewController

//导航View
@property (nonatomic, strong) UIView  *navView;

//其他容器View（结果详情，导航指示等）
@property (nonatomic, strong) UIView  *otherContainerView;




//传入数据开始导航
- (void)zx_enterNavControllerWithResultsModel:(ZXOpenResultsModel *)openResultsModel ParentlistModel:(ZXBlindBoxViewParentlistModel *)parentlistModel;

//关闭导航页面
- (void)zx_dismissNavViewController;




@end

NS_ASSUME_NONNULL_END
