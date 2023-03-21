//
//  NSObject+WGExtension.h
//  WG_Common
//
//  Created by zhongzhifeng on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WGExtension)

#pragma mark - Swizzling
+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector;


#pragma mark - WGCaConstant
/// 将所有数据转换成string类型
- (NSString *)wg_string;

- (NSString *)wg_stringJSON;

- (NSString *)wg_stringUTF8Encoding;

/// 将数据转换成整数类型
- (NSInteger)wg_integerValue;

- (id)wg_modelWithJSON;

+ (NSString *)wg_classString;

+ (instancetype)wg_objectWithDictionary:(NSDictionary *)dictionary;

+ (instancetype)wg_objectWithJSON:(id)JSON;

+ (id)wg_initResultDataKeyObjectWithDictionary:(NSDictionary *)dic key:(NSString *)key;

+ (NSMutableArray *)wg_initObjectsWithResultDataDictionary:(NSDictionary *)dic key:(NSString *)key;

+ (NSMutableArray *)wg_initObjectsWithOtherDictionary:(NSDictionary *)dic key:(NSString *)key;

+ (NSArray *)wg_initObjectsWithObjectsJSON:(NSString *)objectsJSON;

+ (id)wg_initObjectWithDictionary:(NSDictionary *)dic key:(NSString *)key;

+ (id)wg_initObjectDirectInResultDataWithDictionary:(NSDictionary *)dic;

+ (NSDictionary *)wg_dictionaryWithJSONString:(NSString *)str;

- (void)wg_performAfter:(NSTimeInterval)seconds block:(void(^)(void))block;

- (NSString *)wg_version;

- (NSInteger)wg_build;

@end

NS_ASSUME_NONNULL_END
