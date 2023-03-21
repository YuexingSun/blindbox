//
//  ZXOpenResultsModel.m
//  ZXHY
//
//  Created by Bern Mac on 8/6/21.
//

#import "ZXOpenResultsModel.h"

@implementation ZXOpenResultsModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
        @"items" : [ZXOpenResultsItemsModel class]
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
        @"typenameStr" : @"typename"
    };
}



@end




@implementation ZXOpenResultslnglatModel

@end





@implementation ZXOpenResultsNavigationlistModel

@end





@implementation ZXOpenResultsColorlistModel

@end





@implementation ZXOpenResultsItemsModel

@end


