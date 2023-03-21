//
//  AppDelegate.m
//  ZXHY
//
//  Created by Bern Mac on 7/28/21.
//

#import "AppDelegate.h"
#import "WGBaseNavigationController.h"
#import "AppDelegate+ZXInitialization.h"
#import "JANALYTICSService.h"
#import "ZXNetworkManager.h"
#import "WXApi.h"
#import "AFNetworkActivityIndicatorManager.h"


//TODO: 修复
#import "ZXBaseTabBarController.h"

@interface AppDelegate ()
<
UITabBarControllerDelegate,
WXApiDelegate
>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化第三方SDK
    [self zx_initMap];
    [self zx_initCertification];
    [self zx_initStatistics];
    
    //向微信注册
    [WXApi registerApp:(NSString *)APIKey_WeChat universalLink:(NSString *)UNIVERSAL_LINK];
 
    //初始化Window
    [self zx_initializationWindow];
    
    //检测网络状态
    [[ZXNetworkManager shareNetworkManager] zx_reachability];
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{

}

//ios9.0以上要使用这个新方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
   
    //极光动态圈
    if ([JANALYTICSService handleUrl:url]) {
        return YES;
    }
    //weixin
    return  [WXApi handleOpenURL:url delegate:self];
   
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}



//微信回调
-(void) onResp:(BaseResp*)resp{
    
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
    }
}




@end
