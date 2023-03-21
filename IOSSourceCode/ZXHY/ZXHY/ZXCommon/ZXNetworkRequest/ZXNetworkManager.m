//
//  ZXNetworkManager.m
//  ZXHY
//
//  Created by Bern Mac on 8/3/21.
//

#import "ZXNetworkManager.h"
#import "Reachability.h"
#import "ZXNetworkUrl.h"
#import "ZXNetworkRequestModel.h"

#pragma - 文件类型
NSString *const ZXFileTypeImage = @"image";
NSString *const ZXFileTypeVideo = @"video";

@interface ZXNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *afManager;

@end

@implementation ZXNetworkManager

#pragma mark -  单例类初始化
+ (instancetype)shareNetworkManager
{
    static ZXNetworkManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.afManager = [AFHTTPSessionManager manager];
        //设置超时时间
        instance.afManager.requestSerializer.timeoutInterval = 20;
        instance.afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                        @"application/json",
                                                                        @"text/html",
                                                                        @"text/json",
                                                                        @"text/javascript",
                                                                        @"text/plain",
                                                                        @"application/x-www-form-urlencoded charset=utf-8",
                                                                        nil];
        
        
        //设置证书模式
//        NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"wifi" ofType:@"cer"];
//        NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
//        instance.afManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
        
//        // 客户端是否信任非法证书
//        instance.afManager.securityPolicy.allowInvalidCertificates = YES;
//        // 是否在证书域字段中验证域名
//        [instance.afManager.securityPolicy setValidatesDomainName:NO];
                
    });
    return instance;
}


#pragma mark - POST请求
- (void)POSTWithURL:(NSString*)url Parameter:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",ZX_ReqMainUrl,url];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:requestUrl parameters:nil error:nil];
    
    request.timeoutInterval= 20;
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    // 设置body
    NSMutableDictionary *dict;
    if ([parameters isKindOfClass:[NSDictionary class]]){
        dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }else if ([parameters isKindOfClass:[NSMutableDictionary class]]){
        dict = parameters;
    }
    
    [dict wg_safeSetObject:[ZXPersonalDataManager shareNetworkManager].zx_token forKey:@"token"];

    NSData *JSONdata = nil;
    if(dict){
        JSONdata = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    }
    [request setHTTPBody:JSONdata];
    
    
    NSURLSessionDataTask *task = nil;
    
    task = [self.afManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error){
       
        if (!error){
            NSLog(@"\n\n======请求地址:======\n%@\n\n======请求参数:======\n%@\n======请求结果:======\n%@\n",requestUrl,[dict wg_stringJSON],[responseObject wg_stringJSON]);
            
           if ([self dealWithReturnData:responseObject] == 0){
                success(responseObject);
            }else{
                failure(responseObject);
                [WGUIManager wg_hideHUDWithText:responseObject[@"msg"]];
            }
            
        }else{
            NSLog(@"\n\n======请求地址:======\n%@\n\n======请求参数:======\n%@\n======请求结果:======\n%@\n",requestUrl,dict,error);
            
            failure(error);
            
            if (![self isExistenceNetwork]) {
                [WGUIManager wg_hideHUDNetWorkError];;
            }
            [WGUIManager wg_hideHUDWithText:@"网络请求失败"];
        }

    }];
    [task resume];

}


#pragma mark - 上传单张图片
- (void)zx_networkPOSTUploadImage:(UIImage *)image ImageToLimitSizeOfKB:(CGFloat)kb progress:(void (^)(id uploadProgress))progress success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    
    [self zx_networkPOSTUploadImages:[NSMutableArray arrayWithObject:image] ImageToLimitSizeOfKB:kb progress:^(id uploadProgress) {
        progress(uploadProgress);
    } success:^(NSDictionary * _Nonnull resultDic) {
        success(resultDic);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma mark - 上传多张图片
- (void)zx_networkPOSTUploadImages:(NSMutableArray *)images ImageToLimitSizeOfKB:(CGFloat)kb progress:(void (^)(id uploadProgress))progress success:(SuccessBlock)success failure:(FailureBlock)failure{
   
    NSMutableArray *dataList = nil;
    
    if (!images.count) {
        [WGUIManager wg_hideHUDWithText:@"图片为空"];
        return;
    }
    
    for (UIImage *image in images){
       
        if (!dataList){
            dataList = [NSMutableArray arrayWithCapacity:[images count]];
        }
        
        NSData *data = [self dataCompressedImageToLimitSizeOfKB:kb image:image];
        
        [dataList wg_safeAddObject:data];
    }

    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",ZX_ReqMainUrl,ZX_ReqApiUploadFile];
    
    [self.afManager POST:requestUrl parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        for (NSData *data in dataList){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSString *fileName = [NSString stringWithFormat:@"imageiOS%@.png", str];
            
            [formData appendPartWithFileData:data name:@"file[]" fileName:fileName mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"\n\n======上传进度:======\n%@\n",uploadProgress);
        
        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"\n\n======上传地址:======\n%@\n\n======上传结果:======\n%@\n",requestUrl,[responseObject wg_stringJSON]);
        
        if ([self dealWithReturnData:responseObject] == 0){
             success(responseObject);
         }else{
             failure(responseObject);
             [WGUIManager wg_hideHUDWithText:responseObject[@"msg"]];
         }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"\n\n======上传地址:======\n%@\n\n======上传结果:======\n%@\n",requestUrl,error);
        
        failure(error);
        
        if (![self isExistenceNetwork]) [WGUIManager wg_hideHUDNetWorkError];
        
        [WGUIManager wg_hideHUDWithText:@"上传失败"];
    }];
}


#pragma mark - 大于多少kb的图片需要压缩
- (NSData*)dataCompressedImageToLimitSizeOfKB:(CGFloat)kb image:(UIImage*)image{
    if(!image){
        return nil;
    }
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    NSUInteger length = [imageData length] /1024;
    NSLog(@"压缩前大小imageData = %zdK，size %@",length, NSStringFromCGSize(image.size));
    if(length > kb){
        float compressedRatio = kb / length;
        return UIImageJPEGRepresentation(image, compressedRatio);
        
    }else{
        return imageData;
    }
}

- (NSData *)compressBySizeWithMaxLength:(NSUInteger)maxLength
                         withImageData:(NSData *)imageData
                                   img:(UIImage *)img{
    if(imageData.length <= maxLength){
        return imageData;
    }
    NSUInteger lastDataLength = 0;
    while (imageData.length > maxLength && imageData.length != lastDataLength) {
        lastDataLength = imageData.length;
        CGFloat ratio = (CGFloat)maxLength / imageData.length;
        CGSize size = CGSizeMake((NSUInteger)(img.size.width * sqrtf(ratio)),
                                 (NSUInteger)(img.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        imageData = UIImageJPEGRepresentation(img, 1);
    }
    return imageData;
}




#pragma mark - 检测网络状态
- (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork = false;
    Reachability *reachAblitity = [Reachability reachabilityForInternetConnection];
    switch ([reachAblitity currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=TRUE;
            break;
    }
    return isExistenceNetwork;
}

#pragma mark - 返回数据状态码判断
-(NSInteger)dealWithReturnData:(NSDictionary *)dic{
    
    ZXNetworkRequestModel *model = [ZXNetworkRequestModel wg_objectWithDictionary:dic];
    
    if ([model.code intValue] == 0){
        NSLog(@"\n正确请求成功");
        
    }else if ([model.code intValue] == 10003){
        NSLog(@"\ntoken过期或者无效 --- 重新登录");
        [[AppDelegate wg_sharedDelegate] zx_logoutActionIsRequest:NO];
        
    }else if ([model.code intValue] == 10010){
        NSLog(@"\nappid不存在");
        
    }else if ([model.code intValue] == 10011){
        NSLog(@"\nsecert错误");
        
    }

    return [model.code intValue];
}

#pragma mark - 获取Token
- (void)zx_networkGetTokenWithSuccess:(SuccessBlock)success{
    
    NSDictionary *dic = @{
        @"AppID":@"IOS",
        @"Secret":@"88888888"
        
    };
    [self POSTWithURL:ZX_ReqApiGetToken Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
        
        [ZXPersonalDataManager shareNetworkManager].zx_token = resultDic[@"data"][@"token"];
        success(resultDic);
    
    } failure:^(NSError * _Nonnull error) {
       
    }];
    

    
}

#pragma mark - 获取登录验证码
- (void)zx_reqApiGetLoginSMSCodeWithPhoneNum:(NSString *)phoneNum Ticket:(NSString *)ticket Randstr:(NSString *)randstr Success:(SuccessBlock)success Failure:(FailureBlock)failure{
    
    NSDictionary *dict = @{@"phone": phoneNum ?:@"",
                           @"ticket": ticket ?:@"",
                           @"randstr": randstr ?:@"",
    };

    [self POSTWithURL:ZX_ReqApiGetSMSCode Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        
        success(resultDic);
        
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];

    
}


#pragma mark - 检测网络状态
-(void)zx_reachability{
    
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];

    
    //2.监听网络状态的改变
    /*
        AFNetworkReachabilityStatusUnknown          = 未知
        AFNetworkReachabilityStatusNotReachable     = 没有网络
        AFNetworkReachabilityStatusReachableViaWWAN = 3G
        AFNetworkReachabilityStatusReachableViaWiFi = WIFI
        */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"\n\nreachability --------- 未知\n\n");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"\n\nreachability --------- 没有网络\n\n");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"\n\nreachability --------- 蜂窝\n\n");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"\n\nreachability --------- WIFI\n\n");
                break;

            default:
                break;
        }
        
        
        
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi){
            if (!kIsEmptyString([ZXPersonalDataManager shareNetworkManager].zx_token)){
                
                //检测是否需要强制更新
                [[AppDelegate wg_sharedDelegate] zx_reqApiGetInitDataIsForceUpdate];
                
                //发送是否网络状态是否改变
                [WGNotification postNotificationName:ZXNotificationMacro_NetworkStatus object:nil];
            }
            
        }
    }];
    
    
    

    //3.开始监听
    [manager startMonitoring];
}


@end

