//
//  UIDevice+WGExtension.m
//  WG_Common
//
//  Created by apple on 2021/5/10.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import "UIDevice+WGExtension.h"
#import <objc/runtime.h>

static const void *wg_cacheIphoneModelKey = &wg_cacheIphoneModelKey;

static NSString *kIsIphoneXKey = @"kIsIphoneXKey";

@implementation UIDevice (WGExtension)

- (BOOL)isIPhoneX {
    NSNumber *isIPhoneX = objc_getAssociatedObject(self, wg_cacheIphoneModelKey);
    if (!isIPhoneX) {
        isIPhoneX = [[NSUserDefaults standardUserDefaults] objectForKey:kIsIphoneXKey];
        if (isIPhoneX) {
            objc_setAssociatedObject(self, wg_cacheIphoneModelKey, isIPhoneX, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    if (!isIPhoneX) {
        BOOL result = [UIDevice isIPhoneXSeries];
        objc_setAssociatedObject(self, wg_cacheIphoneModelKey, @(result), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSUserDefaults standardUserDefaults] setObject:@(result) forKey:kIsIphoneXKey];
        return result;
    } else {
        return [isIPhoneX boolValue];
    }
}

- (void)setIsIPhoneX:(BOOL)isIPhoneX {
    objc_setAssociatedObject(self, wg_cacheIphoneModelKey, @(isIPhoneX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)isIPhoneXSeries {
   
    UIUserInterfaceIdiom useInterfaceIdiom =[[UIDevice currentDevice] userInterfaceIdiom];
    
    if (useInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        if([[self platformStringSimple] containsString:@"iPhone X"] ||
           [[self platformStringSimple] containsString:@"iPhone 11"] ||
           [[self platformStringSimple] containsString:@"iPhone 12"]) {
            return YES;
        } else if (height >= 812) { // >= iPhone X
            return YES;
        } else {
            return ([[self platformStringSimple] containsString:@"Simulator"] &&
                    ([UIScreen mainScreen].bounds.size.height == 812.00 ||
                     [UIScreen mainScreen].bounds.size.width == 812.00 ||
                     [UIScreen mainScreen].bounds.size.height == 896.00 ||
                     [UIScreen mainScreen].bounds.size.height == 844.00 ||
                     [UIScreen mainScreen].bounds.size.width == 844.00 ||
                     [UIScreen mainScreen].bounds.size.height == 926.00 ||
                     [UIScreen mainScreen].bounds.size.width == 926.00
                     ));
        }
    }
    return NO;
}

+ (NSString *)platformStringSimple
{
    NSString *platformString = [self myPlatformString];
    
    NSRange range = [platformString rangeOfString:@"("];
    if (range.length)
        return [platformString substringToIndex:range.location - 1];
    
    return platformString;
}

+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    
    return platform;
}

+ (NSString *)myPlatformString
{
    NSString *platform = [self platform];
    
    NSDictionary *platformStrings = @{
#if !defined(TARGET_OS_IOS) || TARGET_OS_IOS
                                      @"iPhone1,1": @"iPhone 1G",
                                      @"iPhone1,2": @"iPhone 3G",
                                      @"iPhone2,1": @"iPhone 3GS",
                                      @"iPhone3,1": @"iPhone 4 (GSM)",
                                      @"iPhone3,2": @"iPhone 4 (GSM Rev A)",
                                      @"iPhone3,3": @"iPhone 4 (CDMA)",
                                      @"iPhone4,1": @"iPhone 4S",
                                      @"iPhone5,1": @"iPhone 5 (GSM)",
                                      @"iPhone5,2": @"iPhone 5 (GSM+CDMA)",
                                      @"iPhone5,3": @"iPhone 5C (GSM)",
                                      @"iPhone5,4": @"iPhone 5C (GSM+CDMA)",
                                      @"iPhone6,1": @"iPhone 5S (GSM)",
                                      @"iPhone6,2": @"iPhone 5S (GSM+CDMA)",
                                      @"iPhone7,1": @"iPhone 6 Plus",
                                      @"iPhone7,2": @"iPhone 6",
                                      @"iPhone8,1": @"iPhone 6s",
                                      @"iPhone8,2": @"iPhone 6s Plus",
                                      @"iPhone9,4": @"iPhone 7 Plus",
                                      @"iPhone9,2": @"iPhone 7 Plus",
                                      @"iPhone9,3": @"iPhone 7",
                                      @"iPhone9,1": @"iPhone 7",
                                      @"iPhone10,1" : @"iPhone 8",
                                      @"iPhone10,2" : @"iPhone 8 Plus",
                                      @"iPhone10,3" : @"iPhone X",
                                      @"iPhone10,4" : @"iPhone 8",
                                      @"iPhone10,5" : @"iPhone 8 Plus",
                                      @"iPhone10,6" : @"iPhone X",
                                      @"iPhone11,1" : @"iPhone XS",
                                      @"iPhone11,2" : @"iPhone XS",
                                      @"iPhone11,4" : @"iPhone XS Max",
                                      @"iPhone11,6" : @"iPhone XS Max",
                                      @"iPhone11,8" : @"iPhone XR",
                                      @"iPhone12,1" : @"iPhone 11",
                                      @"iPhone12,3" : @"iPhone 11 Pro",
                                      @"iPhone12,5" : @"iPhone 11 Pro Max",
                                      @"iPhone12,8" : @"iPhone SE 2",
                                      @"iPhone13,1" : @"iPhone 12 mini",
                                      @"iPhone13,2" : @"iPhone 12",
                                      @"iPhone13,3" : @"iPhone 12 Pro",
                                      @"iPhone13,4" : @"iPhone 12 Pro Max",
                                      @"iPhone8,4": @"iPhone SE",
                                      @"iPod1,1": @"iPod Touch 1G",
                                      @"iPod2,1": @"iPod Touch 2G",
                                      @"iPod3,1": @"iPod Touch 3G",
                                      @"iPod4,1": @"iPod Touch 4G",
                                      @"iPod5,1": @"iPod Touch 5G",
                                      @"iPod7,1": @"iPod Touch 6G",
                                      @"iPad1,1": @"iPad 1",
                                      @"iPad2,1": @"iPad 2 (WiFi)",
                                      @"iPad2,2": @"iPad 2 (GSM)",
                                      @"iPad2,3": @"iPad 2 (CDMA)",
                                      @"iPad2,4": @"iPad 2",
                                      @"iPad2,5": @"iPad Mini (WiFi)",
                                      @"iPad2,6": @"iPad Mini (GSM)",
                                      @"iPad2,7": @"iPad Mini (GSM+CDMA)",
                                      @"iPad3,1": @"iPad 3 (WiFi)",
                                      @"iPad3,2": @"iPad 3 (GSM+CDMA)",
                                      @"iPad3,3": @"iPad 3 (GSM)",
                                      @"iPad3,4": @"iPad 4 (WiFi)",
                                      @"iPad3,5": @"iPad 4 (GSM)",
                                      @"iPad3,6": @"iPad 4 (GSM+CDMA)",
                                      @"iPad4,1": @"iPad Air (WiFi)",
                                      @"iPad4,2": @"iPad Air (WiFi/Cellular)",
                                      @"iPad4,3": @"iPad Air (China)",
                                      @"iPad4,4": @"iPad Mini Retina (WiFi)",
                                      @"iPad4,5": @"iPad Mini Retina (WiFi/Cellular)",
                                      @"iPad4,6": @"iPad Mini Retina (China)",
                                      @"iPad4,7": @"iPad Mini 3 (WiFi)",
                                      @"iPad4,8": @"iPad Mini 3 (WiFi/Cellular)",
                                      @"iPad5,1": @"iPad Mini 4 (WiFi)",
                                      @"iPad5,2": @"iPad Mini 4 (WiFi/Cellular)",
                                      @"iPad5,3": @"iPad Air 2 (WiFi)",
                                      @"iPad5,4": @"iPad Air 2 (WiFi/Cellular)",
                                      @"iPad6,3": @"iPad Pro 9.7-inch (WiFi)",
                                      @"iPad6,4": @"iPad Pro 9.7-inch (WiFi/Cellular)",
                                      @"iPad6,7": @"iPad Pro 12.9-inch (WiFi)",
                                      @"iPad6,8": @"iPad Pro 12.9-inch (WiFi/Cellular)",
                                      @"iPad6,11": @"iPad 5 (WiFi)",
                                      @"iPad6,12": @"iPad 5 (WiFi/Cellular)",
                                      @"iPad7,1": @"iPad Pro 12.9-inch 2nd-gen (WiFi)",
                                      @"iPad7,2": @"iPad Pro 12.9-inch 2nd-gen (WiFi/Cellular)",
                                      @"iPad7,3": @"iPad Pro 10.5-inch (WiFi)",
                                      @"iPad7,4": @"iPad Pro 10.5-inch (WiFi/Cellular)",
#endif
#if TARGET_OS_TV
                                      @"AppleTV5,3": @"Apple TV 4G",
#endif
#if !defined(TARGET_OS_SIMULATOR) || TARGET_OS_SIMULATOR
                                      @"i386": @"Simulator",
                                      @"x86_64": @"Simulator",
#endif
                                      };
    
    return platformStrings[platform] ?: platform;
}

@end
