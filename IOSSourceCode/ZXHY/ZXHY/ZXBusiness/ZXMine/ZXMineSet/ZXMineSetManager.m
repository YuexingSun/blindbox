//
//  ZXMineSetManager.m
//  ZXHY
//
//  Created by Bern Mac on 9/26/21.
//

#import "ZXMineSetManager.h"
#import "ZXMineUploadImageModel.h"

@implementation ZXMineSetManager

+ (instancetype)shareNetworkManager{
    
    static ZXMineSetManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


//对应数据赋值并提交
- (void)zx_setMineType:(ZXMineSetType)type Value:(NSString *)value Completion:(void(^)(void))completion{
    
    NSString *keyStr = @"";
    
    switch (type) {
        case ZXMineSetType_Icon:
        {
            keyStr = @"headimg";
        }
        break;
        
        case ZXMineSetType_nickName:
        {
            keyStr = @"nickname";
        }
        break;
            
        case ZXMineSetType_Mobile:
        {
            
        }
        break;
            
        case ZXMineSetType_Age:
        {
            keyStr = @"age";
        }
        break;
            
        case ZXMineSetType_Sex:
        {
            keyStr = @"sex";
        }
        break;
            
        case ZXMineSetType_Hobbies:
        {
            
        }
        break;
            
        case ZXMineSetType_Notice:
        {
            keyStr = @"notifystatus";
        }
        break;
            
        case ZXMineSetType_Cancellation:
        {
           
        }
        break;
            
        case ZXMineSetType_About:
        {
            
        }
        break;
            
        case ZXMineSetType_Exit:
        {
            
            
        }
        break;
            
        default:
            break;
    }
    
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:value forKey:keyStr];
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiSetUserProfile Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        completion();
    } failure:^(NSError * _Nonnull error) {

    }];
}



//上传头像
- (void)zx_setMineIconImage:(UIImage *)image Completion:(void (^)(NSString *imageUrl))completion{
    
    WEAKSELF;
    //上传图片
    [[ZXNetworkManager shareNetworkManager] zx_networkPOSTUploadImage:image ImageToLimitSizeOfKB:100 progress:^(id  _Nonnull uploadProgress) {
        
    } success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        ZXMineUploadImageModel *model = [ZXMineUploadImageModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
    
        NSString *url = [model.urllist wg_safeObjectAtIndex:0];
        [self zx_setMineType:ZXMineSetType_Icon Value:url Completion:^{
            completion(url);
        }];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


- (void)zx_setMineIcon:(UIImage *)iconImage NickName:(NSString *)name Age:(NSString *)age Sex:(NSString *)sex Completion:(void (^)(NSString *imageUrl))completion{

    if (iconImage){
        [self zx_setMineIconImage:iconImage Completion:^(NSString * _Nonnull imageUrl) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict wg_safeSetObject:imageUrl forKey:@"headimg"];
            [dict wg_safeSetObject:name forKey:@"nickname"];
            [dict wg_safeSetObject:age forKey:@"age"];
            [dict wg_safeSetObject:sex forKey:@"sex"];
            
            [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiSetUserProfile Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
                completion(imageUrl);
            } failure:^(NSError * _Nonnull error) {

            }];
        }];
    }
    else{
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict wg_safeSetObject:name forKey:@"nickname"];
        [dict wg_safeSetObject:age forKey:@"age"];
        [dict wg_safeSetObject:sex forKey:@"sex"];
        
        [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiSetUserProfile Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
            completion(nil);
        } failure:^(NSError * _Nonnull error) {

        }];
    }
    
    
}


@end
