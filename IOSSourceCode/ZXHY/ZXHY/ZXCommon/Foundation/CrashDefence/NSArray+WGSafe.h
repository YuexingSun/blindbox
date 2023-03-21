//
//  NSArray+WGSafe.h
//  Yunhuoyouxuan
//
//  Created by zhongzhifeng on 2021/3/22.
//  Copyright © 2021 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (WGSafe)

- (id)wg_safeObjectAtIndex:(NSUInteger)index;
- (id)wg_rowDataWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface NSMutableArray (WGSafe)

- (id)wg_safeObjectAtIndex:(NSUInteger)index;
- (void)wg_safeAddObject:(id)anObject;
- (void)wg_safeAddObjectsFromArray:(NSArray *)otherArray;
- (void)wg_safeInsertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)wg_safeRemoveObjectAtIndex:(NSUInteger)index;
- (void)wg_safeRemoveObject:(id)anObject;
- (void)wg_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end



NS_ASSUME_NONNULL_END
