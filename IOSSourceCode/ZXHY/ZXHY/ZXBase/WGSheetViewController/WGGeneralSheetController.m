//
//  WGGeneralSheetController.m
//  Yunhuoyouxuan
//
//  Created by admin on 2020/11/10.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGGeneralSheetController.h"
#import "WGPushSheetController.h"

#import "NSNumber+WGExtension.h"
#import "UIView+WGExtension.h"
#import "NSArray+WGSafe.h"
#import "WGMacro.h"
#import "Masonry.h"

@interface WGGeneralSheetController ()

@property (nonatomic, weak) UIView *customView;

@property (nonatomic, assign) BOOL isResponseFrame;

@end

static CGFloat const duration = 0.3f;

static CGFloat const afterDelay = 0.1f;

@implementation WGGeneralSheetController

- (instancetype)initSheetControllerWithCustomView:(UIView *)customView{
    
    if(self = [super init]){
        _customView = customView;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

+ (instancetype)sheetControllerWithCustomView:(UIView *)customView{
    
    WGGeneralSheetController *sheetVc = [[WGGeneralSheetController alloc] initSheetControllerWithCustomView:customView];
    return sheetVc;
}

- (void)dealloc
{
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    if (!self.isNoRemove){
        if(self.delegate && [self.delegate respondsToSelector:@selector(wg_closeGeneralSheetVcWithCustomView:)]){
            [self.delegate wg_closeGeneralSheetVcWithCustomView:self.customView];
        }
        if (self.customView.superview) {
            [self.customView removeFromSuperview];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    CGFloat customeViewHeight = _customView.frame.size.height;
    CGRect customFrame = _customView.frame;
    [self.view addSubview:_customView];
    _customView.userInteractionEnabled = YES;
    
    if(customeViewHeight > 0){
        _isResponseFrame = YES;
        CGFloat customeViewY = WGNumScreenHeight();
        customFrame.origin.y = customeViewY;
        _customView.frame = customFrame;
                
        [self performSelector:@selector(showFrameSheetVc) withObject:nil afterDelay:afterDelay inModes:@[NSRunLoopCommonModes]];
    }else{
        
        [_customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(WGNumScreenHeight());
        }];
        
        [self performSelector:@selector(showAutoSheetVc) withObject:nil afterDelay:afterDelay inModes:@[NSRunLoopCommonModes]];
    }
    
}

- (void)showFrameSheetVc{
    
    CGFloat springTopMargin = 6;
    CGFloat customeViewHeight = _customView.frame.size.height;
    
    WEAKSELF
    [UIView animateWithDuration:duration animations:^{
        STRONGSELF
        
        [self.view setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
        CGRect customFrame = self.customView.frame;
        if(!self.removeSpringAnimation){
            customFrame.origin.y = WGNumScreenHeight()-customeViewHeight-springTopMargin;
        }else{
            customFrame.origin.y = WGNumScreenHeight()-customeViewHeight;
        }
        self.customView.frame = customFrame;
    } completion:^(BOOL finished) {
        STRONGSELF
        
        if(!self.removeSpringAnimation){
            [self addSpringAnimationWithSpringTopMargin:springTopMargin];
        }
    }];
}

- (void)addSpringAnimationWithSpringTopMargin:(CGFloat)springTopMargin{
    WEAKSELF
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        STRONGSELF
        
        self.customView.top += springTopMargin;
    } completion:nil];
}

- (void)showAutoSheetVc{
    
    //告知需要更改约束
    [self.view setNeedsUpdateConstraints];
    WEAKSELF
    [UIView animateWithDuration:duration animations:^{
        STRONGSELF
        [self.customView mas_updateConstraints:^(MASConstraintMaker *make) {
            [self.view setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
        //告知父类控件绘制，不添加注释的这两行的代码无法生效
        [self.customView.superview layoutIfNeeded];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    //获取点击点的坐标
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if(!CGRectContainsPoint(_customView.frame, touchPoint) && !self.presentedViewController){
        
        [self dissmissSheetVc];
    }
}

+ (void)dissmissCurrentAllSheetVcAnimated:(BOOL)animated completion:(void(^)(void))completion{
    
    UIViewController *topVc = [UIApplication sharedApplication].delegate.window.rootViewController;
    if(topVc.presentedViewController){
        NSMutableArray *vcArray = [NSMutableArray array];
        [self wg_getAllCurrentPresentVcWithVc:topVc.presentedViewController vcArray:vcArray];
        for(NSInteger i = vcArray.count-1 ; i >= 0 ; i--){
            UIViewController *vc = [vcArray wg_safeObjectAtIndex:i];
            void(^Completion)(void);
            if(i == 0){
                Completion = [completion copy];
            }
            if([vc isKindOfClass:[self class]]){
                WGGeneralSheetController *sheetVc = (WGGeneralSheetController *)vc;
                [sheetVc dissmisSheetVcAnimated:animated completion:Completion];
            }else if([vc isKindOfClass:[WGPushSheetController class]]){
                WGPushSheetController *sheetVc = (WGPushSheetController *)vc;
                [sheetVc dissmisSheetVcToBottomAnimated:animated completion:Completion];
            }else{
                [vc dismissViewControllerAnimated:animated completion:Completion];
            }
        }
        if(vcArray.count >= 3){
            [topVc.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        }
    }
}

+ (void)dissmissCurrentSheetVcWithCustomView:(UIView *)customView
                                    animated:(BOOL)animated
                                  completion:(void(^)(void))completion{
    if(!customView) return;
    UIViewController *topVc = [UIApplication sharedApplication].delegate.window.rootViewController;
    if(topVc.presentedViewController){
        NSMutableArray *vcArray = [NSMutableArray array];
        [self wg_getAllCurrentPresentVcWithVc:topVc.presentedViewController vcArray:vcArray];
        for(NSInteger i = vcArray.count-1 ; i >= 0 ; i--){
            UIViewController *vc = [vcArray wg_safeObjectAtIndex:i];
            if([vc isKindOfClass:[self class]]){
                WGGeneralSheetController *sheetVc = (WGGeneralSheetController *)vc;
                if([sheetVc.customView isEqual:customView]){
                    [sheetVc dissmisSheetVcAnimated:animated completion:completion];
                    return;
                }
            }
        }
    }
}

+ (void)wg_getAllCurrentPresentVcWithVc:(UIViewController *)vc vcArray:(NSMutableArray *)vcArray{
    
    if(!vc) return;
    [vcArray wg_safeAddObject:vc];
    if(vc.presentedViewController){
        [self wg_getAllCurrentPresentVcWithVc:vc.presentedViewController vcArray:vcArray];
    }
}

- (void)dissmissSheetVc{
    
    [self dissmisSheetVcAnimated:NO completion:nil];
}

- (void)dissmisSheetVcCompletion:(void(^)(void))completion{
    
    [self dissmisSheetVcAnimated:NO completion:completion];
}

- (void)dissmisSheetVcAnimated:(BOOL)animated completion:(void(^)(void))completion{
    
    if(_isResponseFrame){
        
        CGRect customFrame = _customView.frame;
        customFrame.origin.y = WGNumScreenHeight();
        WEAKSELF
        [UIView animateWithDuration:duration animations:^{
            STRONGSELF
            
            self.view.backgroundColor = [UIColor clearColor];
            self.customView.frame = customFrame;
        } completion:^(BOOL finished) {
            if (self.customView.superview) {
                [self.customView removeFromSuperview];
            }
            [self dismissViewControllerAnimated:animated completion:completion];
        }];
    }else{
        
        //告知需要更改约束
        [self.view setNeedsUpdateConstraints];
        WEAKSELF
        [UIView animateWithDuration:duration animations:^{
            STRONGSELF
            self.view.backgroundColor = [UIColor clearColor];
            [self.customView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(WGNumScreenHeight());
            }];
            //告知父类控件绘制，不添加注释的这两行的代码无法生效
            [self.customView.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (self.customView.superview) {
                [self.customView removeFromSuperview];
            }
            [self dismissViewControllerAnimated:animated completion:completion];
        }];
    }
}

- (void)showToCurrentVc{
    UIViewController *vc = [self wg_currentController];
    UIViewController *currentPresentVc = [self wg_getTopCurrentPresentVcWithVc:vc];
    if(currentPresentVc && ![currentPresentVc isEqual:self]){
        [currentPresentVc presentViewController:self animated:YES completion:nil];
        return;
    }
    if (![currentPresentVc isEqual:self]) {
        [vc presentViewController:self animated:YES completion:nil];
    }
}

- (void)showToCurrentVcOneWithShowViewClass:(Class)showViewClass{
    
    UIViewController *vc = [self wg_currentController];
    UIViewController *currentPresentVc = [self wg_getTopCurrentPresentVcWithVc:vc];
    if(currentPresentVc && [currentPresentVc isKindOfClass:[self class]]){
        WGGeneralSheetController *currentPVc = (WGGeneralSheetController *)currentPresentVc;
        if(showViewClass && currentPVc.customView && [currentPVc.customView isKindOfClass:showViewClass]){
            return;
        }
    }
    [self showToCurrentVc];
}

- (UIViewController *)wg_getTopCurrentPresentVcWithVc:(UIViewController *)vc{
    
    if(!vc.presentedViewController){
        return nil;
    }
    if(vc.presentedViewController.presentedViewController){
        return [self wg_getTopCurrentPresentVcWithVc:vc.presentedViewController];
    }else{
        return vc.presentedViewController;
    }
}

- (UIViewController *)wg_currentController
{
    UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)rootController;
        UIViewController *controller = [tabBarController.viewControllers wg_safeObjectAtIndex:tabBarController.selectedIndex];
        if ([controller isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *nav = (UINavigationController *)controller;
            return [nav.viewControllers lastObject];
        }
    }else if([rootController isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)rootController;
        return [nav.viewControllers lastObject];
    }else if([rootController isKindOfClass:[UIViewController class]]){
        return rootController;
    }
    return nil;
    
}

- (BOOL)wg_needGETUserShopLastBrowse
{
    return NO;
}

@end




























