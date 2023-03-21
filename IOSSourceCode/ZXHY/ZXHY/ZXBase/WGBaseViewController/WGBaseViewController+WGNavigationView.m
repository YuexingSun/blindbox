//
//  UIViewController+WGNavigationView.m
//  WG_Common
//
//  Created by apple on 2021/6/2.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.

#import "WGBaseViewController+WGNavigationView.h"
#import <objc/runtime.h>

#import "UIDevice+WGExtension.h"
#import "NSNumber+WGExtension.h"
#import "WGMacro.h"

@implementation WGBaseViewController (WGNavigationView)

#pragma mark - override 重写父类方法

/// 注意，在分类中重写方法，意味着原来的方r法没机会被调用了
/// 理由是：分类是在运行时加载把方法（目前只讨论成员方法）合并到类对象的，如果有多个分类的话，那么晚编译的分类内的方法会安排在类对象的方法列表的前面（按编译顺序倒序插入），所以如果重写的方法的话，原来的类的成员方法就再也没办法进入了，除非说Podfile内不要引入该分类
/// 跟是否import了这个分类没关系，分类编译时就会影响到类对象的成员方法列表的
/// 但是load方法不一样，load方法是runtime通过IMP指针直接调用的（系统会维护一个load结构体数组，结构体内存储类的load方法的IMP指针），不走消息转发机制，也就是说load方法在主类和每个分类都会走（主类先走，如果主类有父类，那么主类的父类的load方法先走）

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.showCustomerNavView) {
        [self.navigationController setNavigationBarHidden:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO];
        UIView *view = [self seekLineImageViewOn:self.navigationController.navigationBar];
        view.hidden = YES;
    }
    
    
}

//隐藏下划线
- (UIImageView *)seekLineImageViewOn:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) return (UIImageView *)view;
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self seekLineImageViewOn:subview];
        if (imageView) return imageView;
    }
    return nil;
}

- (void)wg_initNavigation
{
    if (!self.showCustomerNavView) {
        [self.navigationItem setLeftBarButtonItem:self.wg_backBarButtonItem];
    } else {
        [self.navigationController setToolbarHidden:YES animated:NO];
        if (!self.navigationView.superview) {
            [self.view addSubview:self.navigationView];
        } else {
            [self.view bringSubviewToFront:self.navigationView];
        }
    }
}

- (void)wg_back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setter & getter

- (NSString *)wg_mainTitle {
    NSString *_wg_mainTitle = objc_getAssociatedObject(self, @selector(wg_mainTitle));
    return _wg_mainTitle;
}

- (void)setWg_mainTitle:(NSString *)wg_mainTitle
{
    if (self.showCustomerNavView) {
        [self.navigationView wg_setTitle:wg_mainTitle];
    } else {
        [self wg_initTitleViewWithMainTitle:wg_mainTitle];
    }
    objc_setAssociatedObject(self, @selector(wg_mainTitle), wg_mainTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (WGNavigationView *)navigationView {
    WGNavigationView *_navigationView = objc_getAssociatedObject(self, @selector(navigationView));
    if (!_navigationView) {
        _navigationView = [[WGNavigationView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), kNavBarHeight)];
        _navigationView.delegate = self;
        objc_setAssociatedObject(self, @selector(navigationView), _navigationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _navigationView;
}

- (void)setNavigationView:(WGNavigationView *)navigationView {
    objc_setAssociatedObject(self, @selector(navigationView), navigationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)showCustomerNavView {
    NSNumber *_show = objc_getAssociatedObject(self, @selector(showCustomerNavView));
    if (!_show) {
        _show = @NO;
        objc_setAssociatedObject(self, @selector(showCustomerNavView), _show, OBJC_ASSOCIATION_ASSIGN);
    }
    return [_show boolValue];
}

- (void)setShowCustomerNavView:(BOOL)showCustomerNavView
{
    objc_setAssociatedObject(self, @selector(showCustomerNavView), @(showCustomerNavView), OBJC_ASSOCIATION_ASSIGN);
    if (showCustomerNavView) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        if (!self.navigationView.superview) {
            [self.view addSubview:self.navigationView];
        } else {
            [self.view bringSubviewToFront:self.navigationView];
        }
    }
}

- (WGBarButtonItem *)wg_backBarButtonItem {
    WGBarButtonItem *_wg_backBarButtonItem = objc_getAssociatedObject(self, @selector(wg_backBarButtonItem));
    if (!_wg_backBarButtonItem) {
        WEAKSELF
        _wg_backBarButtonItem = [WGBarButtonItem wg_blockedBarButtonItemWithImageName:@"icon_nav_back" eventHandler:^{
            STRONGSELF;
            [self wg_back];
        }];
        objc_setAssociatedObject(self, @selector(wg_backBarButtonItem), _wg_backBarButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _wg_backBarButtonItem;
}

- (void)setWg_backBarButtonItem:(WGBarButtonItem *)wg_backBarButtonItem {
    objc_setAssociatedObject(self, @selector(wg_backBarButtonItem), wg_backBarButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - WGNavigationViewDelegate

- (void)navigationViewBackBtnClick:(WGNavigationView *)navigationView
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
