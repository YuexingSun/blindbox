//
//  WGRefreshHeader.m
//  WG_Common
//
//  Created by apple on 2021/5/21.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import "WGRefreshHeader.h"
#import <Lottie/Lottie.h>
#import "UILabel+WGExtension.h"
#import "UIColor+WGExtension.h"
#import "UIView+WGExtension.h"

@interface WGRefreshHeader()

@property(nonatomic, strong) LOTAnimationView *lottieView;

@property(nonatomic, strong) UILabel *logoLabel;

@end

@implementation WGRefreshHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    [self addSubview:self.lottieView];
    [self addSubview:self.logoLabel];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.lottieView.frame = CGRectMake(self.mj_w / 2 - 12, self.mj_h / 2 - 12, 24, 24);
    
    CGFloat bottom = 0;
    if (self.logoLabel.hidden == NO) {
        self.logoLabel.left = self.mj_w / 2 - self.logoLabel.width / 2;
        bottom = self.logoLabel.bottom;
        self.lottieView.mj_y = bottom;
    }
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
    
}

- (void)addLogoImage:(BOOL)show {
    
    if (!show) {
        self.logoLabel.hidden = YES;
        self.mj_h = MJRefreshHeaderHeight;
    } else {
        self.logoLabel.hidden = NO;
        [self.logoLabel sizeToFit];
        self.mj_h = MJRefreshHeaderHeight + self.logoLabel.mj_h - 10;
        self.logoLabel.y = 10;
    }
    [self placeSubviews];
}

#pragma mark - setter & getter

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    self.lottieView.loopAnimation = YES;
    if (state == MJRefreshStateIdle) { /** 普通闲置状态 */
        [self.lottieView stop];
    } else if (state == MJRefreshStatePulling) {/** 松开就可以进行刷新的状态 */
        [self.lottieView play];
    } else if (state == MJRefreshStateRefreshing) { //正在刷新
        [self.lottieView play];
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
}

- (LOTAnimationView *)lottieView {
    if (!_lottieView) {
        _lottieView = [LOTAnimationView animationNamed:@"pulltorefresh"];
        _lottieView.loopAnimation = YES;
    }
    return _lottieView;
}

- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = UILabel.instance
        .wg_icon(e71a,60)
        .wg_textColor([UIColor wg_colorWithHexString:@"#3C3C3C" andAlpha:0.15])
        .wg_frame(CGRectMake(0, 0, 240, 60))
        .wg_sizeToFit
        .wg_addTo(self);
    }
    return _logoLabel;
}

- (void)setIsLight:(BOOL)isLight {
    _isLight = isLight;
    
    self.logoLabel.textColor = isLight ? [UIColor.whiteColor colorWithAlphaComponent:0.4] : [UIColor wg_colorWithHexString:@"#3C3C3C" andAlpha:0.15];
    [self.lottieView setAnimationNamed:isLight ? @"pulltorefresh-white" : @"pulltorefresh"  inBundle:[NSBundle bundleForClass:self.class]];
}

@end
