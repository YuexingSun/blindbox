//
//  NSArray+WGSafe.m
//  Yunhuoyouxuan
//
//  Created by zhongzhifeng on 2021/3/22.
//  Copyright © 2021 apple. All rights reserved.
//

#import "NSArray+WGSafe.h"

@implementation NSArray (WGSafe)

- (id)wg_safeObjectAtIndex:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    
    return value;
}

- (id)wg_rowDataWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [self count])
    {
        id datas = [self wg_safeObjectAtIndex:indexPath.section];
        if ([datas isKindOfClass:[NSArray class]] &&
            indexPath.row < [datas count])
        {
            return [datas wg_safeObjectAtIndex:indexPath.row];
        }
    }
    return nil;
}

@end

@implementation NSMutableArray (WGSafe)

- (id)wg_safeObjectAtIndex:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    
    return value;
}

- (void)wg_safeAddObject:(id)anObject
{
    if (anObject == nil) {
        return;
    }
    
    [self addObject:anObject];
}

- (void)wg_safeAddObjectsFromArray:(NSArray *)otherArray
{
    if (otherArray == nil) {
        return;
    }
    
    if ([otherArray isKindOfClass:[NSArray class]]) {
        [self addObjectsFromArray:otherArray];
    }
}

- (void)wg_safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    //(index >= [self count]) 这里index = 0 导致array不能正常添加
    if ((index >= [self count] && index != 0) || (anObject == nil)){
        return;
    }
    
    [self insertObject:anObject atIndex:index];
}

- (void)wg_safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (index >= [self count]) {
        return;
    }
    
    [self removeObjectAtIndex:index];
}

- (void)wg_safeRemoveObject:(id)anObject
{
    if (anObject == nil) {
        return;
    }
    if (![self containsObject:anObject]) {
        return;
    }
    
    [self removeObject:anObject];
}

- (void)wg_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (index >= [self count] || !anObject) {
        return;
    }
    
    [self replaceObjectAtIndex:index withObject:anObject];
}

@end
