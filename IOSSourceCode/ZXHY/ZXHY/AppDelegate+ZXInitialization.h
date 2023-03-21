//
//  AppDelegate+ZXInitialization.h
//  ZXHY
//
//  Created by Bern Mac on 8/12/21.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (ZXInitialization)


//初始化Window
- (void)zx_initializationWindow;

//获取客户端初始化信息--（检查是否需要更新）
- (void)zx_reqApiGetInitData;

//检查是否需要强制更新
- (void)zx_reqApiGetInitDataIsForceUpdate;


//登录时调用
- (void)zx_loginAction;


/**
 * @brief 退出登陆 是否需要请求退出登陆接口.
 * @param isRequest  YES代表退出登陆时需要请求退出登陆接口，NO则反之。
 */
- (void)zx_logoutActionIsRequest:(BOOL)isRequest;
    
@end

NS_ASSUME_NONNULL_END
