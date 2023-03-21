//
//  WGNoMoreDataFooterView.h
//  Yunhuoyouxuan
//
//  Created by apple on 2021/4/16.
//  Copyright © 2021 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGNoMoreDataFooterView : UIView

/// 配置底部视图佩戴文字
/// @param frame frame
/// @param text 文字
- (instancetype)initWithFrame:(CGRect)frame text:(NSString * _Nullable)text;

/// icon样式的底部视图
- (instancetype)initWithLogoType;

@end

NS_ASSUME_NONNULL_END
