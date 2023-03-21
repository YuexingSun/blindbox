//
//  ZXNotificationMacro.h
//  ZXHY
//
//  Created by Bern Mac on 8/30/21.
//

#ifndef ZXNotificationMacro_h
#define ZXNotificationMacro_h

#pragma mark - 网络状态
static NSString * const ZXNotificationMacro_NetworkStatus = @"ZXNetworkStatus";

//===================首页===================
#pragma mark - 首页
static NSString * const ZXNotificationMacro_Home= @"ZXHomeViewController";

#pragma mark - 首页（点赞。收藏。评论）
static NSString * const ZXNotificationMacro_HomeSupportCollectionComments= @"ZXHomeSupportCollectionComments";

#pragma mark - 笔记刷新
static NSString * const ZXNotificationMacro_PostOrDeleteNote = @"ZXNotificationMacroPostOrDeleteNote";

//===================盲盒===================//
#pragma mark - 盲盒
static NSString * const ZXNotificationMacro_BlindBox = @"ZXBlindBoxViewController";

#pragma mark - 是否有进行中的盲盒
static NSString * const ZXNotificationMacro_BlindBoxIsBeingBox = @"ZXBlindBoxIsBeingBox";

#pragma mark - 盲盒Tabbar刷新
static NSString * const ZXNotificationMacro_BlindBoxTabbarReload = @"ZXBlindBoxTabbarReload";

#pragma mark - 我的盲盒
static NSString * const ZXNotificationMacro_MineBox = @"ZXMineBoxViewController";

#pragma mark - 修改个人资料
static NSString * const ZXNotificationMacro_MineSet = @"ZXMineSet";

#pragma mark - 退出导航
static NSString * const ZXNotificationMacro_ExitNav = @"ZXExitNav";

#pragma mark - 评价完成
static NSString * const ZXNotificationMacro_Evaluation = @"ZXEvaluation";

#endif /* ZXNotificationMacro_h */
