//
//  WGBaseViewController.h
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/7.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface WGBaseViewController : UIViewController

/// 初始化导航条（添加一个返回按钮）
- (void)wg_initNavigation;

/// 点击返回按钮的事件（单纯地pop一下）
- (void)wg_back;

/// 添加监听（内部无实现）
- (void)wg_addObserver;

/// 设置标题
- (void)wg_initTitleViewWithMainTitle:(NSString *)title;


@end

NS_ASSUME_NONNULL_END
