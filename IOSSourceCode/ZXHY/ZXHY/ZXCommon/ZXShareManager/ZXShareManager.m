//
//  ZXShareManager.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/5.
//

#import "ZXShareManager.h"
#import "WXApi.h"

@implementation ZXShareManager

+ (instancetype) sharedManager
{
    static ZXShareManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//WXSceneSession          = 0,   /**< 聊天界面    */
//WXSceneTimeline         = 1,   /**< 朋友圈     */
//WXSceneFavorite         = 2,   /**< 收藏       */
//WXSceneSpecifiedSession = 3,   /**< 指定联系人  */

- (void)zx_wechatSendTitle:(NSString *)title Content:(NSString *)content ImageUrl:(NSString *)imageUrl Link:(NSString *)link Scene:(ZXShareScene)scene completion:(void (^ __nullable)(BOOL success))completion{
    
    [[UIImageView new] wg_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, WGImageCacheType cacheType, NSURL *imageURL) {
        
        NSData *imageData =  [[ZXNetworkManager shareNetworkManager] dataCompressedImageToLimitSizeOfKB:64 image:image];
        UIImage *img = [[UIImage alloc] initWithData:imageData];
        
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = content;
        [message setThumbImage:img];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = link;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        [WXApi sendReq:req completion:^(BOOL success) {
            completion(success);
        }];
    }];
}

@end
