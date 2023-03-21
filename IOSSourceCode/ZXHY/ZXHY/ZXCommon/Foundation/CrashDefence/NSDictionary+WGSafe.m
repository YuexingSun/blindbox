//
//  NSDictionary+WGSafe.m
//  Yunhuoyouxuan
//
//  Created by zhongzhifeng on 2021/3/22.
//  Copyright © 2021 apple. All rights reserved.
//

#import "NSDictionary+WGSafe.h"
#import <objc/runtime.h>

@implementation NSDictionary (WGSafe)

+ (void)load
{
    Class class = [self class];
    SEL originalSelector = @selector(dictionaryWithObjects:forKeys:count:);
    SEL swizzledSelector = @selector(wg_dictionaryWithObjects:forKeys:count:);
    //原有方法
    Method originalMethod = class_getClassMethod(class, originalSelector);
    //替换原有方法的新方法
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (instancetype)wg_dictionaryWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt
{
    id newarr[cnt];
    for (int i = 0; i < cnt; i++) {
        if (!objects[i]) {
            for (int i = 0; i < cnt; i++) {
                if (!objects[i]) {
                    newarr[i] = @"";
                } else {
                    newarr[i] = objects[i];
                }
            }
            objects = &newarr[0];
            break;
        }
    }
    
    return [NSDictionary wg_dictionaryWithObjects:objects forKeys:keys count:cnt];
}



- (id)wg_safeObjectForKey:(id)aKey
{
    if (aKey == nil) {
        return nil;
    }
    
    id value = [self objectForKey:aKey];
    if (value == [NSNull null]) {
        return nil;
    }
    
    return value;
}

@end

@implementation NSMutableDictionary (WGSafe)

- (id)wg_safeObjectForKey:(id)aKey
{
    if (aKey == nil) {
        return nil;
    }
    
    id value = [self objectForKey:aKey];
    if (value == [NSNull null]) {
        return nil;
    }
    
    return value;
}

- (void)wg_safeRemoveObjectForKey:(id)aKey
{
    if (aKey == nil) {
        return;
    }else{
        [self removeObjectForKey:aKey];
    }
}

- (void)wg_safeSetObject:(id)anObject forKey:(id)aKey
{
    if (anObject == nil || aKey == nil) {
        return;
    }else{
        [self setObject:anObject forKey:aKey];
    }
}

@end
