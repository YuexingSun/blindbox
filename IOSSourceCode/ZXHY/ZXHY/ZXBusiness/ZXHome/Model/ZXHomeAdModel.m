//
//  ZXHomeAdModel.m
//  ZXHY
//
//  Created by Bern Lin on 2022/3/3.
//

#import "ZXHomeAdModel.h"

@implementation ZXHomeAdModel

@end



@implementation ZXHomeTopAdModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
        @"list" : [ZXHomeAdModel class]
    };
}


@end

