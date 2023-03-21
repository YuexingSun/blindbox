//
//  ZXMyCollectionModel.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/6.
//

#import "ZXMyCollectionModel.h"

@implementation ZXMyCollectionModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
        @"list" : [ZXMyCollectionListModel class]
    };
}


@end



@implementation ZXMyCollectionListModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
        @"typeId" : @"id"
    };
}


@end
