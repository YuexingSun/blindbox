//
//  WGGeneralAlertController.m
//  Yunhuoyouxuan
//
//  Created by admin on 2020/11/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGGeneralAlertController.h"

#import "UIView+WGExtension.h"
#import "UIColor+WGExtension.h"
#import "NSArray+WGSafe.h"
#import "NSString+WGExtension.h"
#import "NSNumber+WGExtension.h"
#import "WGColorConst.h"


@interface WGGeneralAlertController ()

@property (nonatomic, assign) BOOL firstDisplay;

@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, copy) NSString *subTitleStr;

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, copy) NSString *messageStr;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, copy) void(^submitHandler)(NSInteger count);

@property (nonatomic, copy) void(^cancelHandler)(void);

@property (nonatomic, weak) UIView *customView;

@end

@implementation WGGeneralAlertController

@synthesize cancelBtn = _cancelBtn;
@synthesize submitBtn = _submitBtn;
@synthesize closeBtn = _closeBtn;

- (instancetype)initWithCustomView:(UIView *)customView{
    
    if(self = [super init]){
        _customView = customView;
        _firstDisplay = YES;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

+ (instancetype)alertControllerWithCustomView:(UIView *)customView{

    return [[WGGeneralAlertController alloc] initWithCustomView:customView];
}

- (instancetype)initWithTitleStr:(NSString *)titleStr
                     subTitleStr:(NSString *)subTitleStr
                      messageStr:(NSString *)messageStr{
    
    if(self = [super init]){
        
        _firstDisplay = YES;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _titleStr = titleStr;
        _subTitleStr = subTitleStr;
        _messageStr = messageStr;
        [self wg_initView];
    }
    return self;
}

+ (instancetype)alertControllerWithTitleStr:(NSString *)titleStr
                                subTitleStr:(NSString *)subTitleStr
                                 messageStr:(NSString *)messageStr{
    
    WGGeneralAlertController *alertVc = [[WGGeneralAlertController alloc] initWithTitleStr:titleStr subTitleStr:subTitleStr messageStr:messageStr];
    
    return alertVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];

//    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeBtn.backgroundColor = UIColor.clearColor;
//    closeBtn.frame = CGRectMake(0 , 0, WGNumScreenWidth(), WGNumScreenHeight());
//    [closeBtn addTarget:self action:@selector(closeBtClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:closeBtn];
    
    if(self.customView){
        [self.view addSubview:self.customView];
        
        if(_customView.width == 0 || _customView.height == 0){
            _customView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
            }];
        }else{

            self.customView.center = self.view.center;
        }

    }
    
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    /** 显示弹出动画 */
    [self showAppearAnimation];
}

- (void)showAppearAnimation
{
    if (!_firstDisplay) return;
    
    _firstDisplay = NO;
    
    if(self.customView){
        
        self.customView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.customView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }else if(self.alertView){
        
        self.alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alertView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
    
    
}

- (void)wg_initView{
    
    CGFloat alertWhRate = 320/260;
    CGFloat alertWidth = [self getAlertWidth];
    CGFloat alertHeight = 260;
    if(WGNumScreenWidth() <= 320){
        alertHeight = alertWidth/alertWhRate;
    }
    CGFloat alertX = (WGNumScreenWidth()-alertWidth)/2.0;
    _alertView = [[UIView alloc] initWithFrame:CGRectMake(alertX, 0, alertWidth, alertHeight)];
    CGPoint alertCenter = _alertView.center;
    alertCenter.y = self.view.center.y;
    _alertView.center = alertCenter;
    [self.view addSubview:_alertView];
    _alertView.backgroundColor = [UIColor whiteColor];
    _alertView.layer.cornerRadius = 16.f;
    _alertView.userInteractionEnabled = YES;
    _alertView.clipsToBounds = YES;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
    CGFloat closeBtnH = 35;
    CGFloat closeBtnW = 40;
    CGFloat closeBtnX = alertWidth - closeBtnW;
    CGFloat closeBtnY = 0;
    closeBtn.frame = CGRectMake(closeBtnX, closeBtnY, closeBtnW, closeBtnH);
    [closeBtn addTarget:self action:@selector(closeBtClick:) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn = closeBtn;
    [_alertView addSubview:closeBtn];
    
    CGFloat titleHeight = 0.f;
    CGFloat titleX = 24.f;
    CGFloat titleY = 24.f+5;
    CGFloat titleWidth = alertWidth-titleX*2;
    UIFont *titleFont = [UIFont boldSystemFontOfSize:17];
    if(!kIsEmptyStringIgnoreWhiteSpace(self.titleStr)){
        titleHeight = [self.titleStr heightOfStringFont:titleFont width:titleWidth]+1;
    }
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleWidth, titleHeight)];
    self.titleLabel.text = self.titleStr;
    self.titleLabel.textColor = [UIColor wg_colorWithHexString:@"#3C3C3C"];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = titleFont;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_alertView addSubview:self.titleLabel];
    
    CGFloat subTitleLabelY = 24.f;
    CGFloat subTitleHeight = 0.f;
    CGFloat subTitleX = 24.f;
    CGFloat subTitleWidth = alertWidth-subTitleX*2;
    UIFont *subTitleFont = [UIFont systemFontOfSize:13];
    if(!kIsEmptyStringIgnoreWhiteSpace(self.titleStr)){
        subTitleLabelY = self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+12;
    }
    if(!kIsEmptyStringIgnoreWhiteSpace(self.subTitleStr)){
        subTitleHeight = [self.subTitleStr heightOfStringFont:subTitleFont width:subTitleWidth]+1;
    }
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subTitleX, subTitleLabelY, subTitleWidth, subTitleHeight)];
    self.subTitleLabel.text = self.subTitleStr;
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.textColor = [UIColor wg_colorWithHexString:@"#3C3C3C"];
    self.subTitleLabel.font = subTitleFont;
    [_alertView addSubview:self.subTitleLabel];
    
    CGFloat messageLabelY = 24.f;
    CGFloat messageHeight = 0.f;
    CGFloat messageX = 24.f;
    CGFloat messageWidth = alertWidth-messageX*2;
    UIFont *messageFont = [UIFont systemFontOfSize:13];
    if(!kIsEmptyStringIgnoreWhiteSpace(self.subTitleStr)){
        messageLabelY = self.subTitleLabel.frame.origin.y+self.subTitleLabel.frame.size.height+12;
    }
    else if(!kIsEmptyStringIgnoreWhiteSpace(self.titleStr)){
        messageLabelY = self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+12;
    }
    if(!kIsEmptyStringIgnoreWhiteSpace(self.messageStr)){
        messageHeight = [self.messageStr heightOfStringFont:messageFont width:messageWidth]+1;
    }
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageX, messageLabelY, messageWidth, messageHeight)];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.text = self.messageStr;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.textColor = [UIColor wg_colorWithHexString:@"#3C3C3C"];
    self.messageLabel.font = messageFont;
    [_alertView addSubview:self.messageLabel];
    
    alertHeight = self.messageLabel.frame.origin.y+self.messageLabel.frame.size.height+23;
    _alertView.frame = CGRectMake(28, 0, alertWidth, alertHeight);
    _alertView.center = self.view.center;
}

- (CGFloat)getAlertWidth{
    
    CGFloat alertWidth = WGNumScreenWidth()*0.85;
    if(alertWidth >= 320)
    {
        alertWidth = 320;
    }
    return alertWidth;
}



#pragma mark - getter/setter
- (void)setTitleColor:(UIColor *)titleColor{
    self.titleLabel.textColor = titleColor;
}


- (void)setTitleTextAlignment:(NSTextAlignment)titleTextAlignment{
    self.titleLabel.textAlignment = titleTextAlignment;
}

- (void)setSubTitleColor:(UIColor *)subTitleColor{
    self.subTitleLabel.textColor = subTitleColor;
}


- (void)setSubTitleTextAlignment:(NSTextAlignment)subTitleTextAlignment{
    self.subTitleLabel.textAlignment = subTitleTextAlignment;
}

- (void)setMessageColor:(UIColor *)messageColor{
    self.messageLabel.textColor = messageColor;
}

- (void)setMessageFont:(UIFont *)messageFont{
    
    if(kIsEmptyStringIgnoreWhiteSpace(self.messageStr)) return;
    CGFloat messageWidth = self.messageLabel.frame.size.width;
    CGFloat messageHeight = [self.messageStr heightOfStringFont:messageFont width:messageWidth]+1;
    CGFloat differenceH = messageHeight-self.messageLabel.frame.size.height;
    CGRect messageRect = self.messageLabel.frame;
    messageRect.size.height = messageHeight;
    self.messageLabel.frame = messageRect;
    self.messageLabel.font = messageFont;
    
    if(self.cancelBtn) self.cancelBtn.top += differenceH;
    if(self.submitBtn) self.submitBtn.top += differenceH;
    
    self.alertView.height += differenceH;
    self.alertView.center = self.view.center;
}

- (void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment{
    self.messageLabel.textAlignment = messageTextAlignment;
}

- (void)showToCurrentVc{
    UIViewController *vc = [self wg_currentController];
    UIViewController *currentPresentVc = [self wg_getTopCurrentPresentVcWithVc:vc];
    if(currentPresentVc && ![currentPresentVc isEqual:self]){
        [currentPresentVc presentViewController:self animated:NO completion:nil];
        return;
    }
    if (![currentPresentVc isEqual:self]) {
        [vc presentViewController:self animated:NO completion:nil];
    }
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
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)rootController;
        UIViewController *controller = [tabBarController.viewControllers wg_safeObjectAtIndex:tabBarController.selectedIndex];
        if ([controller isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *nav = (UINavigationController *)controller;
            return [nav.viewControllers lastObject];
        }
    } else if([rootController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)rootController;
        return [nav.viewControllers lastObject];
    } else if([rootController isKindOfClass:[UIViewController class]]) {
        return rootController;
    }
    return nil;
    
}

#pragma mark - onClick
- (void)closeBtClick:(UIButton *)button{
    
    [self dissmisAlertVc];
}

- (void)cancelClick:(UIButton *)button{
    
    [self dissmisAlertVc];
    if(self.cancelHandler) self.cancelHandler();
}

- (void)dissmisAlertVc{
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.customView.superview) {
            [self.customView removeFromSuperview];
        }
        if(self.alertView){
            [self.alertView removeFromSuperview];
        }
    }];
}

- (void)dissmisAlertVcWithCompletion:(void(^)(void))completion{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.customView.superview) {
            [self.customView removeFromSuperview];
        }
        if(self.alertView){
            [self.alertView removeFromSuperview];
        }
        if(completion){
            completion();
        }
    }];
}

- (BOOL)wg_needGETUserShopLastBrowse
{
    return NO;
}

- (void)dealloc
{
    
}

@end
