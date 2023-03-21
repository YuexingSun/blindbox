//
//  ZXBlindBoxSelectViewModel.m
//  ZXHY
//
//  Created by Bern Mac on 8/5/21.
//

#import "ZXBlindBoxSelectViewModel.h"

@implementation ZXBlindBoxSelectViewModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
        @"ID" : @"id"
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
        @"itemlist" : [ZXBlindBoxSelectViewItemlistModel class]
    };
}

@end


@implementation ZXBlindBoxSelectViewMainModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
        @"list" : [ZXBlindBoxSelectViewModel class]
    };
}

@end


@implementation ZXBlindBoxSelectViewItemlistModel

@end
