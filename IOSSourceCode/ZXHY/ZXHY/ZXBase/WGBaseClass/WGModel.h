//
//  WGModel.h
//  Yunhuoyouxuan
//
//  Created by apple on 2020/8/17.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WGModel : NSObject
-(instancetype) initWithDictionary:(NSDictionary*)dictionary;
-(void) fillWithDictionary:(NSDictionary*)dictionary;
+(instancetype) mockModel;
-(void) fillMockModel;

/// YYModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass;
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper;

@end
