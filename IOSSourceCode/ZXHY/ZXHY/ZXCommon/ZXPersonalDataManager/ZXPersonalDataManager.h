//
//  ZXPersonalDataManager.h
//  ZXHY
//
//  Created by Bern Mac on 8/5/21.
//

#import <Foundation/Foundation.h>
//#import "ZXVersionCheckUpdatesViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@class ZXVersionCheckUpdatesViewModel;

@interface ZXPersonalDataManager : NSObject

//单例声明
+ (instancetype)shareNetworkManager;

@property (nonatomic, strong) NSString *zx_token;
@property (nonatomic, strong) NSString *zx_userId;
@property (nonatomic, strong) NSString *zx_userName;

//是否为新用户
@property (nonatomic, strong) NSString *zx_isNew;

//是否首次盲盒提示(用于刚进去导航时)
@property (nonatomic, strong) NSString *zx_isFristEntryBoxTips;

//是否关闭当前导航提示(用于关闭导航时)
@property (nonatomic, strong) NSString *zx_isCloseExitNavTips;

//检查更新模型
@property (nonatomic, strong) ZXVersionCheckUpdatesViewModel  *zx_checkUpdatesModel;

@end

NS_ASSUME_NONNULL_END
