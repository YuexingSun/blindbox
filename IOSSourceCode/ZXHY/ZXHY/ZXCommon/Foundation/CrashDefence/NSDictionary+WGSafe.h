//
//  NSDictionary+WGSafe.h
//  Yunhuoyouxuan
//
//  Created by zhongzhifeng on 2021/3/22.
//  Copyright © 2021 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (WGSafe)

- (id)wg_safeObjectForKey:(id)aKey;

@end


@interface NSMutableDictionary (WGSafe)

- (id)wg_safeObjectForKey:(id)aKey;
- (void)wg_safeRemoveObjectForKey:(id)aKey;
- (void)wg_safeSetObject:(id)anObject forKey:(id)aKey;

@end


NS_ASSUME_NONNULL_END
