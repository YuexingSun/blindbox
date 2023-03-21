//
//  ZXMineSetManager.h
//  ZXHY
//
//  Created by Bern Mac on 9/26/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZXMineSetType) {
    ZXMineSetType_Icon,
    ZXMineSetType_nickName,
    ZXMineSetType_Mobile,
    ZXMineSetType_Interest,
    ZXMineSetType_Wechat,
    ZXMineSetType_Age,
    ZXMineSetType_Sex,
    ZXMineSetType_Hobbies,
    ZXMineSetType_Notice,
    ZXMineSetType_Cancellation,
    ZXMineSetType_About,
    ZXMineSetType_Exit,
};

@interface ZXMineSetManager : NSObject

//单例声明
+ (instancetype)shareNetworkManager;

//对应数据赋值并提交
- (void)zx_setMineType:(ZXMineSetType)type
                 Value:(NSString *)value
            Completion:(void(^)(void))completion;

//上传头像
- (void)zx_setMineIconImage:(UIImage *)image
                 Completion:(void (^)(NSString *imageUrl))completion;


//含头像上传
- (void)zx_setMineIcon:(UIImage *)iconImage NickName:(NSString *)name Age:(NSString *)age Sex:(NSString *)sex Completion:(void (^)(NSString *imageUrl))completion;

@end

NS_ASSUME_NONNULL_END
