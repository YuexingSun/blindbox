//
//  ZXValidationManager.h
//  ZXHY
//
//  Created by Bern Mac on 8/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ValidationTimeBlock) (NSInteger timeout);

@interface ZXValidationManager : NSObject


//单例声明
+ (instancetype)shareValidationManager;

//需要倒计时时间
- (void)zx_countDownTimeOut:(NSInteger)countDownTimeOut;

//关闭和销毁Timer
- (void)zx_closeAndDestroyed;


//时间回调Block
@property (nonatomic, strong) ValidationTimeBlock  timeBlock;

//Timer
@property (nonatomic, strong) dispatch_source_t countDownTimer;
  

@end

NS_ASSUME_NONNULL_END
