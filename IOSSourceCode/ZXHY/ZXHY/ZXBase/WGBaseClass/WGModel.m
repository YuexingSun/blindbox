//
//  WGModel.m
//  Yunhuoyouxuan
//
//  Created by apple on 2020/8/17.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGModel.h"

@implementation WGModel
-(instancetype) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self != nil) { [self fillWithDictionary:[dictionary isKindOfClass:[NSDictionary class]] ? dictionary : nil]; }
    return self;
}

-(void) fillWithDictionary:(NSDictionary *)dictionary {
    
}

+(instancetype) mockModel {
    WGModel *mockModel = [[self alloc] init];
    [mockModel fillMockModel];
    return mockModel;
}

-(void) fillMockModel { }


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass { return nil; }
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper { return nil; }

@end
