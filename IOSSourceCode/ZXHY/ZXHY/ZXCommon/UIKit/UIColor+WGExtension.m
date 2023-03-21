//
//  UIColor+WGCaConstant.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import "UIColor+WGExtension.h"

CGFloat wg_colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

UIColor *WGClrCommonBackground(void)
{
    return [UIColor wg_colorWithHexString:@"#F0F0F0"];
}

UIColor *WGClrWhite(void)
{
    return [UIColor wg_colorWithHexString:@"#FFFFFF"];
}

UIColor *WGClrSecondTextBlack(void)
{
    return [UIColor wg_colorWithHexString:@"#999999"];
}

UIColor *WGClrMainBrand(void)
{
    return [UIColor wg_colorWithHexString:@"#FF435D"];
}

@implementation UIColor (WGCaConstant)

+ (UIColor *)wg_colorWithHexString:(NSString *)hexString
{
    CGFloat alpha, red, blue, green;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = wg_colorComponentFrom(colorString, 0, 1);
            green = wg_colorComponentFrom(colorString, 1, 1);
            blue  = wg_colorComponentFrom(colorString, 2, 1);
            break;
            
        case 4: // #ARGB
            alpha = wg_colorComponentFrom(colorString, 0, 1);
            red   = wg_colorComponentFrom(colorString, 1, 1);
            green = wg_colorComponentFrom(colorString, 2, 1);
            blue  = wg_colorComponentFrom(colorString, 3, 1);
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = wg_colorComponentFrom(colorString, 0, 2);
            green = wg_colorComponentFrom(colorString, 2, 2);
            blue  = wg_colorComponentFrom(colorString, 4, 2);
            break;
            
        case 8: // #AARRGGBB
            alpha = wg_colorComponentFrom(colorString, 0, 2);
            red   = wg_colorComponentFrom(colorString, 2, 2);
            green = wg_colorComponentFrom(colorString, 4, 2);
            blue  = wg_colorComponentFrom(colorString, 6, 2);
            break;
            
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)wg_colorWithHexString:(NSString *)hexString andAlpha:(CGFloat)alpha
{
    UIColor *color = [UIColor wg_colorWithHexString:hexString];
    return [color colorWithAlphaComponent:alpha];
}
@end
