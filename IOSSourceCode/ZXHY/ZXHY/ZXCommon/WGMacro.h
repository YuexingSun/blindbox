//
//  WGMacro.h
//  Pods
//
//  Created by apple on 2021/5/10.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#ifndef WGMacro_h
#define WGMacro_h

#pragma mark - 强弱引用
#define WEAKSELF                 typeof(self) __weak weakSelf = self;
#define STRONGSELF               __strong typeof(self) self = weakSelf;

#pragma mark - 通知中心

#define WGNotification           [NSNotificationCenter defaultCenter]

#pragma mark - 控制台中心输出网络日志（待删除）

#define WGNetworkLog(fmt, ...)   DDLogInfo((@"\n----------BEGIN----------\n" fmt @"\n----------END----------\n\n"), ##__VA_ARGS__);
#pragma mark - 日志输出 内含通知部分，可删除

#define WGLog(fmt, ...)          DDLogVerbose((@"\n----------BEGIN----------\n[类名:%@]\n" "[函数名:%s]\n" "[行号:%d]\n" fmt @"\n----------END----------"), NSStringFromClass(self.class), __FUNCTION__, __LINE__, ##__VA_ARGS__);

#define WGLogFuntion()           WGLog(@"");

#pragma mark - 系统尺寸

#define HAS_CURRENT_MODE(size)   [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(size, [[UIScreen mainScreen] currentMode].size) : NO

//判断iPhone5系列
#define IS_IPHONE_5              ([UIDevice platformStringSimple] containsString:@"iPhone 5"])

//判断iPHoneXR
#define IS_IPHONE_XR             ([UIDevice platformStringSimple] containsString:@"iPhone XR"])

//判断iPhoneXS
#define IS_IPHONE_XS             ([UIDevice platformStringSimple] isEqualToString:@"iPhone XS"])

//判断iPhoneXS Max
#define IS_IPHONE_XS_MAX         ([UIDevice platformStringSimple] containsString:@"iPhone XS Max"])

//判断iPhone12 mini
#define IS_IPHONE_12_MINI        ([UIDevice platformStringSimple] containsString:@"iPhone 12 mini"])

//判断iPhone12/12Pro
#define IS_IPHONE_12             ([UIDevice platformStringSimple] isEqualToString:@"iPhone 12"])

//判断iPhone12 Pro Max
#define IS_IPHONE_12_PRO_MAX     ([UIDevice platformStringSimple] isEqualToString:@"iPhone 12 Pro Max"])

//判断X系列
#define IS_IPHONE_X_SER          [UIDevice currentDevice].isIPhoneX

/// 状态栏高度
#define kNavTopBarHeight         (IS_IPHONE_X_SER ? 44.0f : 20.0f)
/// Nav高度
#define kNavBarHeight            (IS_IPHONE_X_SER ? 88.0f : 64.0f)
/// 屏幕底部弯曲的高度
#define kHomeIndicatorHeight     (IS_IPHONE_X_SER ? 34.0f : 0.0f)

#define kNavigationHeight        44

#define kTabBarHeight            (IS_IPHONE_X_SER ? 83 : 49)

#define kStatusBarHeight         [UIApplication sharedApplication].statusBarFrame.size.height

#define kContent_Height          (MAX(WGNumScreenHeight(),WGNumScreenWidth()) - kStatusBarHeight)

#define kNavigationBarHeight     (kStatusBarHeight + kNavigationHeight)

//除去状态栏、顶部导航条、底部tabbar高度，用于TabBar页面高度
#define kMainContentHeight       (kContent_Height-kNavigationHeight - kTabBarHeight)

//除去状态栏、顶部导航条高度，用于二级页面高度
#define kPageContentHeight       (kContent_Height-kNavigationHeight)

//高度比例缩放(宽度固定375.0)
#define kScaleSize(height)       (WGNumScreenWidth() / 375.0 * height)

#pragma mark - 字体
#define kFont(size)              [UIFont systemFontOfSize:size]
#define kFontSemibold(size)      [UIFont systemFontOfSize:size weight:UIFontWeightSemibold]
#define kFontLight(size)         [UIFont systemFontOfSize:size weight:UIFontWeightLight]
#define kFontBold(size)          [UIFont boldSystemFontOfSize:size]
#define kFontMedium(size)        [UIFont systemFontOfSize:size weight:UIFontWeightMedium]
#define kFontHeavy(size)         [UIFont systemFontOfSize:size weight:UIFontWeightHeavy]

#pragma mark - 颜色
#define WGHEXColor(string)       [UIColor wg_colorWithHexString:string]
#define WGHEXAlpha(string,alpha) [UIColor wg_colorWithHexString:string andAlpha:alpha]
#define WGRGBAlpha(r, g, b, a)   [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define WGRGBColor(r, g, b)      WGRGBAlpha(r,g,b,1.0)
#define WGGrayColor(v)           WGRGBColor(v,v,v)
#define WGRandomColor            WGRGBColor(arc4random()%255, arc4random()%255, arc4random()%255)

#pragma mark - 判空

//字符串是否为空
#define kIsEmptyString(str)                  ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
#define kIsEmptyStringIgnoreWhiteSpace(str)  ([str isKindOfClass:[NSNull class]] || str == nil || ([str isKindOfClass:[NSString class]] ? (([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) || ([str length] < 1 ? YES : NO) ) : YES))

//数组是否为空
#define kArrayIsEmpty(array)                 (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic)                    (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object)              (_object == nil || [_object isKindOfClass:[NSNull class]])

#pragma mark - URL
#define URL(string)  [NSURL URLWithString:string]


#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


#define IS_iPhoneX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size))\
:\
NO)

#define UIScreenFrame  [UIScreen mainScreen].bounds


//  适配比例
#define ADAPTATIONRATIO     kScreenW / 750.0f
#define kRefreshDuration   0.5f
#define kBaseHeaderHeight  kScreenW * 385.0f / 704.0f
#define kBaseSegmentHeight 40.0f



/***  屏宽比例 */
#define SCREEN_WIDTH_RATIO (SCREEN_WIDTH / 375)
#define kLineHeight (1 / [UIScreen mainScreen].scale)

//根据RGB值创建UIColor
#define RGBColorMake(R,G,B,_alpha_) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:_alpha_]


// 色彩
#define kColorRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kGrayColor kColorRGB(0x999999)
#define kLightGrayColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:249/255.0 alpha:1]
#define kOrangeColor kColorRGB(0xFF6B2A)
#define kLightOrangeColor kColorRGB(0xFFB797)
#define kBlueColor kColorRGB(0x0795E6)
#define kGreenColor kColorRGB(0x06BC5C)
#define kRedColor kColorRGB(0x0FE3A3A)
#define kMainTitleColor RGBColorMake(68, 44, 96, 1)
#define kMainTitleAlphaColor RGBColorMake(68, 44, 96, 0.5)

#define kiPhoneX ([UIScreen mainScreen].bounds.size.height == 812.00)

#define kAppVersion 1

#define kAlipay 1000
#define kWechat 2000




#pragma mark - 用户基本数据缓存

#define ZX_Token @"Token"
#define ZX_UserId @"UserId"
#define ZX_UserName @"UserName"
#define ZX_IsNew @"IsNew"
#define ZX_IsFristEntryBoxTips @"IsFristEntryBoxTips"
#define ZX_IsCloseExitNavTips @"IsCloseExitNavTips"
#define ZX_CheckupVersion @"CheckupVersion"
#define ZX_AdView @"ZX_AdView"


//取值
#define ZX_GetUserDefaults(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define kUserDefaultsToken [[NSUserDefaults standardUserDefaults] objectForKey:ZX_Token]
#define kUserDefaultsUserId [[NSUserDefaults standardUserDefaults] objectForKey:ZX_UserId]
#define kUserDefaultsUserName [[NSUserDefaults standardUserDefaults] objectForKey:ZX_UserName]
#define kUserDefaultsIsNew [[NSUserDefaults standardUserDefaults] objectForKey:ZX_IsNew]
#define kUserDefaultsIsFristEntryBoxTips [[NSUserDefaults standardUserDefaults] objectForKey:ZX_IsFristEntryBoxTips]
#define kUserDefaultsIsCloseExitNavTips [[NSUserDefaults standardUserDefaults] objectForKey:ZX_IsCloseExitNavTips]
#define kUserDefaultsCheckupVersion [[NSUserDefaults standardUserDefaults] objectForKey:ZX_CheckupVersion]


//设值
#define ZX_SetUserDefaults(key,object) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize];
#define ZX_SetUserDefaultsToken(token) [[NSUserDefaults standardUserDefaults] setObject:token forKey:ZX_Token]; [[NSUserDefaults standardUserDefaults] synchronize];
#define ZX_SetUserDefaultsUserId(userId) [[NSUserDefaults standardUserDefaults] setObject:userId forKey:ZX_UserId]; [[NSUserDefaults standardUserDefaults] synchronize];
#define ZX_SetUserDefaultsUserName(userName) [[NSUserDefaults standardUserDefaults] setObject:userName forKey:ZX_UserName]; [[NSUserDefaults standardUserDefaults] synchronize];
#define ZX_SetUserDefaultsIsNew(isNew) [[NSUserDefaults standardUserDefaults] setObject:isNew forKey:ZX_IsNew]; [[NSUserDefaults standardUserDefaults] synchronize];
#define ZX_SetUserDefaultsIsFristEntryBoxTips(isFristEntryBoxTips) [[NSUserDefaults standardUserDefaults] setObject:isFristEntryBoxTips forKey:ZX_IsFristEntryBoxTips]; [[NSUserDefaults standardUserDefaults] synchronize];
#define ZX_SetUserDefaultsIsCloseExitNavTips(isCloseExitNavTips) [[NSUserDefaults standardUserDefaults] setObject:isCloseExitNavTips forKey:ZX_IsCloseExitNavTips]; [[NSUserDefaults standardUserDefaults] synchronize];

#define ZX_SetUserDefaultsCheckupVersion(checkupVersion) [[NSUserDefaults standardUserDefaults] setObject:checkupVersion forKey:ZX_CheckupVersion]; [[NSUserDefaults standardUserDefaults] synchronize];


//删值
#define ZX_RemoveUserDefaults(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];



#pragma mark -

#endif /* WGMacro_h */


