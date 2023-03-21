//
//  AppDelegate+ZXInitialization.m
//  ZXHY
//
//  Created by Bern Mac on 8/12/21.
//

#import "AppDelegate+ZXInitialization.h"
#import "ZXLoginViewController.h"
#import "ZXPersonalDataManager.h"
#import "ZXVersionCheckUpdatesView.h"
#import "ZXVersionCheckUpdatesViewModel.h"
#import "ZXHomdAdView.h"
#import "ZXHomeAdModel.h"


@implementation AppDelegate (ZXInitialization)



#pragma mark - Initialization UI

//初始化Window
- (void)zx_initializationWindow{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 防止从二级界面返回时tabbar跳动
    [[UITabBar appearance] setTranslucent:NO];
    
    //获取需要缓存
    [self zx_needToCache];
    
//    是否已经登录且Token没有失效
    if ([self zx_isToken]){
        [self zx_setMainView];
    }else{
        [self zx_setLoginView];
    }
    
    
    
}

//设置登录号页面
- (void)zx_setLoginView{
    
    self.window.rootViewController = [[WGBaseNavigationController alloc] initWithRootViewController:[[ZXLoginViewController alloc] init]];
}

//设置主视图
- (void)zx_setMainView{
//    self.tabBarController  = [[WGBaseTabBarController alloc] init];
//    self.tabBarController.selectedIndex = 0;
//    self.window.rootViewController = self.tabBarController;
    
    
    
    
    //TODO: 修复
    self.tabBarController  = [[ZXBaseTabBarController alloc] init];
    self.window.rootViewController = self.tabBarController;
    
    //检查更新
    [self zx_reqApiGetInitData];
    
}


#pragma mark - NetworkRequest

//获取Token
- (void)zx_reqApiGetToken{
    
}


//退出登录请求
- (void)zx_reqApiLogout{
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiLogout Parameter:@{} success:^(NSDictionary * _Nonnull resultDic) {
        
    } failure:^(NSError * _Nonnull error) {
        
        
    }];
}

//获取客户端初始化信息--（检查是否需要更新）
- (void)zx_reqApiGetInitData{
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetInitData Parameter:@{} success:^(NSDictionary * _Nonnull resultDic) {
        
        ZXVersionCheckUpdatesViewModel *checkUpdatesModel = [ZXVersionCheckUpdatesViewModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"][@"versions"][@"ios"]];
        //检查展示类型
        ZXVersionCheckIndexShowViewModel *checkIndexShowModel = [ZXVersionCheckIndexShowViewModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"][@"indexshow"]];

#ifdef DEBUG
        checkUpdatesModel.force = 0;
#else

#endif

//
        
        NSDictionary *dict = [[[resultDic wg_safeObjectForKey:@"data"] wg_safeObjectForKey:@"versions"] wg_safeObjectForKey:@"ios"];
        
        if (checkUpdatesModel){
            ZX_SetUserDefaultsCheckupVersion(dict);
            [ZXPersonalDataManager shareNetworkManager].zx_checkUpdatesModel = checkUpdatesModel;
        }else{
            [ZXPersonalDataManager shareNetworkManager].zx_checkUpdatesModel = nil;
            ZX_RemoveUserDefaults(ZX_CheckupVersion);
        }
        
        //检查更新
        [self zx_checkupWithCheckUpdatesModel: [ZXPersonalDataManager shareNetworkManager].zx_checkUpdatesModel];
        
    } failure:^(NSError * _Nonnull error) {
        
        
    }];
}
 
//获取客户端初始化信息--（检查是否需要强制更新）
- (void)zx_reqApiGetInitDataIsForceUpdate{
    

    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetInitData Parameter:@{} success:^(NSDictionary * _Nonnull resultDic) {
        
        ZXVersionCheckUpdatesViewModel *checkUpdatesModel = [ZXVersionCheckUpdatesViewModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"][@"versions"][@"ios"]];
        
        

        if (checkUpdatesModel){
            NSDictionary *dict = [[[resultDic wg_safeObjectForKey:@"data"] wg_safeObjectForKey:@"versions"] wg_safeObjectForKey:@"ios"];
            ZX_SetUserDefaultsCheckupVersion(dict);
            [ZXPersonalDataManager shareNetworkManager].zx_checkUpdatesModel = checkUpdatesModel;
        }else{
            [ZXPersonalDataManager shareNetworkManager].zx_checkUpdatesModel = nil;
            ZX_RemoveUserDefaults(ZX_CheckupVersion);
        }
        
        //TODO: 修复
        checkUpdatesModel.force = 0;
        //不需要强更新时广告
        if (checkUpdatesModel.force == 0){
            //首页广告弹窗
            [self zx_reqApiInfomationGetPopupPic];
            
            return;
        }
        
        else if (checkUpdatesModel.force == 1){
            //检查更新
            [self zx_checkupWithCheckUpdatesModel: [ZXPersonalDataManager shareNetworkManager].zx_checkUpdatesModel];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
        
    }];
}

#pragma mark - Private Method

//判断是否有缓存token
- (bool)zx_isToken{
    
    if (kIsEmptyString([ZXPersonalDataManager shareNetworkManager].zx_token)){
        return NO;
    }else{
        return YES;
    }
}


//获取需要缓存数据
- (void)zx_needToCache{
    
    [ZXPersonalDataManager shareNetworkManager].zx_token = kUserDefaultsToken;
    [ZXPersonalDataManager shareNetworkManager].zx_userName = kUserDefaultsUserName;
    [ZXPersonalDataManager shareNetworkManager].zx_userId = kUserDefaultsUserId;
    [ZXPersonalDataManager shareNetworkManager].zx_isNew = kUserDefaultsIsNew;
    [ZXPersonalDataManager shareNetworkManager].zx_isFristEntryBoxTips = kUserDefaultsIsFristEntryBoxTips;
    [ZXPersonalDataManager shareNetworkManager].zx_isCloseExitNavTips = kUserDefaultsIsCloseExitNavTips;

}

//清除用户个人缓存数据
- (void)zx_removeUserCache{
    
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    
    [self zx_needToCache];
    
    
}



//登录时调用
- (void)zx_loginAction{

    ZX_SetUserDefaultsToken([ZXPersonalDataManager shareNetworkManager].zx_token);
    
    [self zx_needToCache];
    
    [self zx_setMainView];
}


//退出登录
- (void)zx_logoutActionIsRequest:(BOOL)isRequest{
    
    if (isRequest){
        [self zx_reqApiLogout];
    }

    [self zx_removeUserCache];
    
    [self zx_setLoginView];
}

//检测更新
- (void)zx_checkupWithCheckUpdatesModel:(ZXVersionCheckUpdatesViewModel *)checkUpdatesModel{
    
    //获取版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *verionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //判断是否需要更新
    NSInteger updateVersion = [self zx_compareVersion:verionStr toVersion:checkUpdatesModel.newest];
    
    if (updateVersion <= 0){
        //不需要更新
        //首页广告弹窗
        [self zx_reqApiInfomationGetPopupPic];
        
        return;
    }
    
    //如果超过太多版本直接强更
    if (updateVersion >= 2){
        checkUpdatesModel.force = 1;
    }
        
    ZXVersionCheckUpdatesView *view = [[ZXVersionCheckUpdatesView alloc] initWithFrame:CGRectMake(0, 0, 257, 290) withVersionCheckUpdatesModel:checkUpdatesModel];
    
    WGGeneralAlertController *generalAlertVC = [WGGeneralAlertController alertControllerWithCustomView:view];
    [self.window.rootViewController presentViewController:generalAlertVC animated:NO completion:nil];
    
    view.checkUpdatesViewBlock = ^{
       
        [generalAlertVC dismissViewControllerAnimated:YES completion:^{
            //首页广告弹窗
            [self zx_reqApiInfomationGetPopupPic];
        }];
        
       
    };
    
   
    
    
}

//获取首页信息流列表弹出广告
- (void)zx_reqApiInfomationGetPopupPic{

   NSInteger current = [[self zx_getCurrentDate] intValue] - [(NSString *)ZX_GetUserDefaults(ZX_AdView) intValue];
    
    if (current == 0) {
        NSLog(@"当天已经关闭，明天重启");
        return;;
    }
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationGetPopupPic Parameter:@{} success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        ZXHomeAdModel *adModel = [ZXHomeAdModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        
        if (adModel.showpic){
            
            
            //广告
            ZXHomdAdView *adView = [[ZXHomdAdView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight())];
            [adView zx_homeAdModel:adModel];
            
            
            WGGeneralAlertController *generalAlertVC = [WGGeneralAlertController alertControllerWithCustomView:adView];
            [self.window.rootViewController presentViewController:generalAlertVC animated:NO completion:nil];
            
            WEAKSELF;
            adView.closeAdViewBlock = ^{
                STRONGSELF;
                ZX_SetUserDefaults(ZX_AdView, [self zx_getCurrentDate]);
                [generalAlertVC dismissViewControllerAnimated:YES completion:nil];
            };
        }
        
       
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}


//版本号判断
- (NSInteger)zx_compareVersion:(NSString *)deviceVersion toVersion:(NSString *)severVersion{
    
    deviceVersion =  [deviceVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    severVersion =  [severVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSInteger a = [deviceVersion integerValue];
    NSInteger b = [severVersion integerValue];
    
    return b - a;
    
    
}




//判断当前日期
- (void)zx_data{

    
    
    //广告
    ZX_GetUserDefaults(ZX_AdView);
    ZX_SetUserDefaults(ZX_AdView, @"");
    ZX_RemoveUserDefaults(ZX_AdView);
    
    
}

- (NSString *)zx_getCurrentDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    //获取当前时间日期展示字符串 如：20190523
    NSString *str = [formatter stringFromDate:date];
    NSLog(@"当前日期---%@",str);
    return str;
}

@end
