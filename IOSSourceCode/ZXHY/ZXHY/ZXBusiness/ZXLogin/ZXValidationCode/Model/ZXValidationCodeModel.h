//
//  ZXValidationCodeModel.h
//  ZXHY
//
//  Created by Bern Mac on 8/11/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXValidationCodeModel : NSObject

// (0/1)，是否新用户，1是新用户，0是老用户；如果是新用户，则客户端应弹出资料完善相关的标签表单等流程
@property (nonatomic, assign) NSInteger  isnew;
@property (nonatomic, strong) NSString   *token;

@end

NS_ASSUME_NONNULL_END
