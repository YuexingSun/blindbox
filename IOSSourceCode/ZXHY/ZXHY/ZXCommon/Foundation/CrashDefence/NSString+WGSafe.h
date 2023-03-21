//
//  NSString+WGSafe.h
//  Yunhuoyouxuan
//
//  Created by zhongzhifeng on 2021/3/22.
//  Copyright © 2021 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (WGSafe)

+ (NSString *)wg_safeStringWithUTF8String:(const char *)nullTerminatedCString;
- (NSString *)wg_safeSubstringToIndex:(NSUInteger)to;
- (NSString *)wg_safeSubstringFromIndex:(NSUInteger)from;
- (NSString *)wg_safeSubstringWithRange:(NSRange)range;
- (BOOL)wg_safeHasPrefix:(NSString *)str;
- (NSString *)wg_safeStringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement;
- (NSRange)wg_safeRangeOfString:(NSString *)str;
+ (NSString *)wg_safeStringWithObject:(id)object;
@end

@interface NSMutableString (WGSafe)

- (void)wg_safeDeleteCharactersInRange:(NSRange)range;
- (void)wg_safeInsertString:(NSString *)aString atIndex:(NSUInteger)loc;
- (void)wg_safeReplaceCharactersInRange:(NSRange)range withString:(NSString *)aString;
@end

NS_ASSUME_NONNULL_END
