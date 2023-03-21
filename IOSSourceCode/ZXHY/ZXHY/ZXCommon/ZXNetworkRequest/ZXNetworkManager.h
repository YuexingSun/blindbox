//
//  ZXNetworkManager.h
//  ZXHY
//
//  Created by Bern Mac on 8/3/21.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

//请求成功后的数据简单处理后的回调
typedef void (^SuccessBlock) (NSDictionary *resultDic);

//请求失败后的响应及错误实例
typedef void (^FailureBlock) (NSError *error);

@interface ZXNetworkManager : NSObject


//单例声明
+ (instancetype)shareNetworkManager;

//检测网络状态
-(void)zx_reachability;

//获取登录验证码
- (void)zx_reqApiGetLoginSMSCodeWithPhoneNum:(NSString *)phoneNum Ticket:(NSString *)ticket Randstr:(NSString *)randstr Success:(SuccessBlock)success Failure:(FailureBlock)failure;

//获取Token
- (void)zx_networkGetTokenWithSuccess:(SuccessBlock)success;

//POST
- (void)POSTWithURL:(NSString*)url Parameter:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

//GET
- (void)GETWithURL:(NSString*)url Parameter:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

//上传单张图片
- (void)zx_networkPOSTUploadImage:(UIImage *)image ImageToLimitSizeOfKB:(CGFloat)kb progress:(void (^)(id uploadProgress))progress success:(SuccessBlock)success failure:(FailureBlock)failure;

//上传多张图片
- (void)zx_networkPOSTUploadImages:(NSMutableArray *)images ImageToLimitSizeOfKB:(CGFloat)kb progress:(void (^)(id uploadProgress))progress success:(SuccessBlock)success failure:(FailureBlock)failure;

//图片大于多少kb的压缩
- (NSData*)dataCompressedImageToLimitSizeOfKB:(CGFloat)kb image:(UIImage*)image;

- (NSData *)compressBySizeWithMaxLength:(NSUInteger)maxLength
                         withImageData:(NSData *)imageData
                                    img:(UIImage *)img;
@end

NS_ASSUME_NONNULL_END
