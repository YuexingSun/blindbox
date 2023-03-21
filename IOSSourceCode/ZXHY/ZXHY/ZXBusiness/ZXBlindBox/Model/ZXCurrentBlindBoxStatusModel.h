//
//  ZXCurrentBlindBoxStatusModel.h
//  ZXHY
//
//  Created by Bern Mac on 8/26/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCurrentBlindBoxStatusModel : NSObject

@property (nonatomic, strong) NSString *boxid;

//是否有待开启或者进行中的盲盒，0没有，1有
@property (nonatomic, strong) NSString *isbeing;

//0    待开启
//1    已开启，进行中，未到达
//2    已到达，未评价
//3    已评价，已完成
//4    已过期失效
//5    已主动丢弃
@property (nonatomic, strong) NSString *status;


@end

NS_ASSUME_NONNULL_END
