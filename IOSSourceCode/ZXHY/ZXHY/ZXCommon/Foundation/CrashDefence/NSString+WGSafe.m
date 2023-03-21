//
//  NSString+WGSafe.m
//  Yunhuoyouxuan
//
//  Created by zhongzhifeng on 2021/3/22.
//  Copyright © 2021 apple. All rights reserved.
//

#import "NSString+WGSafe.h"

@implementation NSString (WGSafe)

+ (NSString *)wg_safeStringWithUTF8String:(const char *)nullTerminatedCString
{
    if (nullTerminatedCString == NULL) {
        return @"";
    } else {
        return [NSString stringWithUTF8String:nullTerminatedCString];
    }
}

- (NSString *)wg_safeSubstringToIndex:(NSUInteger)to
{
    if (to > [self length]) {
        return nil;
    }
    
    return [self substringToIndex:to];
}

- (NSString *)wg_safeSubstringFromIndex:(NSUInteger)from
{
    if (from > [self length]) {
        return nil;
    }
    
    return [self substringFromIndex:from];
}

- (NSString *)wg_safeSubstringWithRange:(NSRange)range
{
    if (((NSInteger)range.length) < 0 || ((NSInteger)range.location) < 0)
    {
        return nil;
    }
    
    if ((range.location + range.length) > self.length)
    {
        return nil;
    }
    
    return [self substringWithRange:range];
}

- (BOOL)wg_safeHasPrefix:(NSString *)str
{
    if (!str) {
        return NO;
    }
    
    return [self hasPrefix:str];
}

- (NSString *)wg_safeStringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {
    if (range.location + range.length > self.length) {
        return self;
    }else {
        return [self stringByReplacingCharactersInRange:range withString:replacement];
    }
    
}

- (NSRange)wg_safeRangeOfString:(NSString *)str
{
    if (!str) {
        return NSMakeRange(NSNotFound, 0);
    }
    return [self rangeOfString:str];
}

+ (NSString *)wg_safeStringWithObject:(id)object
{
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object isKindOfClass:[NSObject class]]) {
        return [NSString stringWithFormat:@"%@",object];
    }
    return nil;
}

@end

@implementation NSMutableString (WGSafe)

- (void)wg_safeDeleteCharactersInRange:(NSRange)range
{
    if ((range.location + range.length) > self.length)
    {
        return;
    }
    
    return [self deleteCharactersInRange:range];
}

- (void)wg_safeInsertString:(NSString *)aString atIndex:(NSUInteger)loc
{
    if (loc > [self length]) {
        return;
    }
    
    [self insertString:aString atIndex:loc];
}

- (void)wg_safeReplaceCharactersInRange:(NSRange)range withString:(NSString *)aString
{
    if ((range.location + range.length) > self.length)
    {
        return; //会发生越界错误
    }
    
    [self replaceCharactersInRange:range withString:aString];
}


@end
