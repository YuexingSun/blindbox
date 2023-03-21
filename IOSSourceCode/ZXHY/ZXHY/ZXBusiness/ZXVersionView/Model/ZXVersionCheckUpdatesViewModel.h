//
//  ZXVersionCheckUpdatesViewModel.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXVersionCheckUpdatesViewModel : NSObject

@property (nonatomic, strong) NSString  *url;
@property (nonatomic, strong) NSString  *newest;
@property (nonatomic, assign) NSInteger  force;


@end

@interface ZXVersionCheckIndexShowViewModel : NSObject

@property (nonatomic, strong) NSString  *url;
@property (nonatomic, assign) NSInteger  type;

@end

NS_ASSUME_NONNULL_END
