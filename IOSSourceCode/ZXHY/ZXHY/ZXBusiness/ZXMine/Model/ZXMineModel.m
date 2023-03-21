//
//  ZXMineModel.m
//  ZXHY
//
//  Created by Bern Mac on 8/27/21.
//

#import "ZXMineModel.h"

@implementation ZXMineUserProfileModel


@end

@implementation ZXMineModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
        @"myachievelist" : [ZXMineMyAchieveListModel class]
    };
}

@end


@implementation ZXMineMemberInfoModel

@end



@implementation ZXMineMyBeingBoxListModel

@end


@implementation ZXMineMyAchieveListModel


@end


@implementation ZXMineLastSevenDaysModel


+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
        @"catelist" : [ZXMineLastSevenDaysCatelistModel class]
    };
}

@end


@implementation ZXMineLastSevenDaysCatelistModel


@end
