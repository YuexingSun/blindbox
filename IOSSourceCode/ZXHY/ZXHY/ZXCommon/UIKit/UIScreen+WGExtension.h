//
//  UIScreen+WGExtension.h
//  WG_Common
//
//  Created by apple on 2021/6/1.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (WGExtension)

@property(nonatomic, readonly, class) CGFloat safeAreaTop;

@property(nonatomic, readonly, class) CGFloat safeAreaLeft;

@property(nonatomic, readonly, class) CGFloat safeAreaBottom;

@property(nonatomic, readonly, class) CGFloat safeAreaRight;

@end

NS_ASSUME_NONNULL_END
