//
//  UIFont+WGCaConstant.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import "UIFont+WGExtension.h"

@implementation UIFont (WGExtension)

+ (UIFont *)wg_fontWithSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)wg_boldFontWithSize:(CGFloat)size
{
    return [UIFont boldSystemFontOfSize:size];
}


@end
