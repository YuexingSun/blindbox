//
//  ZXShareManager.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//分享到哪个地方
typedef NS_ENUM(int, ZXShareScene) {
    ZXShareScene_Session,         //聊天界面
    ZXShareScene_Timeline,        //朋友圈
    ZXShareScene_Favorite,        //收藏
    ZXShareScene_SpecifiedSession //指定联系人
};

@interface ZXShareManager : NSObject

+ (instancetype)sharedManager;

//分享链接到微信
- (void)zx_wechatSendTitle:(NSString *)title Content:(NSString *)content ImageUrl:(NSString *)imageUrl Link:(NSString *)link Scene:(ZXShareScene)scene completion:(void (^ __nullable)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END
