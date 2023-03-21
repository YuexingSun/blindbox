//
//  NSNumber+WGExtension.h
//  WG_Common
//
//  Created by zhongzhifeng on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN




/// 获取屏幕宽度
CGFloat WGNumScreenWidth(void);

/// 获取屏幕高度
CGFloat WGNumScreenHeight(void);

/// 获取屏幕宽度
CGFloat WGNumMainViewWidth(void);

CGFloat WGNumBrandModelCellHeight(void);

CGFloat WGNumGoodsDeatailBrandCellHeight(void);

CGFloat WGNumBrandEmptyModelCellHeight(void);

CGFloat WGHomeTypeHight(void);

CGFloat WGNumNavHeight(void);

CGFloat WGNumShoppingCartConfirmOrderCtrlBottomViewHeight(void);

CGFloat WGNumSafeAreaTop(void);

@interface NSNumber (WGExtension)

@end

NS_ASSUME_NONNULL_END
