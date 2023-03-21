//
//  NSObject+WGExtension.m
//  WG_Common
//
//  Created by zhongzhifeng on 2021/4/29.
//

#import "NSObject+WGExtension.h"
#import <objc/runtime.h>
#import "YYModel.h"
#import "NSDictionary+WGSafe.h"
#import "NSArray+WGSafe.h"

static NSString *const WGAutocodingException = @"WGAutocodingException";

@implementation NSObject (WGExtension)

#pragma mark - Swizzling
+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    //原有方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    //替换原有方法的新方法
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    //先尝试給源SEL添加IMP，这里是为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {//添加成功：说明源SEL没有实现IMP，将源SEL的IMP替换到交换SEL的IMP
        class_replaceMethod(class,swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {//添加失败：说明源SEL已经有IMP，直接将两个SEL的IMP交换即可
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)wg_setWithCoder:(NSCoder *)aDecoder
{
    BOOL secureAvailable = [aDecoder respondsToSelector:@selector(decodeObjectOfClass:forKey:)];
    BOOL secureSupported = [[self class] supportsSecureCoding];
    NSDictionary *properties = [self wg_codableProperties];
    for (NSString *key in properties)
    {
        id object = nil;
        Class propertyClass = properties[key];
        if (secureAvailable)
        {
            object = [aDecoder decodeObjectOfClass:propertyClass forKey:key];
        }
        else
        {
            object = [aDecoder decodeObjectForKey:key];
        }
        if (object)
        {
            if (secureSupported && ![object isKindOfClass:propertyClass])
            {
                [NSException raise:WGAutocodingException format:@"Expected '%@' to be a %@, but was actually a %@", key, propertyClass, [object class]];
            }
            [self setValue:object forKey:key];
        }
    }
}

+ (NSDictionary *)wg_codableProperties
{
    //deprecated
    SEL deprecatedSelector = NSSelectorFromString(@"codableKeys");
    if ([self respondsToSelector:deprecatedSelector] || [self instancesRespondToSelector:deprecatedSelector])
    {
        NSLog(@"AutoCoding Warning: codableKeys method is no longer supported. Use codableProperties instead.");
    }
    deprecatedSelector = NSSelectorFromString(@"uncodableKeys");
    if ([self respondsToSelector:deprecatedSelector] || [self instancesRespondToSelector:deprecatedSelector])
    {
        NSLog(@"AutoCoding Warning: uncodableKeys method is no longer supported. Use ivars, or synthesize your properties using non-KVC-compliant names to avoid coding them instead.");
    }
    deprecatedSelector = NSSelectorFromString(@"uncodableProperties");
    NSArray *uncodableProperties = nil;
    if ([self respondsToSelector:deprecatedSelector] || [self instancesRespondToSelector:deprecatedSelector])
    {
        uncodableProperties = [self valueForKey:@"uncodableProperties"];
        NSLog(@"AutoCoding Warning: uncodableProperties method is no longer supported. Use ivars, or synthesize your properties using non-KVC-compliant names to avoid coding them instead.");
    }
    unsigned int propertyCount;
    __autoreleasing NSMutableDictionary *codableProperties = [NSMutableDictionary dictionary];
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        //get property name
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        __autoreleasing NSString *key = @(propertyName);
        //check if codable
        if (![uncodableProperties containsObject:key])
        {
            //get property type
            Class propertyClass = nil;
            char *typeEncoding = property_copyAttributeValue(property, "T");
            switch (typeEncoding[0])
            {
                case '@':
                {
                    if (strlen(typeEncoding) >= 3)
                    {
                        char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                        __autoreleasing NSString *name = @(className);
                        NSRange range = [name rangeOfString:@"<"];
                        if (range.location != NSNotFound)
                        {
                            name = [name substringToIndex:range.location];
                        }
                        propertyClass = NSClassFromString(name) ?: [NSObject class];
                        free(className);
                    }
                    break;
                }
                case 'c':
                case 'i':
                case 's':
                case 'l':
                case 'q':
                case 'C':
                case 'I':
                case 'S':
                case 'L':
                case 'Q':
                case 'f':
                case 'd':
                case 'B':
                {
                    propertyClass = [NSNumber class];
                    break;
                }
                case '{':
                {
                    propertyClass = [NSValue class];
                    break;
                }
            }
            free(typeEncoding);
            if (propertyClass)
            {
                //check if there is a backing ivar
                char *ivar = property_copyAttributeValue(property, "V");
                if (ivar)
                {
                    //check if ivar has KVC-compliant name
                    __autoreleasing NSString *ivarName = @(ivar);
                    if ([ivarName isEqualToString:key] || [ivarName isEqualToString:[@"_" stringByAppendingString:key]])
                    {
                        //no setter, but setValue:forKey: will still work
                        codableProperties[key] = propertyClass;
                    }
                    free(ivar);
                }
                else
                {
                    //check if property is dynamic and readwrite
                    char *dynamic = property_copyAttributeValue(property, "D");
                    char *readonly = property_copyAttributeValue(property, "R");
                    if (dynamic && !readonly)
                    {
                        //no ivar, but setValue:forKey: will still work
                        codableProperties[key] = propertyClass;
                    }
                    free(dynamic);
                    free(readonly);
                }
            }
        }
    }
    free(properties);
    return codableProperties;
}

- (NSDictionary *)wg_codableProperties
{
    __autoreleasing NSDictionary *codableProperties = objc_getAssociatedObject([self class], _cmd);
    if (!codableProperties)
    {
        codableProperties = [NSMutableDictionary dictionary];
        Class subclass = [self class];
        while (subclass != [NSObject class])
        {
            [(NSMutableDictionary *)codableProperties addEntriesFromDictionary:[subclass wg_codableProperties]];
            subclass = [subclass superclass];
        }
        codableProperties = [NSDictionary dictionaryWithDictionary:codableProperties];
        //make the association atomically so that we don't need to bother with an @synchronize
        objc_setAssociatedObject([self class], _cmd, codableProperties, OBJC_ASSOCIATION_RETAIN);
    }
    return codableProperties;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    [self wg_setWithCoder:aDecoder];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in [self wg_codableProperties])
    {
        id object = [self valueForKey:key];
        if (object) [aCoder encodeObject:object forKey:key];
    }
}

#pragma mark - WGCaConstant
- (NSString *)wg_string
{
    if ([self isKindOfClass:[NSString class]])
    {
        return (NSString *)self;
    }
    
    if ([self isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    
    if ([self isKindOfClass:[NSNumber class]])
    {
        return [(NSNumber *)self stringValue];
    }
    
    if ([self isKindOfClass:[NSArray class]] ||
        [self isKindOfClass:[NSDictionary class]])
    {
        return [self wg_stringJSON];
    }
    
    return @"";
}

- (NSString *)wg_stringJSON
{
    if (![self isKindOfClass:[NSDictionary class]] &&
        ![self isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    
    NSError *error = nil;
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (!dataJSON)
    {
//        WGLog(@"JSONObject:%@\nError:%@", self, error);
        return nil;
    }
    return [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
}

- (NSString *)wg_stringUTF8Encoding
{
    NSStringEncoding stringEncoding = NSUTF8StringEncoding;
    if ([self isKindOfClass:[NSString class]])
    {
        NSString *string = (NSString *)self;
        NSData *dataString = [string dataUsingEncoding:stringEncoding];
        return [[NSString alloc] initWithData:dataString encoding:stringEncoding];
    }
    return [self wg_stringJSON];
}

- (NSInteger)wg_integerValue
{
    return [[self wg_string] integerValue];
}

- (id)wg_modelWithJSON
{
    return [self yy_modelToJSONObject];
}

+ (NSString *)wg_classString
{
    return NSStringFromClass([self class]);
}

+ (instancetype)wg_objectWithDictionary:(NSDictionary *)dictionary
{
    id object = [self yy_modelWithDictionary:dictionary];
    if ([object respondsToSelector:@selector(wg_initRelevant)])
    {
        //TODO:考虑放到业务
        [object performSelector:@selector(wg_initRelevant)];
    }
    return object;
}

+ (instancetype)wg_objectWithJSON:(id)JSON
{
    return [self yy_modelWithJSON:JSON];
}

+ (id)wg_initResultDataKeyObjectWithDictionary:(NSDictionary *)dic key:(NSString *)key
{
    NSDictionary *resultDataDic = [dic wg_safeObjectForKey:@"data"];
    if ([resultDataDic isKindOfClass:[NSDictionary class]])
    {
        return [resultDataDic wg_safeObjectForKey:key];
    }
    return nil;
}

+ (NSMutableArray *)wg_initObjectsWithResultDataDictionary:(NSDictionary *)dic key:(NSString *)key
{
    NSMutableArray *objects = nil;
    NSArray *objectDics = [self wg_initResultDataKeyObjectWithDictionary:dic key:key];
    for (NSDictionary *objectDic in objectDics)
    {
        id object = [[self class] wg_objectWithDictionary:objectDic];
        if (object)
        {
            if (!objects)
            {
                objects = [NSMutableArray arrayWithCapacity:[objectDics count]];
            }
            [objects wg_safeAddObject:object];
        }
        
    }
    return objects;
}

+ (NSMutableArray *)wg_initObjectsWithOtherDictionary:(NSDictionary *)dic key:(NSString *)key
{
    NSMutableArray *objects = nil;
    NSArray *objectDics = [dic wg_safeObjectForKey:key];
    for (NSDictionary *objectDic in objectDics)
    {
        id object = [[self class] wg_objectWithDictionary:objectDic];
        if (object)
        {
            if (!objects)
            {
                objects = [NSMutableArray arrayWithCapacity:[objectDics count]];
            }
            [objects wg_safeAddObject:object];
        }
    }
    return objects;
}

+ (NSArray *)wg_initObjectsWithObjectsJSON:(NSString *)modelsJSON
{
    return [NSArray yy_modelArrayWithClass:[self class] json:modelsJSON];
}

+ (id)wg_initObjectWithDictionary:(NSDictionary *)dic key:(NSString *)key
{
    NSDictionary *objectDic = [self wg_initResultDataKeyObjectWithDictionary:dic key:key];
    if (![objectDic isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    return [[self class] wg_objectWithDictionary:objectDic];
}

+ (id)wg_initObjectDirectInResultDataWithDictionary:(NSDictionary *)dic
{
    NSDictionary *resultDataDic = [dic wg_safeObjectForKey:@"resultData"];
    if ([resultDataDic isKindOfClass:[NSDictionary class]])
    {
        return [[self class] wg_objectWithDictionary:resultDataDic];
    }
    return nil;
}

+ (NSDictionary *)wg_dictionaryWithJSONString:(NSString *)str
{
    if (!str)
    {
        return nil;
    }
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(error)
    {
//        WGLog(@"JSON解析失败：%@", error);
        return nil;
    }
    return dic;
}

- (void)wg_performAfter:(NSTimeInterval)seconds block:(void(^)(void))block {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_current_queue(), block);
    dispatch_after(popTime, dispatch_get_main_queue(), block);

}

-(NSString *)wg_version{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

-(NSInteger)wg_build{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [app_build integerValue];
}

@end
