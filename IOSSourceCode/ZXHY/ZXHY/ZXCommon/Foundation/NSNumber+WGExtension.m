//
//  NSNumber+WGExtension.m
//  WG_Common
//
//  Created by zhongzhifeng on 2021/4/29.
//

#import "NSNumber+WGExtension.h"

CGFloat WGNumScreenWidth(void)
{
    return MIN([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
}

CGFloat WGNumScreenHeight(void)
{
    return MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
}

CGFloat WGNumMainViewWidth(void)
{
    return WGNumScreenWidth();
}

CGFloat WGNumBrandModelCellHeight(void)
{
    return 64+44+32+(WGNumScreenWidth() -12*4 - 6*2)/3 + 12;
}

CGFloat WGNumGoodsDeatailBrandCellHeight(void)
{
    return (WGNumScreenWidth() - 12*4 - 2*6)/3 + 59;
}

CGFloat WGNumBrandEmptyModelCellHeight(void)
{
    return 64+44+12;
}

CGFloat WGHomeTypeHight(void)
{
    return ([[UIScreen mainScreen] bounds].size.width - 24 - 5*4)/5 *97/66;
}

CGFloat WGNumNavHeight(void)
{
    if (@available(iOS 11.0, *))
    {
        CGFloat top = [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
        if (top > 0)
        {
            return 44 + top;
        }
    }
    return 64;
}

CGFloat WGNumShoppingCartConfirmOrderCtrlBottomViewHeight(void)
{
    if (@available(iOS 11.0, *))
    {
        CGFloat top = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
        if (top > 0)
        {
            return 60 + top;
        }
    }
    return 60;
}

CGFloat WGNumSafeAreaTop(void)
{
    if (@available(iOS 11.0, *))
    {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
        
    }
    return 0;
}


@implementation NSNumber (WGExtension)

@end
