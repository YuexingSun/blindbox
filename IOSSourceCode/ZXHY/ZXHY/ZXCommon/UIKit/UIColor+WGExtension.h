//
//  UIColor+WGCaConstant.h
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


UIColor *WGClrCommonBackground(void);

UIColor *WGClrWhite(void);

UIColor *WGClrTextBlack(void);

UIColor *WGClrSecondTextBlack(void);

UIColor *WGClrMainBrand(void);


@interface UIColor (WGExtension)

/// 十六进制颜色
/// @param hexString 十六进制字符串
+ (UIColor *)wg_colorWithHexString:(NSString *)hexString;

/// 十六进制颜色
/// @param hexString 十六进制字符串
/// @param alpha 透明度
+ (UIColor *)wg_colorWithHexString:(NSString *)hexString andAlpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
