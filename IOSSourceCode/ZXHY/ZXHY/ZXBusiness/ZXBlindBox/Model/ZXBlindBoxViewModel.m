//
//  ZXBlindBoxViewModel.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/30.
//

#import "ZXBlindBoxViewModel.h"
#import "ZXOpenResultsModel.h"

@implementation ZXBlindBoxViewModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
        @"parentlist" : [ZXBlindBoxViewParentlistModel class]
    };
}

@end



@implementation ZXBlindBoxViewParentlistModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
        @"childlist" : [ZXOpenResultsModel class]
    };
}


@end

