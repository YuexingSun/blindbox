//
//  ZXPersonalDataManager.m
//  ZXHY
//
//  Created by Bern Mac on 8/5/21.
//

#import "ZXPersonalDataManager.h"

@implementation ZXPersonalDataManager

+ (instancetype)shareNetworkManager
{
    static ZXPersonalDataManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
