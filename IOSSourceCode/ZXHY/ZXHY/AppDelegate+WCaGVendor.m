//
//  AppDelegate+WCaGVendor.m
//  Yunhuoyouxuan
//
//  Created by Bern on 2020/10/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "AppDelegate+WCaGVendor.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapNavikit/AMapNaviManagerConfig.h>
#import "JVERIFICATIONService.h"
#import "JSHAREService.h"
#import <AdSupport/AdSupport.h>
#import "JANALYTICSService.h"


@interface AppDelegate (WGCaAdd)

@end

@implementation AppDelegate (WCaGVendor)

+ (AppDelegate *)wg_sharedDelegate
{
    id <UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    if ([delegate isKindOfClass:[AppDelegate class]])
    {
        return (AppDelegate *)delegate;
    }
    return nil;
}


#pragma mark - 高德地图
- (void)zx_initMap{
//    [AMapServices sharedServices].enableHTTPS = YES;
    
    [AMapServices sharedServices].apiKey = [self zx_getBundleIdentifier] ? (NSString *)APIKey_Map: (NSString *)APIKey_MapTest;
    
    //更新用户授权高德SDK隐私协议状态. since 8.1.0
    [[AMapNaviManagerConfig sharedConfig] updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    
    //更新App是否显示隐私弹窗的状态，隐私弹窗是否包含高德SDK隐私协议内容的状态. since 8.1.0
    [[AMapNaviManagerConfig sharedConfig] updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
}


#pragma mark - 极光认证
- (void)zx_initCertification{
    //集成极光认证sdk
    
    //同意隐私协议：
//    [JGInforCollectionAuth JCollectionAuth:^(JGInforCollectionAuthItems * _Nonnull authInfo)  {
//        authInfo.isAuth = YES;
//    }];
    
    // 如需使用 IDFA 功能请添加此代码并在初始化配置类中设置 advertisingId
    NSString *idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    JVAuthConfig *config = [[JVAuthConfig alloc] init];
    config.appKey = [self zx_getBundleIdentifier] ? (NSString *)APIKey_Certification : (NSString *)APIKey_CertificationTest;
    config.advertisingId = idfaStr;
    config.timeout = 5000;
    config.authBlock = ^(NSDictionary *result) {
        NSLog(@"jverification init result:%@", result);
    };
    [JVERIFICATIONService setupWithConfig:config];
    [JVERIFICATIONService setDebug:YES];
    
    NSLog(@"[JVERIFICATIONService  isSetupClient] result:%d", [JVERIFICATIONService  isSetupClient]);
}

#pragma mark - 极光统计
- (void)zx_initStatistics{
    JANALYTICSLaunchConfig * config = [[JANALYTICSLaunchConfig alloc] init];
     
    config.appKey = [self zx_getBundleIdentifier] ? (NSString *)APIKey_Certification : (NSString *)APIKey_CertificationTest;
     
    config.channel = @"channel";
     
    [JANALYTICSService setupWithConfig:config];
    
    //崩溃日志统计
    [JANALYTICSService crashLogON];
    
    //上报频率 十分钟上报一次
    [JANALYTICSService setFrequency:600];
}



#pragma mark - 微信
- (void)zx_initWeChat{
    
    
    
    
}





#pragma mark - 获取当前 BundleIdentifier (YES 代表正式 / NO代表测试)
- (bool)zx_getBundleIdentifier{
    
    NSString *cuntterID = [[NSBundle mainBundle] bundleIdentifier];
    
    NSLog(@"\n\n\nBundleIdentifier--------------%@\n\n\n\n",cuntterID);
    
    if ([cuntterID isEqualToString:(NSString *)BundleIdentifierTest]){
        return NO;
    }else{
        return YES;
    }
}

@end
