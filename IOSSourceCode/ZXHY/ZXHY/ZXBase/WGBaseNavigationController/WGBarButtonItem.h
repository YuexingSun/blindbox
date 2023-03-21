//
//  WGBarButtonItem.h
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/9/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WGBarButtonItem : UIBarButtonItem

@property (nonatomic, copy) void(^tk_eventHandler)(void);

/**
 *  快速创建带图片和点击回调的UIBarButtonItem
 *
 *  @param imageName    图片名字
 *  @param eventHandler 点击回调事件
 *
 */
+ (instancetype)wg_blockedBarButtonItemWithImageName:(NSString *)imageName eventHandler:(void (^)(void))eventHandler;


/**
 *  快速创建带自定义view和点击回调的UIBarButtonItem
 *
 *  @param customView   自定义view对象
 *  @param eventHandler 点击回调事件
 *
 */
+ (instancetype)wg_blockedBarButtonItemWithCustomView:(UIView *)customView eventHandler:(void (^)(void))eventHandler;


- (void)tk_barButtonItemPressed:(id)sender;

@end
