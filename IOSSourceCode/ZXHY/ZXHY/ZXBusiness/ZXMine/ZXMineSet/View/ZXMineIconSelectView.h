//
//  ZXMineIconSelectView.h
//  ZXHY
//
//  Created by Bern Mac on 9/26/21.
//

#import "WGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXMineIconSelectView;

@protocol ZXMineIconSelectViewDelegate <NSObject>

//取消 响应
- (void)closeIconSelectViewView:(ZXMineIconSelectView *)tipsView;

//拍摄 响应
- (void)theShootIconSelectViewView:(ZXMineIconSelectView *)tipsView;

//相册 响应
- (void)photoAlbumIconSelectViewView:(ZXMineIconSelectView *)tipsView;

@end

@interface ZXMineIconSelectView : WGBaseView

@property (nonatomic, weak) id <ZXMineIconSelectViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
