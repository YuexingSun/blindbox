//
//  WGRefreshClassifyHeader.m
//  WG_Common
//
//  Created by apple on 2021/5/24.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import "WGRefreshClassifyHeader.h"
#import <MJRefresh/MJRefreshComponent.h>
#import "UIColor+WGExtension.h"

@interface WGRefreshClassifyHeader()

@property(nonatomic, strong) UIImageView *arrowImageView;

@property(nonatomic, strong) UILabel *stateLabel;

@end

@implementation WGRefreshClassifyHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    self.mj_h = 54;
    
    [self addSubview:self.arrowImageView];
    
    [self addSubview:self.stateLabel];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    CGFloat stateLabelW = [self.stateLabel sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width, 16)].width;
    CGFloat arrowCenterX = self.mj_w * 0.5;
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGRect stateFrame = self.stateLabel.frame;
    stateFrame.size.width = stateLabelW;
    stateFrame.size.height = 16;
    stateFrame.origin.y = arrowCenterY-stateFrame.size.height / 2.0;
    stateFrame.origin.x = arrowCenterX-stateFrame.size.width / 2.0 - 16;
    self.stateLabel.frame = stateFrame;
    
    self.arrowImageView.frame = CGRectMake(stateFrame.origin.x + stateFrame.size.width + 4, arrowCenterY - 6, 12, 12);
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

#pragma mark - private method

- (void)roationArrowImageWithDirection:(BOOL)isUp {
    if(isUp){
        CGFloat radians = M_PI;
        [UIView animateWithDuration:0.3 animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(radians);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }];
        
    }
}

#pragma mark - setter & getter

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) { /** 普通闲置状态 */
        
        if (oldState == MJRefreshStateRefreshing) {
            self.stateLabel.text = @"释放，至上一个分类";
        }else{
            self.stateLabel.text = @"下拉，至上一个分类";
        }
        [self roationArrowImageWithDirection:YES];
    } else if (state == MJRefreshStatePulling) {/** 松开就可以进行刷新的状态 */
        
        self.stateLabel.text = @"释放，至上一个分类";
        [self roationArrowImageWithDirection:NO];
    } else if (state == MJRefreshStateRefreshing) { //正在刷新
        self.stateLabel.text = @"释放，至上一个分类";
    }else if (state == MJRefreshStateNoMoreData){ /** 所有数据加载完毕，没有更多的数据了 */
        self.stateLabel.text = @"释放，至上一个分类";
        [self roationArrowImageWithDirection:YES];
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    
    
}

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
