//
//  ZXMapFirstEntryTipsView.h
//  ZXHY
//
//  Created by Bern Mac on 8/25/21.
//

#import "WGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZXTipsType) {
    ZXTipsType_FristEntry,
    ZXTipsType_CloseNavi,
};

@class ZXMapFirstEntryTipsView;

@protocol ZXMapFirstEntryTipsViewDelegate <NSObject>

//我知道了 或 取消 响应
- (void)closeTipsView:(ZXMapFirstEntryTipsView *)tipsView;

//确定 响应
- (void)sureTipsView:(ZXMapFirstEntryTipsView *)tipsView;


@end

@interface ZXMapFirstEntryTipsView : WGBaseView

@property (nonatomic, weak) id <ZXMapFirstEntryTipsViewDelegate> delegate;

//进来的类型
- (instancetype)initWithFrame:(CGRect)frame WithEntryTipsType:(ZXTipsType)tipsType;

@end

NS_ASSUME_NONNULL_END
