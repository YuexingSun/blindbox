//
//  WGBarButtonItem.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/9/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGBarButtonItem.h"


@implementation WGBarButtonItem

- (void)tk_barButtonItemPressed:(id)sender
{
    if (_tk_eventHandler)
    {
        _tk_eventHandler();
    }
}

+ (instancetype)wg_blockedBarButtonItemWithImageName:(NSString *)imageName eventHandler:(void (^)(void))eventHandler
{
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    WGBarButtonItem *barButtonItem = [[WGBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:nil action:nil];
    //返回按钮图标设置偏左
    barButtonItem.imageInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    barButtonItem.target = barButtonItem;
    barButtonItem.action = @selector(tk_barButtonItemPressed:);
    barButtonItem.tk_eventHandler = eventHandler;
    return barButtonItem;
}

+ (instancetype)wg_blockedBarButtonItemWithCustomView:(UIView *)customView eventHandler:(void (^)(void))eventHandler
{
    WGBarButtonItem *barButtonItem = [[WGBarButtonItem alloc] initWithCustomView:customView];
    barButtonItem.target = barButtonItem;
    barButtonItem.action = @selector(tk_barButtonItemPressed:);
    barButtonItem.tk_eventHandler = eventHandler;
    return barButtonItem;
}

@end
