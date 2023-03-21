//
//  UITextField+WGExtension.h
//  WG_Common
//
//  Created by apple on 2021/4/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (WGExtension)

@property (assign, nonatomic)  NSInteger wg_maxLength;//if <=0, no limit

@end

NS_ASSUME_NONNULL_END
