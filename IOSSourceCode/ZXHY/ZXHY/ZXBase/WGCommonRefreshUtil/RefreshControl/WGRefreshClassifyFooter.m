//
//  WGRefreshClassifyFooter.m
//  WG_Common
//
//  Created by apple on 2021/5/24.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import "WGRefreshClassifyFooter.h"
#import "UIView+WGExtension.h"
#import "UIColor+WGExtension.h"

@interface WGRefreshClassifyFooter()

@property(nonatomic, strong) UIImageView *arrowImageView;

@property(nonatomic, strong) UILabel *stateLabel;

@end

@implementation WGRefreshClassifyFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    self.mj_h = 44;
    
    [self addSubview:self.arrowImageView];
    
    [self addSubview:self.stateLabel];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    CGFloat stateLabelW = [self.stateLabel sizeThatFits:CGSizeMake(UIScreen.mainScreen.bounds.size.width, 16)].width;
    CGFloat arrowCenterX = self.mj_w * 0.5;
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGRect stateFrame = self.stateLabel.frame;
    stateFrame.size.width = stateLabelW;
    stateFrame.size.height = 16;
    stateFrame.origin.y = arrowCenterY-stateFrame.size.height/2.0;
    stateFrame.origin.x = arrowCenterX-stateFrame.size.width/2.0-16;
    self.stateLabel.frame = stateFrame;
    
    self.arrowImageView.frame = CGRectMake(stateFrame.origin.x + stateFrame.size.width + 4, arrowCenterY - 6, 12, 12);
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

- (void)roationArrowImageWithIsReset:(BOOL)isReset {
    if(isReset) {
        [UIView animateWithDuration:0.3 animations:^{
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }];
    } else {
        CGFloat radians = M_PI;
        [UIView animateWithDuration:0.3 animations:^{
            if (!CGAffineTransformEqualToTransform(self.arrowImageView.transform, CGAffineTransformMakeRotation(radians))) {
                self.arrowImageView.transform = CGAffineTransformMakeRotation(radians);
            }
        }];
    }
}


#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    if(state == MJRefreshStatePulling || state == MJRefreshStateRefreshing){
        self.stateLabel.text = @"释放，至下一个分类";
        [self roationArrowImageWithIsReset:NO];
    }else{
        self.stateLabel.text = @"上拉，至下一个分类";
        [self roationArrowImageWithIsReset:YES];
    }
    
}

#pragma mark - setter & getter

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [UILabel mj_label];
        _stateLabel.font = [UIFont systemFontOfSize:11];
        _stateLabel.textColor = [UIColor wg_colorWithHexString:@"#999999"];
    }
    return _stateLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.mj_w/2.0, self.mj_h/2.0, 12, 12)];
        _arrowImageView.image = [UIImage imageNamed:@"header_refresh_pageup"];
    }
    return _arrowImageView;
}

@end
