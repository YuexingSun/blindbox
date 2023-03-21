//
//  ZXBlindBoxFloatTagModel.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/12.
//

#import "ZXBlindBoxFloatTagModel.h"

@implementation ZXBlindBoxFloatTagModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
        @"colorlist" : [ZXBlindBoxFloatTagColorListModel class],
        @"catelist" : [ZXBlindBoxFloatTagCatelistModel class]
    };
}


@end



@implementation ZXBlindBoxFloatTagColorListModel


@end



@implementation ZXBlindBoxFloatTagCatelistModel

@end
