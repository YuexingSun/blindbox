//
//  WGUIManager.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/10.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGUIManager.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "WGBaseNavigationController.h"
#import <Lottie/Lottie.h>

@interface WGUIManager()
@property (nonatomic, strong) MBProgressHUD *wg_progressHUD;
@property (nonatomic, strong) UILabel *wg_progressHUDLabel;
@property (nonatomic, strong) LOTAnimationView *wg_progressHUDImageView;
@property (nonatomic, strong) UIView *loadingBgView;
@property (nonatomic, strong) UIView *progressImageContentView;

@property (nonatomic, strong) UIView *errorContentView;
@property (nonatomic, strong) UIImageView *errorImageView;
@property (nonatomic, strong) UILabel *errorLabel;

@end

@implementation WGUIManager

+ (instancetype)wg_sharedManager
{
    static WGUIManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)wg_reset{
    
    if (_wg_progressHUD.superview) {
        [_wg_progressHUD removeFromSuperview];
    }
    _wg_progressHUD = nil;
}

+ (UIWindow *)wg_window
{
    return [AppDelegate wg_sharedDelegate].window;
}

- (MBProgressHUD *)wg_progressHUD
{
    if (!_wg_progressHUD)
    {
        UIWindow *window;
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *eachWindow in windows)
        {
            if ([eachWindow isKeyWindow])
            {
                window = eachWindow;
            }
        }
        MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:window];
        progressHUD.detailsLabel.font = [UIFont wg_boldFontWithSize:16];
        [window addSubview:progressHUD];
        //[progressHUD showAnimated:YES];
        //progressHUD.removeFromSuperViewOnHide = YES;
        _wg_progressHUD = progressHUD;
    }
    [WGUIManager checkOtherView];
    return _wg_progressHUD;
}

- (UILabel *)wg_progressHUDLabel
{
    if (!_wg_progressHUDLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont wg_fontWithSize:14.0];
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
//        label.backgroundColor = [UIColor blackColor];
//        label.layer.cornerRadius = 20.0;
//        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        _wg_progressHUDLabel = label;
    }
    return _wg_progressHUDLabel;
}

- (UIView *)progressImageContentView
{
    if (!_progressImageContentView) {
        _progressImageContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 84.0, 84.0)];
        _progressImageContentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _progressImageContentView.layer.cornerRadius = 16.0;
        
        CALayer *subLayer = _progressImageContentView.layer;
        subLayer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
        subLayer.shadowOffset = CGSizeMake(0, 0);
        subLayer.shadowOpacity = 1.0;
        subLayer.shadowRadius = 16.0;
        
        [_progressImageContentView addSubview:self.wg_progressHUDImageView];
        self.wg_progressHUDImageView.center = CGPointMake(_progressImageContentView.width / 2, _progressImageContentView.height / 2);
    }
    return _progressImageContentView;
}

- (LOTAnimationView *)wg_progressHUDImageView
{
    if (!_wg_progressHUDImageView) {
        LOTAnimationView *imageV = [LOTAnimationView animationNamed:@"pulltorefresh-white"];
//                                    @"modal-loading"];
        imageV.frame = CGRectMake(0, 0, 60.0, 60.0);
        imageV.loopAnimation = YES;
//        loadingView.contentMode = UIViewContentModeScaleAspectFill;
        _wg_progressHUDImageView = imageV;
    }
    return _wg_progressHUDImageView;
}
//
//- (UIImageView *)wg_progressHUDImageView
//{
//    if (!_wg_progressHUDImageView) {
//        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(16.0, 16.0, 48.0, 48.0)];
//        NSMutableArray<UIImage*>* imgs = [NSMutableArray<UIImage*> arrayWithCapacity:10];
//       for (NSInteger i = 0; i < 10; i++) {
//           [imgs wg_safeAddObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_whale_%ld", i + 1]]];
//        }
//        imageV.animationDuration = 0.5;
//        imageV.animationImages = imgs;
//        imageV.contentMode = UIViewContentModeCenter;
//        _wg_progressHUDImageView = imageV;
//    }
//    return _wg_progressHUDImageView;
//}

- (UIView *)errorContentView
{
    if (!_errorContentView) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200.0, 97.0)];
        
        UIImageView *errorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80.0, 16.0, 40.0, 40.0)];
        errorImageView.image = [UIImage wg_imageNamed:@"wg_networkerror_default"];
        [contentView addSubview:errorImageView];
        self.errorImageView = errorImageView;
        
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, CGRectGetMaxY(errorImageView.frame) + 5.0, 168.0, 20.0)];
        errorLabel.text = @"网络不给力，请检查您的网络";
        errorLabel.numberOfLines = 0;
        errorLabel.font = [UIFont wg_fontWithSize:14.0];
        errorLabel.textColor = [UIColor whiteColor];
        errorLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:errorLabel];
        self.errorLabel = errorLabel;
        
        _errorContentView = contentView;
    }
    return _errorContentView;
}

- (UIView *)loadingBgView
{
    if (!_loadingBgView) {
        _loadingBgView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, WGNumScreenWidth(), WGNumScreenHeight() - kNavBarHeight)];
//        _loadingBgView.backgroundColor = [UIColor whiteColor];
    }
    
    if ([WGUIManager wg_currentTabBarController] && [WGUIManager wg_currentIndexNavController].viewControllers.count == 1) {
        _loadingBgView.frame = CGRectMake(0, kNavBarHeight, WGNumScreenWidth(), WGNumScreenHeight() - kNavBarHeight - kTabBarHeight);
    } else {
        _loadingBgView.frame = CGRectMake(0, kNavBarHeight, WGNumScreenWidth(), WGNumScreenHeight() - kNavBarHeight);
    }
    
    return _loadingBgView;
}


- (UIView *)getErrorContentViewWithText:(NSString *)text imageName:(NSString *)imageName
{
    UIView *contentView = [WGUIManager wg_sharedManager].errorContentView;
    if ([text length])
    {
        CGFloat labelLeftGap = 16.0;
        UILabel *label = [WGUIManager wg_sharedManager].errorLabel;
        label.text = text;
        CGRect rect = [text boundingRectWithSize:CGSizeMake(WGNumScreenWidth() - labelLeftGap * 2 - labelLeftGap * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil];
        
        CGFloat maxHeight = 20.0;
        if (rect.size.height > maxHeight) {
            maxHeight = rect.size.height;
        }
        
        CGFloat labelWidth = rect.size.width + 1;
        
        CGRect labelFrame = label.frame;
        labelFrame.size = CGSizeMake(labelWidth, maxHeight);
        label.frame = labelFrame;
        
        CGRect contentFrame = contentView.frame;
        contentFrame.size.width = labelWidth + labelLeftGap * 2;
        contentFrame.size.height = 97.0 + (maxHeight - 20.0);
        contentView.frame = contentFrame;
        
        UIImageView *imageView = [WGUIManager wg_sharedManager].errorImageView;
        CGRect imageFrame = imageView.frame;
        imageFrame.origin.x = (contentFrame.size.width - imageFrame.size.width)*0.5;
        imageView.frame = imageFrame;
    }
    
    if (imageName.length) {
        self.errorImageView.image = [UIImage wg_imageNamed:imageName];
    }
    
    return contentView;
}

#pragma mark -
+ (void)wg_showHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *progressHUD = [WGUIManager wg_sharedManager].wg_progressHUD;
        
        if (!progressHUD.superview)
        {
            [[UIApplication sharedApplication].keyWindow addSubview:progressHUD];
        }
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:progressHUD];
        
        progressHUD.bezelView.translatesAutoresizingMaskIntoConstraints = YES;
        progressHUD.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        progressHUD.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.f];
        progressHUD.userInteractionEnabled = NO;
        progressHUD.bezelView.layer.masksToBounds = NO;
        
        UIView *bgView = [WGUIManager wg_sharedManager].loadingBgView;
        [progressHUD.backgroundView insertSubview:bgView atIndex:0];
        progressHUD.userInteractionEnabled = NO;
        
        UIView *contentView = [WGUIManager wg_sharedManager].progressImageContentView;
        LOTAnimationView *imageV = [WGUIManager wg_sharedManager].wg_progressHUDImageView;
        [imageV play];

        CGRect frame = progressHUD.bezelView.frame;
        frame.size = contentView.frame.size;
        frame.origin.x = ([UIScreen mainScreen].bounds.size.width - frame.size.width) * 0.5;
        progressHUD.bezelView.backgroundColor = [UIColor clearColor];
        [progressHUD.bezelView addSubview:contentView];
        progressHUD.bezelView.frame = frame;
        progressHUD.mode = MBProgressHUDModeCustomView;
        progressHUD.customView = nil;
        progressHUD.bezelView.center = progressHUD.center;

        
        [progressHUD showAnimated:YES];

    });
    
}

+ (void)wg_hideHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[WGUIManager wg_sharedManager].wg_progressHUD hideAnimated:YES];
        [[WGUIManager wg_sharedManager].wg_progressHUDImageView stop];
    });
    
}

+ (void)checkOtherView
{
    if ([WGUIManager wg_sharedManager].progressImageContentView.superview) {
        [[WGUIManager wg_sharedManager].progressImageContentView removeFromSuperview];
    }
    if ([WGUIManager wg_sharedManager].loadingBgView.superview) {
        [[WGUIManager wg_sharedManager].loadingBgView removeFromSuperview];
    }
    if ([WGUIManager wg_sharedManager].errorContentView.superview) {
        [[WGUIManager wg_sharedManager].errorContentView removeFromSuperview];
    }
    if ([WGUIManager wg_sharedManager].wg_progressHUDLabel.superview) {
        [[WGUIManager wg_sharedManager].wg_progressHUDLabel removeFromSuperview];
    }
}

+ (void)wg_hideHUDAfterDelay:(NSTimeInterval)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[WGUIManager wg_sharedManager].wg_progressHUD hideAnimated:YES afterDelay:0.2];
    });
    
}

+ (void)wg_hideHUDOperationSucceed
{
    [self wg_hideHUDWithText:WGLocalizedString(@"操作成功")];
}

+ (void)wg_hideHUDNetWorkError
{
    [self wg_hideHUDNetWorkErrorWithText:@"网络不给力，请检查您的网络" imageName:@"wg_networkerror_default"];
}

+ (void)wg_hideHUDNetWorkErrorWithText:(NSString *)text imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *progressHUD = [WGUIManager wg_sharedManager].wg_progressHUD;
        if (!progressHUD.superview)
        {
            [[UIApplication sharedApplication].keyWindow addSubview:progressHUD];
        }
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:progressHUD];
        
        progressHUD.bezelView.translatesAutoresizingMaskIntoConstraints = YES;
        progressHUD.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        progressHUD.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.f];
        progressHUD.userInteractionEnabled = NO;
        progressHUD.bezelView.layer.masksToBounds = NO;
        
        
        progressHUD.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        progressHUD.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.f];
        progressHUD.userInteractionEnabled = NO;
        progressHUD.bezelView.layer.masksToBounds = NO;
        
        UIView *contentView = [WGUIManager wg_sharedManager].errorContentView;
        
        [[WGUIManager wg_sharedManager] getErrorContentViewWithText:text imageName:imageName];
        
        CGRect frame = progressHUD.bezelView.frame;
        frame.size = contentView.frame.size;
        frame.origin.x = (WGNumScreenWidth() - frame.size.width) * 0.5;
        frame.origin.y = (WGNumScreenHeight() - frame.size.height) * 0.5;
        progressHUD.bezelView.frame = frame;
        progressHUD.bezelView.backgroundColor = [UIColor blackColor];
        progressHUD.bezelView.layer.cornerRadius = 20.0;
        progressHUD.bezelView.layer.masksToBounds = YES;
        [progressHUD.bezelView addSubview:contentView];
        progressHUD.mode = MBProgressHUDModeCustomView;
//        progressHUD.customView = nil;
        
        [progressHUD showAnimated:YES];
        [progressHUD hideAnimated:YES afterDelay:1.5];
    });
}

+ (void)wg_hideHUDWithText:(NSString *)text
{
    [WGUIManager wg_hideHUDWithText:text afterDelay:1.0];
}

+ (void)wg_hideHUDWithText:(NSString *)text afterDelay:(NSTimeInterval)delay
{
    if ([text isEqualToString:WGLocalizedString(@"网络不好")]) {
        [self wg_hideHUDNetWorkError];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *progressHUD = [WGUIManager wg_sharedManager].wg_progressHUD;
        if (!progressHUD.superview)
        {
            [[UIApplication sharedApplication].keyWindow addSubview:progressHUD];
        }
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:progressHUD];
        
        progressHUD.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        progressHUD.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.f];
        progressHUD.userInteractionEnabled = NO;
        progressHUD.bezelView.layer.masksToBounds = NO;
        
        progressHUD.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        progressHUD.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.f];
        progressHUD.userInteractionEnabled = NO;
        progressHUD.bezelView.layer.masksToBounds = NO;
        
        if ([text length])
        {
            CGFloat labelLeftGap = 16.0;
            CGFloat labelLeftTop = 10.0;
            UILabel *label = [WGUIManager wg_sharedManager].wg_progressHUDLabel;
            label.text = text;
            CGRect rect = [text boundingRectWithSize:CGSizeMake(WGNumScreenWidth() - labelLeftGap * 2 - labelLeftGap * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil];
            
            CGFloat maxHeight = 40.0;
            if (rect.size.height + labelLeftTop * 2 > 40.0) {
                maxHeight = rect.size.height + labelLeftTop * 2;
            }
            
            CGFloat labelWidth = rect.size.width+labelLeftGap * 2;
            progressHUD.minSize = CGSizeMake(labelWidth, maxHeight);
            
            CGRect frame = progressHUD.bezelView.frame;
            frame.size = CGSizeMake(labelWidth, maxHeight);
            frame.origin.x = (WGNumScreenWidth() - labelWidth) * 0.5;
            progressHUD.bezelView.frame = frame;
            progressHUD.bezelView.backgroundColor = [UIColor blackColor];
            progressHUD.bezelView.layer.cornerRadius = 20.0;
            progressHUD.bezelView.layer.masksToBounds = YES;
            
            label.frame = CGRectMake(labelLeftGap, labelLeftTop, rect.size.width , rect.size.height);
            [progressHUD.bezelView addSubview:label];
            
            progressHUD.mode = MBProgressHUDModeCustomView;
            progressHUD.customView = nil;
        }
        
        [progressHUD showAnimated:YES];
        [progressHUD hideAnimated:YES afterDelay:delay];
    });
}

+ (void)wg_showLoadFailWithBtnClickBlock:(void(^)(UIButton *button))block
{
    [WGUIManager wg_showLoadFailWithFrame:CGRectMake(0, kNavBarHeight, WGNumScreenWidth(), WGNumScreenHeight() - kNavBarHeight) btnClickBlock:block];
}

//TODO: 修复
//+ (WGBaseTabBarController *)wg_currentTabBarController{
//    UIViewController *rootController = [AppDelegate wg_sharedDelegate].tabBarController;
//    if ([rootController isKindOfClass:[UITabBarController class]])
//    {
//        return (WGBaseTabBarController *)rootController;
//    }
//    return nil;
//}

+ (ZXBaseTabBarController *)wg_currentTabBarController{
    UIViewController *rootController = [AppDelegate wg_sharedDelegate].tabBarController;
    if ([rootController isKindOfClass:[UITabBarController class]])
    {
        return (ZXBaseTabBarController *)rootController;
    }
    return nil;
}

+ (WGBaseNavigationController *)wg_currentIndexNavController
{
    UIViewController *rootController = [AppDelegate wg_sharedDelegate].tabBarController;
    if ([rootController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)rootController;
        UIViewController *controller = [tabBarController.viewControllers wg_safeObjectAtIndex:tabBarController.selectedIndex];
        if ([controller isKindOfClass:[WGBaseNavigationController class]])
        {
            return (WGBaseNavigationController *)controller;
        }
    }
    
    return nil;
    
}

+ (UIViewController *)wg_topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil)
    {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self wg_topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self wg_topViewController:presentedViewController];
}

+ (UIViewController *)wg_topViewController
{
    return [self wg_topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)wg_currentIndexNavTopController
{
    return [self wg_currentIndexNavController].topViewController;
}


+ (void)wg_switchRootController:(UIViewController *)controller{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if([appDelegate.window.rootViewController isKindOfClass:[controller class]]){
        return;
    }
    appDelegate.window.rootViewController = controller;
}

@end
