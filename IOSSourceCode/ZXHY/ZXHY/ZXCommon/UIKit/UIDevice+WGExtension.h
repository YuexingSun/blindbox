//
//  UIDevice+WGExtension.h
//  WG_Common
//
//  Created by apple on 2021/5/10.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <sys/sysctl.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (WGExtension)

/// 直接获取到型号名，这个东西记得每年苹果发布新机的时候更新一次
+ (NSString *)platformStringSimple;

/// 判断是否有刘海
+ (BOOL)isIPhoneXSeries;

/// 是否有刘海，取内存缓存，取不到就取NSUserDefault
@property (nonatomic, assign) BOOL isIPhoneX;

@end

NS_ASSUME_NONNULL_END
