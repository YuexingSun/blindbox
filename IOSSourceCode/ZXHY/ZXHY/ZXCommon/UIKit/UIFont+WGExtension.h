//
//  UIFont+WGCaConstant.h
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (WGExtension)

/// 创建一个常规字体
/// @param size 字体大小
+ (UIFont *)wg_fontWithSize:(CGFloat)size;

/// 创建一个粗体字体
/// @param size 字体大小
+ (UIFont *)wg_boldFontWithSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
