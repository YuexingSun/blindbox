//
//  WGGeneralSheetContainerView.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/12/3.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGGeneralSheetContainerView.h"

#import "NSNumber+WGExtension.h"
#import "WGMacro.h"
#import "UIView+WGExtension.h"

@implementation WGGeneralSheetContainerView

- (instancetype)initWithWg_customView:(UIView *)customView
{
    return [self initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight()) wg_customView:customView];
}

- (instancetype)initWithFrame:(CGRect)frame wg_customView:(UIView *)customView
{
    self = [self initWithFrame:frame];
    if (self)
    {
        _wg_customView = customView;
        [self wg_initBgView];
        [self wg_initCustomBgView];
        [self setWg_isForceDeviceWidth:NO];
        [self addSubview:_wg_customView];
        
    }
    return self;
}

- (void)setWg_isForceDeviceWidth:(BOOL)wg_isForceDeviceWidth
{
    _wg_isForceDeviceWidth = wg_isForceDeviceWidth;
    CGRect frame = self.frame;
    CGRect customViewFrame = _wg_customView.frame;
    if (_wg_isForceDeviceWidth)
    {
        customViewFrame.size.width = WGNumScreenWidth();
    }
    customViewFrame.size.height = frame.size.height - _wg_customView.top;
    _wg_customView.frame = customViewFrame;
    [_wg_customView wg_setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:16];
}

- (void)wg_initBgView
{
    if (!_wg_bgView)
    {
        _wg_bgView = [[WGBaseView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumNavHeight())];
        _wg_bgView.backgroundColor = [UIColor blackColor];
        _wg_bgView.alpha = 0;
    }
}

- (void)wg_initCustomBgView
{
    if (!_wg_customBgView)
    {
        _wg_customBgView = [[UIButton alloc] initWithFrame:CGRectZero];
        _wg_customBgView.backgroundColor = [UIColor blackColor];
        _wg_customBgView.alpha = 0;
        [_wg_customBgView addTarget:self action:@selector(wg_dismissContainerView) forControlEvents:UIControlEventTouchDown];
    }
}

- (void)wg_showContainerViewInView:(UIView *)view
{
    if (!_wg_isShowed)
    {
        self.wg_isShowed = YES;
        if (self.wg_isForceDeviceWidth)
        {
            CGFloat offsetX = (WGNumScreenWidth() - view.width) / 2;
            _wg_customBgView.frame = CGRectMake(-offsetX, 0, view.width + offsetX * 2, view.height);

        }
        else
        {
            _wg_customBgView.frame = view.bounds;

        }
        [view addSubview:_wg_customBgView];
        [view addSubview:self];
        
        
        WEAKSELF
        [UIView animateWithDuration:0.3 animations:^{
            STRONGSELF
            self.wg_bgView.alpha = 0.3;
            self.wg_customBgView.alpha = 0.3;
            if (self.wg_isForceDeviceWidth)
            {
                CGFloat offsetX = (WGNumScreenWidth() - view.width) / 2;
                self.frame = CGRectMake(-offsetX, 0, view.width + offsetX * 2, view.height);
            }
            else
            {
                self.frame = view.bounds;
            }
        }];
    }
}

- (void)wg_dismissContainerView
{
    if (_wg_isShowed)
    {
        WEAKSELF
        [UIView animateWithDuration:0.3 animations:^{
            STRONGSELF
            if (self.wg_isForceDeviceWidth)
            {
                CGFloat offsetX = (WGNumScreenWidth() - self.superview.width) / 2;
                self.frame = CGRectMake(-offsetX, self.superview.height, self.superview.width + offsetX * 2, self.superview.height);
            }
            else
            {
                self.frame = CGRectMake(0, self.superview.height, self.superview.width, self.superview.height);
            }
            self.wg_bgView.alpha = 0;
            self.wg_customBgView.alpha = 0;
        } completion:^(BOOL finished) {
            STRONGSELF
            [self removeFromSuperview];
            [self.wg_customBgView removeFromSuperview];
            [self.wg_bgView removeFromSuperview];
            self.wg_isShowed = NO;
        }];
    }

}
 

@end
