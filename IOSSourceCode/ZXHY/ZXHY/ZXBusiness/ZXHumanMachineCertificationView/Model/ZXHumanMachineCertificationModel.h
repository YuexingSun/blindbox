//
//  ZXHumanMachineCertificationModel.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXHumanMachineCertificationModel : NSObject

@property (nonatomic, strong) NSString  *appid;
@property (nonatomic, strong) NSString  *randstr;
@property (nonatomic, assign) NSInteger ret;
@property (nonatomic, strong) NSString  *ticket;


@end

NS_ASSUME_NONNULL_END
