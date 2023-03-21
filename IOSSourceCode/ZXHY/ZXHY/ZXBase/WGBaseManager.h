//
//  WGBaseManager.h
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/9/30.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGBaseManager : NSObject

+ (instancetype)wg_sharedManager;

- (void)wg_setup;

- (void)wg_reset;

- (void)wg_addObservers;

@end

NS_ASSUME_NONNULL_END
