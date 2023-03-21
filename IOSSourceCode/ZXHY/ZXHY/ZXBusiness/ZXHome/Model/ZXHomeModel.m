//
//  ZXHomeModel.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/28.
//

#import "ZXHomeModel.h"

@implementation ZXHomeModel


+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
        @"list" : [ZXHomeListModel class]
    };
}

@end


@implementation ZXHomeListModel


+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
        @"typeId" : @"id"
    };
}

@end


@implementation ZXHomeListLocationModel

@end
