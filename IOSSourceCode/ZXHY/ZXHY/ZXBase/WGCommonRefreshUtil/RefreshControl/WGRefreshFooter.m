//
//  WGRefreshFooter.m
//  WG_Common
//
//  Created by apple on 2021/5/21.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import "WGRefreshFooter.h"

#import "WGNoMoreDataFooterView.h"

#import "UILabel+WGExtension.h"
#import "UIView+WGExtension.h"
#import "UIColor+WGExtension.h"
#import "NSString+WGExtension.h"

static NSString *const WGStrLoadingMJRefreshTips = @"努力加载中...";

@interface WGRefreshFooter()

@property (nonatomic, strong) UILabel *loadingLabel;

@property (nonatomic, strong) UIView *noNetworkView;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) WGNoMoreDataFooterView *nomoreDataView;

@property (nonatomic, strong) WGNoMoreDataFooterView *nomoreDataLogoView;

@end

@implementation WGRefreshFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    self.mj_h = 60;
    
    [self addSubview:self.loadingLabel];
    
    [self addSubview:self.stateLabel];
    
    [self addSubview:self.noNetworkView];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.noNetworkView.width = self.mj_w;
    self.nomoreDataView.width = self.mj_w;
    self.nomoreDataLogoView.width = self.mj_w;
    
    self.noNetworkView.centerX = self.mj_w / 2;
    self.nomoreDataView.centerX = self.mj_w / 2;
    self.nomoreDataLogoView.centerX = self.mj_w / 2;
    
    for (UIView *subview in self.noNetworkView.subviews) {
        subview.centerX = self.noNetworkView.width / 2;
    }
    
    self.loadingLabel.center = CGPointMake(self.mj_w / 2, self.mj_h / 2);
    self.stateLabel.centerX = self.loadingLabel.center.x;
    self.stateLabel.top = self.loadingLabel.bottom + 15;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark - Private method

- (void)startAnimation {
    self.loadingLabel.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 0.6;
    animation.repeatCount = CGFLOAT_MAX;
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    animation.removedOnCompletion = NO;
    [self.loadingLabel.layer addAnimation:animation forKey:@"rotate-layer"];
}

- (void)stopAnimation {
    self.loadingLabel.hidden = YES;
    [self.loadingLabel.layer removeAllAnimations];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    // 根据状态做事情
    self.nomoreDataView.hidden = YES;
    self.noNetworkView.hidden = YES;
    self.nomoreDataLogoView.hidden = YES;
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle || state == MJRefreshStateBadNetwork ||
       
        state == MJRefreshStateNoMoreDataWithLogo) {
        [self stopAnimation];
        self.stateLabel.text = @"";
        
        if (state == MJRefreshStateBadNetwork) {
            
            self.noNetworkView.hidden = NO;
            self.mj_h = self.noNetworkView.height;
            
        } else if (state == MJRefreshStateNoMoreData) {
            
            if (!self.nomoreDataView.superview) {
                [self addSubview:self.nomoreDataView];
            }
            self.nomoreDataView.hidden = NO;
            self.mj_h = self.nomoreDataView.height;
            
        } else if (state == MJRefreshStateNoMoreDataWithLogo) {
            
            if (!self.nomoreDataLogoView.superview) {
                [self addSubview:self.nomoreDataLogoView];
            }
            self.nomoreDataLogoView.hidden = NO;
            self.mj_h = self.nomoreDataLogoView.height;
            
        } else {
            self.mj_h = 60;
        }
        
        self.scrollView.mj_insetB = self.mj_h;
        [self layoutIfNeeded];
        
    } else if (state == MJRefreshStateRefreshing) {
        
        self.mj_h = MJRefreshFooterHeight;
        self.stateLabel.text = WGLocalizedString(WGStrLoadingMJRefreshTips);
        [self.stateLabel sizeToFit];
        [self startAnimation];
        [self layoutIfNeeded];
        
    }
}

- (UILabel *)loadingLabel
{
    if (!_loadingLabel) {
        UILabel *loadingLabel = UILabel.instance
        .wg_icon(e799,18)
        .wg_textColor([UIColor wg_colorWithHexString:@"#FF445E"])
        .wg_frame(CGRectMake(0, 0, 240, 60))
        .wg_sizeToFit
        .wg_addTo(self);
        _loadingLabel = loadingLabel;
        _loadingLabel.hidden = YES;
    }
    return _loadingLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel mj_label];
        _stateLabel.textColor = [UIColor wg_colorWithHexString:@"#424242"];
        _stateLabel.font = [UIFont systemFontOfSize:12];
    }
    return _stateLabel;
}

- (UIView *)noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mj_w, 94)];
        UILabel *label = [[UILabel alloc] init];
        label.text = WGLocalizedString(@"网络不给力");
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor wg_colorWithHexString:@"#606060"];
        [label sizeToFit];
        label.centerX = _noNetworkView.width / 2;
        label.y = 10;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:UIColor.whiteColor];
        button.layer.cornerRadius = 14;
        button.width = 100;
        button.height = 28;
        button.layer.borderColor = [UIColor wg_colorWithHexString:@"#BBBBBB"].CGColor;
        button.layer.borderWidth = 1;
        button.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        [button setTitle:@"点击重试" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor wg_colorWithHexString:@"#606060"] forState:UIControlStateNormal];
        button.centerX = _noNetworkView.width / 2;
        button.y = label.maxY + 8;
        [button addTarget:self action:@selector(retryButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_noNetworkView addSubview:label];
        [_noNetworkView addSubview:button];
        _noNetworkView.clipsToBounds = YES;
        _noNetworkView.hidden = YES;
    }
    return _noNetworkView;
}

- (void)retryButtonDidClicked:(UIButton *)button {
    [self beginRefreshing];
}

- (WGNoMoreDataFooterView *)nomoreDataView {
    if (!_nomoreDataView) {
        _nomoreDataView = [[WGNoMoreDataFooterView alloc] initWithFrame:CGRectMake(.0f, .0f, CGRectGetWidth(UIScreen.mainScreen.bounds), 56)];
    }
    return _nomoreDataView;
}

- (WGNoMoreDataFooterView *)nomoreDataLogoView {
    if (!_nomoreDataLogoView) {
        _nomoreDataLogoView = [[WGNoMoreDataFooterView alloc] initWithLogoType];
    }
    return _nomoreDataLogoView;
}

@end
