//
//  WGPushSheetController.m
//  Yunhuoyouxuan
//
//  Created by liaoqijin on 2021/4/15.
//  Copyright © 2021 apple. All rights reserved.
//

#import "WGPushSheetController.h"
#import "WGGeneralSheetController.h"

#import "NSNumber+WGExtension.h"
#import "UIView+WGExtension.h"
#import "NSArray+WGSafe.h"
#import "WGMacro.h"
#import "Masonry.h"

@interface WGPushSheetController ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *customView;

@property (nonatomic, assign) BOOL isResponseFrame;

@end

static CGFloat const duration = 0.2f;

static CGFloat const afterDelay = 0.1f;

@implementation WGPushSheetController

- (instancetype)initSheetControllerWithCustomView:(UIView *)customView{
    
    if(self = [super init]){
        _customView = customView;
        /**
         *  UIModalPresentationCustom present新的VC的时候
         *  会让旧视图控制器不执行viewDidDisappear
         *  因为present一个新的VC的时候，底部下的VC不会消失不见的，所以只有dissMiss才会执行viewDidDisappear
         *  但是如果使用UIModalPresentationFullScreen就不会影响什么周期，就和push一样
         */
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

+ (instancetype)sheetControllerWithCustomView:(UIView *)customView{
    
    WGPushSheetController *sheetVc = [[WGPushSheetController alloc] initSheetControllerWithCustomView:customView];
    return sheetVc;
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(wg_closePushSheetVcWithCustomView:)]){
        [self.delegate wg_closePushSheetVcWithCustomView:self.customView];
    }
    if (self.customView.superview) {
        [self.customView removeFromSuperview];
    }
}

- (void)dealloc{
    
    
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
        CGFloat customeViewX = WGNumScreenWidth();
        customFrame.origin.x = customeViewX;
        customFrame.origin.y = WGNumScreenHeight()-customFrame.size.height;
        _customView.frame = customFrame;
        
        [self performSelector:@selector(showFrameSheetVc) withObject:nil afterDelay:afterDelay inModes:@[NSRunLoopCommonModes]];
    }else{
        
        [_customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right).offset(WGNumScreenWidth());
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
        
        [self performSelector:@selector(showAutoSheetVc) withObject:nil afterDelay:afterDelay inModes:@[NSRunLoopCommonModes]];
    }
    
    if(self.isCanPanEdgeDragBack && self.isResponseFrame){
        [self wg_resetPanRecognizer];
    }
}

- (void)showFrameSheetVc{
    
    WEAKSELF
    [UIView animateWithDuration:duration animations:^{
        STRONGSELF
        
        if(self.sheetVcBackgroundColor){
            [self.view setBackgroundColor:self.sheetVcBackgroundColor];
        }else{
            [self.view setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
        }
        CGRect customFrame = self.customView.frame;
        customFrame.origin.x = 0;
        self.customView.frame = customFrame;
    }];
}

- (void)wg_resetPanRecognizer{
    
    if(!self.customView) return;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(contentPanAction:)];
    pan.delegate = self;
    [self.customView addGestureRecognizer:pan];
}

- (void)showAutoSheetVc{
    
    //告知需要更改约束
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:duration animations:^{
        [self->_customView mas_updateConstraints:^(MASConstraintMaker *make) {
            if(self.sheetVcBackgroundColor){
                [self.view setBackgroundColor:self.sheetVcBackgroundColor];
            }else{
                [self.view setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
            }
            make.right.mas_equalTo(self.view.mas_right);
        }];
        //告知父类控件绘制，不添加注释的这两行的代码无法生效
        [self->_customView.superview layoutIfNeeded];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    //获取点击点的坐标
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if(!CGRectContainsPoint(_customView.frame, touchPoint) && !self.presentedViewController){
        
        if(self.wg_beyondTouchDissmisAllVc){
            [WGPushSheetController dissmissCurrentAllSheetVcWithIsToBottom:YES animated:NO completion:nil];
        }else{
            [self dissmissSheetVc];
        }
    }
}

+ (void)dissmissCurrentAllSheetVcAnimated:(BOOL)animated completion:(void(^)(void))completion{
    
    [self dissmissCurrentAllSheetVcWithIsToBottom:NO animated:animated completion:completion];
}

+ (void)dissmissCurrentAllSheetVcWithIsToBottom:(BOOL)isToBottom
                                       animated:(BOOL)animated
                                     completion:(void(^)(void))completion{
    
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
                WGPushSheetController *sheetVc = (WGPushSheetController *)vc;
                if(isToBottom){
                    [sheetVc dissmisSheetVcToBottomAnimated:animated completion:completion];
                }else{
                    [sheetVc dissmisSheetVcAnimated:animated completion:Completion];
                }
            }else if([vc isKindOfClass:[WGGeneralSheetController class]]){
                WGGeneralSheetController *sheetVc = (WGGeneralSheetController *)vc;
                [sheetVc dissmisSheetVcCompletion:Completion];
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
                WGPushSheetController *sheetVc = (WGPushSheetController *)vc;
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

- (void)dissmisSheetVcToBottomAnimated:(BOOL)animated completion:(void(^)(void))completion{
    
    if(_isResponseFrame){
        
        CGRect customFrame = _customView.frame;
        customFrame.origin.y = WGNumScreenHeight();
        WEAKSELF
        [UIView animateWithDuration:duration animations:^{
            STRONGSELF
            
            self.view.backgroundColor = [UIColor clearColor];
            self.customView.frame = customFrame;
        } completion:^(BOOL finished) {
            STRONGSELF
            
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
            [self.customView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left);
                make.right.equalTo(self.view.mas_right);
                make.bottom.equalTo(self.view.mas_bottom).offset(WGNumScreenHeight());
            }];
            //告知父类控件绘制，不添加注释的这两行的代码无法生效
            [self.customView.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            STRONGSELF
            if (self.customView.superview) {
                [self.customView removeFromSuperview];
            }
            [self dismissViewControllerAnimated:animated completion:completion];
        }];
    }
}

- (void)dissmisSheetVcAnimated:(BOOL)animated completion:(void(^)(void))completion{
    
    if(_isResponseFrame){
        
        CGRect customFrame = _customView.frame;
        customFrame.origin.x = WGNumScreenWidth();
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
                make.right.mas_equalTo(self.view.mas_right).offset(WGNumScreenWidth());
            }];
            //告知父类控件绘制，不添加注释的这两行的代码无法生效
            [self.customView.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            STRONGSELF
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
        WGPushSheetController *currentPVc = (WGPushSheetController *)currentPresentVc;
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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        return YES;
    }
    
    CGFloat dw = [(UIPanGestureRecognizer *)gestureRecognizer locationInView:self.customView].x;
    //这里做好计算，只有左边边缘30个像素拖拽才有效果
    if(dw >= 0 && dw <= 30){
        return YES;
    }
    return NO;
    
}

#pragma mark - onClick
// 滑动手势
- (void)contentPanAction:(UIPanGestureRecognizer *)pan {
    
    CGFloat dw = [pan translationInView:self.customView].x;
    self.customView.left += dw;
    if (self.customView.left >= WGNumScreenWidth()) {
        
        self.customView.left = WGNumScreenWidth();
    }else if (self.customView.left <= 0) {
        
        self.customView.left = 0;
    }
    
    // 滑动结束
    if(pan.state == UIGestureRecognizerStateEnded){
        if (self.customView.left > WGNumScreenWidth()/2.0) {
            
            [self dissmisSheetVcCompletion:nil];
        }else {
            [self showFrameSheetVc];
        }
    }
    [pan setTranslation:CGPointZero inView:pan.view];
}

@end

































