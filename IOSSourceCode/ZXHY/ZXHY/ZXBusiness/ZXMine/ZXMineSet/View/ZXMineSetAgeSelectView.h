//
//  ZXMineSetAgeSelectView.h
//  ZXHY
//
//  Created by Bern Mac on 9/28/21.
//

#import "WGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXMineSetAgeSelectView;

@protocol ZXMineSetAgeSelectViewDelegate <NSObject>

//取消 响应
- (void)closeAgeSelectView:(ZXMineSetAgeSelectView *)tipsView;

//确定 响应
- (void)sureAgeSelectView:(ZXMineSetAgeSelectView *)tipsView DateOfBirth:(NSString *)str;

@end

@interface ZXMineSetAgeSelectView : WGBaseView

@property (nonatomic, weak) id <ZXMineSetAgeSelectViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
