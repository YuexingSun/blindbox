//
//  ZXLogoutTipsView.h
//  ZXHY
//
//  Created by Bern Mac on 9/26/21.
//

#import "WGBaseView.h"

NS_ASSUME_NONNULL_BEGIN


@class ZXLogoutTipsView;

@protocol ZXLogoutTipsViewDelegate <NSObject>

//取消 响应
- (void)closeTipsView:(ZXLogoutTipsView *)tipsView;

//确定 响应
- (void)sureTipsView:(ZXLogoutTipsView *)tipsView;

@end

@interface ZXLogoutTipsView : WGBaseView


@property (nonatomic, weak) id <ZXLogoutTipsViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame TipsTitle:(NSString *)titleStr Content:(NSString *)contentStr SureButtonTitle:(NSString *)sureStr;

@end

NS_ASSUME_NONNULL_END
