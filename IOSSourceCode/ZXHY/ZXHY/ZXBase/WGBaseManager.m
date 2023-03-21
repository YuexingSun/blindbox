//
//  WGBaseManager.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/9/30.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGBaseManager.h"


@interface WGBaseManager () <NSCopying, NSMutableCopying>

@end

@implementation WGBaseManager

+ (instancetype)wg_sharedManager
{
    static WGBaseManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self wg_sharedManager];
}

- (void)wg_setup
{
    
}

- (void)wg_reset
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)wg_addObservers
{
    
}

#pragma - NSCopying
- (id)copyWithZone:(struct _NSZone *)zone
{
    Class selfClass = [self class];
    return [selfClass wg_sharedManager];
}

#pragma - NSMutableCopying
- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
    Class selfClass = [self class];
    return [selfClass wg_sharedManager];
}

@end
