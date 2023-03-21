//
//  ZXMineBlindBoxStatisticsView.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXMineModel;

@interface ZXMineBlindBoxStatisticsView : UIView

//数据赋值
- (void)zx_dataWithMineModel:(ZXMineModel *)mineModel;

@end

NS_ASSUME_NONNULL_END
