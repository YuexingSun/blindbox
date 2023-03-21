//
//  NSMutableSet+WGSafe.m
//  Yunhuoyouxuan
//
//  Created by zhongzhifeng on 2021/3/22.
//  Copyright © 2021 apple. All rights reserved.
//

#import "NSMutableSet+WGSafe.h"

@implementation NSMutableSet (WGSafe)

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
    
    [self addObjectsFromArray:otherArray];
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

@end
