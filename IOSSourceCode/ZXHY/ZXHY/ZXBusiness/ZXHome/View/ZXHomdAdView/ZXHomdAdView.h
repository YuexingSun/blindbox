//
//  ZXHomdAdView.h
//  ZXHY
//
//  Created by Bern Lin on 2022/3/2.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class ZXHomdAdView,ZXHomeAdModel;

@protocol ZXHomdAdViewDelegate <NSObject>

//关闭 响应
- (void)closeHomdAdView:(ZXHomdAdView *)adView;

@end

typedef void (^CloseAdViewBlock) (void);

@interface ZXHomdAdView : UIView

@property (nonatomic, weak) id <ZXHomdAdViewDelegate> delegate;

//关闭按钮Block
@property (nonatomic, strong) CloseAdViewBlock  closeAdViewBlock;


- (void)zx_homeAdModel:(ZXHomeAdModel *)adModel;

@end

NS_ASSUME_NONNULL_END
