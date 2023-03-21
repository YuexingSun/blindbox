//
//  NSMutableSet+WGSafe.h
//  Yunhuoyouxuan
//
//  Created by zhongzhifeng on 2021/3/22.
//  Copyright © 2021 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableSet (WGSafe)

- (void)wg_safeAddObject:(id)anObject;
- (void)wg_safeAddObjectsFromArray:(NSArray *)otherArray;
- (void)wg_safeRemoveObject:(id)anObject;

@end

NS_ASSUME_NONNULL_END
