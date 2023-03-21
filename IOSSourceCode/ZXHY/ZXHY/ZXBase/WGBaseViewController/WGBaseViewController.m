//
//  WGBaseViewController.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/7.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGBaseViewController.h"


@interface WGBaseViewController()

@end

@implementation WGBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self wg_addObserver];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self wg_initView];
    [self wg_initNavigation];
    self.showCustomerNavView = YES;
    self.navigationView.backgroundColor = [UIColor clearColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIView *view = [self seekLineImageViewOn:self.navigationController.navigationBar];
    view.hidden = YES;
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController &&
        ![self.navigationController.viewControllers containsObject:self])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)wg_initView
{
    [self.view setBackgroundColor:WGGrayColor(255)];
}

- (void)wg_initNavigation
{
    if (!self.navigationController.isNavigationBarHidden) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(wg_back)];
        [self.navigationItem setLeftBarButtonItem:item];
    }
}

- (void)wg_back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)wg_addObserver
{
    
}

- (void)wg_initTitleViewWithMainTitle:(NSString *)title {
    self.navigationItem.titleView = nil;
    self.navigationItem.title = [title length] > 0 ? title : nil;
}


- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%@ -------- DEALLOC",self.class);
#endif
}

#pragma mark

@end
