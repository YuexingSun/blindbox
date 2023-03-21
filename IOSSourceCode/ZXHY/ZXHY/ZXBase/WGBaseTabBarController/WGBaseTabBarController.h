//
//  WGBaseTabBarController.h
//  Yunhuoyouxuan
//
//  Created by Bern on 2021/4/28.
//  Copyright © 2021 apple. All rights reserved.
//

/*
 
 使用该Controller需要到WGBaseNavigationController添加代理
 每次使用popToRootViewControllerAnimated方法时都需重新删除系统Tabbar自带的TabbarButton
 
 弃用该Controller也需要取消代理
 
 **/


#import <UIKit/UIKit.h>
#import "WGTabBarModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface WGBaseTabBarController : UITabBarController

//跳转到指定页
- (void)changeToSelectedIndex:(WGTabBarType)selectedIndex;

//
- (void)zx_reqApiCheckBeingBox;

@end

NS_ASSUME_NONNULL_END
